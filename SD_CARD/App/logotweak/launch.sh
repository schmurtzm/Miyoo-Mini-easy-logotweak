#!/bin/sh
# logotweak v1.1
#	Initial Release
# logotweak v1.1
#	Logos are now dynamically generated with logomake
# logotweak v1.2
#	Logos preview doesn't require to generate a png anymore (image1.jpg is used to generate preview, Thanks Eggs).
#	image2.jpg and image3.jpg (logos for FW update) are now optional, by default the one from "Original" folder are used.

# Flash Application Credit: Eggs
# Script Logo Selector Credit: Schmurtz

progdir=`dirname "$0"`

cd $progdir



./UI/blank
for d in ./logos/* ; do
	./UI/blank

	#./UI/show $d/confirm.png
	if [ -f "$d/image1.jpg" ]; then
		#./UI/show "$d/preview.png" # == old way==
		LD_LIBRARY_PATH=$progdir/UI:$LD_LIBRARY_PATH ./UI/jpgr "$d/image1.jpg"
	else
		./UI/say "image1.jpg is missing of this folder..."
		#./UI/say "preview.png is missing"$'\n'"Run tools\Create_Previews.bat" # == old way==
		sleep 4
		./UI/blank
	fi

	sleep 0.4
	./UI/say "Flash this logo ?"$'\n\n\n\n\nA = yes\nB = no, show next logo'

	if ./UI/confirm; then
	
		cp "$d/image1.jpg" $progdir
		
		
		# if image2.jpg and image3.jpg are not here we get it from the "Original" folder
		if [ -f "$d/image2.jpg" ]; then
			cp "$d/image2.jpg" $progdir
		else
			./UI/blank
			./UI/say "Logo for FW update is missing"$'\n'"Taking FW logo by default..."
			sleep 0.5
			cp "./logos/Original/image2.jpg" $progdir
		fi

		if [ -f "$d/image3.jpg" ]; then
			cp "$d/image3.jpg" $progdir
		else
			./UI/blank
			./UI/say "Logo for FW update is missing"$'\n'"Taking FW logo by default..."
			sleep 0.5
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
			./UI/blank
			./UI/say "Backuping current logo..."
			./logoread
			BackupFolder=backup_$(date +%Y%m%d_%H%M%S)
			mkdir ./$BackupFolder
			mv ./image1.jpg ./$BackupFolder
			mv ./image2.jpg ./$BackupFolder
			mv ./image3.jpg ./$BackupFolder
			sleep 1
			./UI/blank
			./UI/say "Flashing..."
			./logowrite
			sleep 1.5
			./UI/blank
			./UI/say "Flash Done."$'\n Reboot to see changes.\n\nPress a key to return to app menu.'
			./UI/confirm any
			exit 0
		else
			./UI/blank
			./UI/say "logo.img doesn t have the right size"$'\n'"exiting without flash !"
			sleep 2
			exit 0
		fi
		
	else
	
		./UI/blank
		./UI/say "Next"$'\n'
		sleep 0.1
		
	fi
done

./UI/blank
./UI/say "End of logos list"$'\n'"Run again to choose your logo."
./UI/confirm any


