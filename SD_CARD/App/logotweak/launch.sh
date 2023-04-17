#!/bin/sh
# Easy LogoTweak v1.1
#	- Initial Release
# Easy LogoTweak v1.1
#	- Logos are now dynamically generated with logomake
# Easy LogoTweak v1.2
#	- Logos preview doesn't require to generate a png anymore (image1.jpg is used to generate preview, Thanks Eggs).
#	- image2.jpg and image3.jpg (logos for FW update) are now optional, by default the one from "_Original" folder are used.
# Easy LogoTweak v1.3
#	- Solve display preview problems on MiniUI
# Easy LogoTweak v2.0
#	- Can now navigate between logos with left/right keys
#	- Press select to see logo in fullscreen without instructions 
#	- Press menu to exit application                             
#	- Resolve a problem when displaying instructions on Onion-OS
#	- Indicates total of logos and current logo number
#	- Add a confirmation before flashing
#	- Doesn't backup anymore the current logo (useless most of the time)
# Easy LogoTweak v2.1
#	- Firmware version check
# Easy LogoTweak v2.2
#	- Additional logic for BoyaMicro chips
# Easy LogoTweak v2.3
#	- Miyoo Mini+ support
# Easy LogoTweak v2.4
#	- Check that used images are really a jpg files
#	- Fix Miyoo Mini+ screen offset on firmware 202303262339
# Easy LogoTweak v2.5
#	- Better jpg error messages when an image is not valid
#	- Default flash logos (image2.jpg and image3.jpg) are now more compressed -> 115KB available for the boot logo
#	- Fixes for complex paths
# Flash Application Credit: Eggs
# Script Logo Selector Credit: Schmurtz


progdir=`dirname "$0"`
cd $progdir


echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

HexEdit() {
	filename=$1
	offset=$2
	value="$3"
	binary_value=$(printf "%b" "\\x$value")
	printf "$binary_value" | dd of="$filename" bs=1 seek="$offset" conv=notrunc
}

checkjpg() {
	JpgFilePath=$1
	Filename=`basename "$JpgFilePath"`
	echo
	./bin/checkjpg "$JpgFilePath"
	if [ $? -eq 0 ]; then
		echo "$Filename is a valid VGA JPG file"
	elif [ $? -eq 1 ]; then
		./bin/blank
		./bin/say "$Filename is not a valid jpg file !"$'\n\n(Try to open it with your favorite image\neditor and \"save as\" -> jpg again)\n\nExiting without flash !'
		./bin/confirm any
		exit 0
	elif [ $? -eq 2 ]; then
		./bin/blank
		./bin/say "$Filename "$'doesn\'t have \nthe right resolution !\n\nIt should be 640x480 (VGA)\n\nExiting without flash !'
		./bin/confirm any
		exit 0
	else
	  echo "Unknown Checkjpg error occurred"
	  exit 0
	fi
}
			
			
MIYOO_VERSION=`/etc/fw_printenv miyoo_version`
MIYOO_VERSION=${MIYOO_VERSION#miyoo_version=}
echo "Current firmware version : $MIYOO_VERSION"
SUPPORTED_VERSION="202303262339" # last known firmware for the Mini+
if [ $MIYOO_VERSION -gt $SUPPORTED_VERSION ]; then
	./bin/blank
	./bin/say "Firmware not supported."$'\n Versions further 20230326\nare not supported for now.\n\nPress a key to return to app menu.'
	./bin/confirm any
	exit 0
fi



# Check for SPI write capability
CHECK_WRITE=`./bin/checkwrite`
CHECK_WRITE=$?

# Let's build a kind of array of all logos folders
i=0
echo "------------------------"
for d in ./logos/*/ ; do
        let i++;
		# Arrays aren't avaible on this shell, we use a variable name with a suffix number as workaround
        eval Dir$i=\"$d\"
        echo  "Dir$i = $d"
done
echo "------------------------"

j=1
DisplayInstructions=1

#  specific path force to use stock SDL or not , depending using Onion or MiniUI :
if [ -f "/mnt/SDCARD/.tmp_update/onionVersion/version.txt" ]; then
	LD_LIBRARY_PATH=$progdir/bin:$LD_LIBRARY_PATH
else
	LD_LIBRARY_PATH=$progdir/bin:/customer/lib:/config/lib:/lib
fi

while :
do
	# ./bin/blank   # not necessary when jpgr is executed
	# we affect the current selected folder to the variable "$d"
	eval d=\"\$Dir$j\"
	echo "------------------------"
	echo  "Current folder : Dir$j = $d"

	if [ -f "$d/image1.jpg" ]; then
	
		#./bin/show "$d/preview.png" # == old way==
		./bin/jpgr "$d/image1.jpg"   # == Displays a rotated preview of the jpeg file
		
		if [ "$KeyPressed" = "select" ]; then    # == if select has been pressed we don't display the text instructions
			if [ "$DisplayInstructions" = "1" ]; then
				DisplayInstructions=0
			else
				DisplayInstructions=1
			fi
		fi
		
		if [ "$DisplayInstructions" = "1" ]; then
			./bin/say "$j/$i Flash this logo ?"$'\n\n\n\n\nA = flash  Select = fullscreen  Menu = quit\n<-/-> show prev/next logo\n'
		fi
	else
		# if the current image1.jpg is missing, we describe the problem on the screen
		echo "$d/image1.jpg is missing..."
		./bin/say "image1.jpg is missing in folder"$'\n'"$d"$'\n\n\n\nMenu = quit\n<-/-> show prev/next logo'
		#./bin/say "preview.png is missing"$'\n'"Run tools\Create_Previews.bat" # == old way==
	fi

	# we run a little tool to catch the last pressed key
	KeyPressed=$(./bin/getkey)
	sleep 0.15  # Little debounce
	echo $KeyPressed

	if [ "$KeyPressed" = "left" ]; then
		if [ $j -eq 1 ]; then # == already at minimal index
			./bin/blank
			./bin/say "Already on first logo !"$'\n'
			sleep 0.7
		fi
		
		if [ $j -gt 1 ]; then
			let "j--";
		fi
	fi

	if [ "$KeyPressed" = "right" -o "$KeyPressed" = "B"  ]; then
		if [ $j -eq $i ]; then # == already at maximal index
			./bin/blank
			./bin/say "Already on last logo !"$'\n'
			sleep 0.7
		fi
		
		if [ $j -lt $i ]; then
			let "j++";
		fi
	fi

	if [ "$KeyPressed" = "menu" ]; then
		exit
	fi

	# if we press "A" for flashing and the current image exists
	if [ "$KeyPressed" = "A" ] && [ -f "$d/image1.jpg" ]; then
	
		./bin/blank
		./bin/say "Really want to flash ?"$'\n\n A = Confirm    B = Cancel'
		sleep 0.5
		if  ./bin/confirm; then 
			echo "=== Start flashing ==="
			
			rm "$progdir/logo.img"

			cp "$d/image1.jpg" $progdir
			
			# if image2.jpg and image3.jpg are not here we get it from the "_Original" folder
			if [ -f "$d/image2.jpg" ]; then
				cp "$d/image2.jpg" $progdir
			else
				./bin/blank
				./bin/say "Importing default stock image"$'\n'"for \"System Upgrade\" screen."
				sleep 1.5
				cp "./logos/_Original/image2.jpg" $progdir
			fi

			if [ -f "$d/image3.jpg" ]; then
				cp "$d/image3.jpg" $progdir
			else
				./bin/blank
				./bin/say "Importing default stock image"$'\n'"for \"Super Upgrade\" screen."
				sleep 1.5
				cp "./logos/_Original/image3.jpg" $progdir
			fi
			
			# We check if each file is really a jpg file. (and not png files renamed).
			checkjpg "./image1.jpg"
			checkjpg "./image2.jpg"
			checkjpg "./image3.jpg"
			
			# we create the logo.img
			./bin/logomake
			
			
			if [ "$MIYOO_VERSION" -eq "202303262339" ]; then
				# Patch screen offset for the Mini+
				HexEdit "$progdir/logo.img" 1086 2C
				HexEdit "$progdir/logo.img" 1088 4C
			fi


			# just in case we check the size of the created logo.img
			myfilesize=$(wc -c "$progdir/logo.img" | awk '{print $1}')
			
			if [ "$myfilesize" = "131072" ]; then
				./bin/blank
				./bin/say "${myfilesize}kb : Right file size"
				sleep 1.5
				# == We don't backup anymore the current logo (useless most of the time) ==
				# ./bin/blank
				# ./bin/say "Backuping current logo..."
				# ./bin/logoread
				# BackupFolder=backup_$(date +%Y%m%d_%H%M%S)
				# mkdir ./$BackupFolder
				# mv ./image1.jpg ./$BackupFolder
				# mv ./image2.jpg ./$BackupFolder
				# mv ./image3.jpg ./$BackupFolder
				# sleep 1
				if [ $CHECK_WRITE -eq 0 ]; then
					./bin/blank
					./bin/say "Flashing..."
					./bin/logowrite
					sleep 1.5
					./bin/blank
					./bin/say "Flash Done."$'\n Reboot to see changes.\n\nPress a key to return to app menu.'
					./bin/confirm any
					exit 0
				fi
				if [ $CHECK_WRITE -eq 1 ]; then
					./bin/blank
					./bin/say "Creating logo fw file..."
					./bin/logoimgmake
					mv ./miyoo283_fw.img /mnt/SDCARD/miyoo283_fw.img
					sleep 1.5
					./bin/blank
					./bin/say "IMG file created."$'\n Power off, hold MENU\nand plug into USB charger\nTurn off when charging\nanimation is shown.'
					./bin/confirm any
					exit 0
				fi
			else
				./bin/blank
				./bin/say "logo.img doesn t have the right size"$'\n'"Exiting without flash !"
				sleep 3
				exit 0
			fi
		else
			./bin/blank
			./bin/say "Cancelling"
			sleep 1
		fi
	fi
done

