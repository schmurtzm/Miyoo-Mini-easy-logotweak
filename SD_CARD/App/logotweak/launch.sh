#!/bin/sh
# Easy LogoTweak v1.1
#	- Initial Release
# Easy LogoTweak v1.1
#	- Logos are now dynamically generated with logomake
# Easy LogoTweak v1.2
#	- Logos preview doesn't require to generate a png anymore (image1.jpg is used to generate preview, Thanks Eggs).
#	- image2.jpg and image3.jpg (logos for FW update) are now optional, by default the one from "Original" folder are used.
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
# Flash Application Credit: Eggs
# Script Logo Selector Credit: Schmurtz

MIYOO_VERSION=`/etc/fw_printenv miyoo_version`
MIYOO_VERSION=${MIYOO_VERSION#miyoo_version=}
echo ========================================================-- $MIYOO_VERSION   
SUPPORTED_VERSION="202303262339" # last known firmware for the Mini+
if [ $MIYOO_VERSION -gt $SUPPORTED_VERSION ]; then
	./UI/blank
	./UI/say "Firmware not supported."$'\n Versions further 20230326\nare not supported for now.\n\nPress a key to return to app menu.'
	./UI/confirm any
	exit 0
fi

progdir=`dirname "$0"`

cd $progdir

# Check for SPI write capability
CHECK_WRITE=`./checkwrite`
CHECK_WRITE=$?

# Let's build a kind of array of all logos folders
i=0

for d in ./logos/*/ ; do
        let i++;
		# Arrays aren't avaible on this shell, we use a variable name with a suffix number as workaround
        eval Dir$i=\"$d\"
        eval echo  "\$Dir$i  ----  $d  ----- $i"
		echo ------------------------
done

j=1
DisplayInstructions=1

while :
do
	./UI/blank
	# we affect the current selected folder to the variable "$d"
	eval d=\"\$Dir$j\"
	eval echo j = $j  ----  \$Dir$j   ------ $d

	if [ -f "$d/image1.jpg" ]; then
		#  specific path force to use stock SDL or not , depending using Onion or MiniUI :
		if [ -f "/mnt/SDCARD/.tmp_update/onionVersion/version.txt" ]; then
			LD_LIBRARY_PATH=$progdir/UI:$LD_LIBRARY_PATH
		else
			LD_LIBRARY_PATH=$progdir/UI:/customer/lib:/config/lib:/lib
		fi
	
		#./UI/show "$d/preview.png" # == old way==
		./UI/jpgr "$d/image1.jpg"   # == Displays a rotated preview of the jpeg file
		
		echo ========================================================-- $DisplayInstructions   1
		if [ "$KeyPressed" = "select" ]; then    # == if select has been pressed we don't display the text instructions
		echo ========================================================-- $DisplayInstructions   2
		if [ "$DisplayInstructions" = "1" ]; then
			DisplayInstructions=0
			echo ========================================================-- $DisplayInstructions   3
		else
			DisplayInstructions=1
			echo ========================================================-- $DisplayInstructions   4
		fi
		fi
		
		if [ "$DisplayInstructions" = "1" ]; then
			./UI/say "$j/$i Flash this logo ?"$'\n\n\n\n\nA = flash  Select = fullscreen  Menu = quit\n<-/-> show prev/next logo\n'
			echo ========================================================-- $DisplayInstructions   5
		fi
	else
		# if the current image1.jpg is missing, we describe the problem on the screen
		echo "$d/image1.jpg is missing..."
		./UI/say "image1.jpg is missing in folder"$'\n'"$d"$'\n\n\n\nMenu = quit\n<-/-> show prev/next logo'
		#./UI/say "preview.png is missing"$'\n'"Run tools\Create_Previews.bat" # == old way==
	fi

	# we run a little tool to catch the last pressed key
	KeyPressed=$(./UI/getkey)
	sleep 0.2  # Little debounce
	echo $KeyPressed

	if [ "$KeyPressed" = "left" ]; then
		if [ $j -eq 1 ]; then # == already at minimal index
			./UI/blank
			./UI/say "Already on first logo !"$'\n'
			sleep 0.7
		fi
		
		if [ $j -gt 1 ]; then
			let "j--";
		fi
	fi

	if [ "$KeyPressed" = "right" -o "$KeyPressed" = "B"  ]; then
		if [ $j -eq $i ]; then # == already at maximal index
			./UI/blank
			./UI/say "Already on last logo !"$'\n'
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
		./UI/blank
		./UI/say "Really want to flash ?"$'\n\n A = Confirm    B = Cancel'
		sleep 0.5
		if  ./UI/confirm; then 
			echo "=== Start flashing ==="

			cp "$d/image1.jpg" $progdir
			
			# if image2.jpg and image3.jpg are not here we get it from the "Original" folder
			if [ -f "$d/image2.jpg" ]; then
				cp "$d/image2.jpg" $progdir
			else
				./UI/blank
				./UI/say "No logo for FW update"$'\n'"Taking FW logo by default..."
				sleep 1
				cp "./logos/Original/image2.jpg" $progdir
			fi

			if [ -f "$d/image3.jpg" ]; then
				cp "$d/image3.jpg" $progdir
			else
				./UI/blank
				./UI/say "No logo for FW update"$'\n'"Taking FW logo by default..."
				sleep 1
				cp "./logos/Original/image3.jpg" $progdir
			fi
			
			# we create the logo.img
			./logomake
			
			# just in case we check the size of the created logo.img
			myfilesize=$(wc -c "$progdir/logo.img" | awk '{print $1}')
			
			if [ "$myfilesize" = "131072" ]; then
				./UI/blank
				./UI/say "${myfilesize}kb : Right file size"
				sleep 1
				# == We don't backup anymore the current logo (useless most of the time) ==
				# ./UI/blank
				# ./UI/say "Backuping current logo..."
				# ./logoread
				# BackupFolder=backup_$(date +%Y%m%d_%H%M%S)
				# mkdir ./$BackupFolder
				# mv ./image1.jpg ./$BackupFolder
				# mv ./image2.jpg ./$BackupFolder
				# mv ./image3.jpg ./$BackupFolder
				# sleep 1
				if [ $CHECK_WRITE -eq 0 ]; then
					./UI/blank
					./UI/say "Flashing..."
					./logowrite
					sleep 1.5
					./UI/blank
					./UI/say "Flash Done."$'\n Reboot to see changes.\n\nPress a key to return to app menu.'
					./UI/confirm any
					exit 0
				fi
				if [ $CHECK_WRITE -eq 1 ]; then
					./UI/blank
					./UI/say "Creating logo fw file..."
					./logoimgmake
					mv ./miyoo283_fw.img /mnt/SDCARD/miyoo283_fw.img
					sleep 1.5
					./UI/blank
					./UI/say "IMG file created."$'\n Power off, hold MENU\nand plug into USB charger\nTurn off when charging\nanimation is shown.'
					./UI/confirm any
					exit 0
				fi
			else
				./UI/blank
				./UI/say "logo.img doesn t have the right size"$'\n'"exiting without flash !"
				sleep 3
				exit 0
			fi
		else
			./UI/blank
			./UI/say "Cancelling"
			sleep 1
		fi
	fi
done

