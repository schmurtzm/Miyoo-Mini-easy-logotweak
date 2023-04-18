#!/bin/sh
sysdir=/mnt/SDCARD/.tmp_update
miyoodir=/mnt/SDCARD/miyoo
export LD_LIBRARY_PATH="./imagemagick/libs:/lib:/config/lib:$miyoodir/lib:$sysdir/lib:$sysdir/lib/parasyte"

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

if [ -z "$1" ] ; then
    Force=0
else
	Force=$1
fi


# Removing obsolete thumbnails
for file in ./thumbnails/*.png
do
    filename=$(basename "$file" .png)
    if [ ! -d "./logos/$filename" ] ; then
        echo removing "$file"
        rm "$file"
    fi
done

# Creating missing thumbnails
for d in ./logos/* ; do

	if [ -f "$d/image1.jpg" ]; then

		echo ============================= ${d##*/} =============================

		if [ ! -f "./thumbnails/${d##*/}.png" ] || [ "$Force" -eq 1 ] ; then
			# we create a png : rotated, half resolution, 140% of luminosity, color depth 8 bits
			echo "./imagemagick/magick \"$d/image1.jpg\" -rotate 180 -resize 50% -modulate 110 -depth 8 -define png:color-type=6 \"./thumbnails/${d##*/}.png\""
		    ./imagemagick/magick "$d/image1.jpg" -rotate 180 -resize 50% -modulate 110 -depth 8 -define png:color-type=6 "./thumbnails/${d##*/}.png"
		else
		    echo "${d##*/} already exist"
		fi
	fi

done
