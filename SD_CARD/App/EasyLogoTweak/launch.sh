#!/bin/sh
echo $0 $*
progdir=`dirname "$0"`
homedir=$progdir/advmenu

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

infoPanel -t "Easy LogoTweak" -m "LOADING...\n \nEasy LogoTweak by Schmurtz\nMusic : The World Of Douve by DOUVE" --persistent &

# running thumbnails_generator for AdvanceMenu
./thumbnails_generator.sh

touch /tmp/dismiss_info_panel


echo "Running advancemenu now !"
cd $homedir

# put backlight to max brightness (as during boot)
echo 255 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
HOME=/mnt/SDCARD/App/EasyLogoTweak/advmenu ./advmenu

/customer/app/sysmon freemma

# restore initial backlight level
brightness=`/customer/app/jsonval brightness`
brightness_raw=`awk "BEGIN { print int(3 * exp(0.350656 * $brightness) + 0.5) }"`
echo "brightness: $brightness -> $brightness_raw"
echo $brightness_raw > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable
