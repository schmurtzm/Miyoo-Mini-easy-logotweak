#!/bin/sh
echo ----
echo $0 $*
progdir=`dirname "$0"`
homedir=$progdir/advmenu
echo progdir : $progdir
echo homedir : $homedir
echo ----

cd "$progdir"



if [ -f "/mnt/SDCARD/.tmp_update/onionVersion/version.txt" ]; then
	infoPanel -t "Easy LogoTweak" -m "LOADING...\n \nEasy LogoTweak by Schmurtz\nMusic : The World Of Douve by DOUVE" --persistent &
	LD_LIBRARY_PATH="./libs:$LD_LIBRARY_PATH"
else
	LD_LIBRARY_PATH="./libs:./bin:/customer/lib:/config/lib:/lib"
	say "Loading..."
fi

# each folder will use its own library folder (infoPanel & jpgr doesn't use the same libSDL_image-1.2.so.0) :


echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor


# running thumbnails_generator for AdvanceMenu
./thumbnails_generator.sh

touch /tmp/dismiss_info_panel


echo "Running advancemenu now !"
cd $homedir

# put backlight to max brightness (as during boot)
echo 255 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle


HOME=. ./advmenu

/customer/app/sysmon freemma

# restore initial backlight level
brightness=`/customer/app/jsonval brightness`
brightness_raw=`awk "BEGIN { print int(3 * exp(0.350656 * $brightness) + 0.5) }"`
echo "brightness: $brightness -> $brightness_raw"
echo $brightness_raw > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable
