# Miyoo Mini - Easy Logotweak  By Schmurtz
 An app for easy boot logo flashing on the Miyoo Mini

```
!! **                                    Use it at your own risk :                                    ** !!
!! ** logotweak write in the nand of the Miyoo Mini. A bad flash will cause your miyoo Mini to brick. ** !!
!! **      Check your battery level (don't use it with low battery level) and use a good SD card.     ** !!
```
Easy Logotweak uses the flash app "Boot logo changer" created by Eggs and described in [the Wiki of Onion](https://github.com/jimgraygit/Onion/wiki/6.-Miyoo-mini-apps#boot-logo-changer-credit-eggs).

Easy Logotweak is a based on a linux shell script which allows to backup your current boot logo, to choose a new one and to flash it in an easy way.
It is presented as an app in Miyoo Mini menu.

An excellent tutorial video made by RetroBreeze:

[![An excellent tutorial video made by RetroBreeze](https://img.youtube.com/vi/_GWbgp1Nw3s/0.jpg)](https://youtu.be/_GWbgp1Nw3s])

Logo included :

<img src="https://user-images.githubusercontent.com/7110113/173691818-00164a7a-e6e3-4152-b9b1-6e392562a1e0.png" width="200" height="200">




To use with Onion-OS :
```
	1 - copy logotweak folder in your app folder.
	2 - Run the app logotweak, and choose your logo during the slideshow. That' all : power off -> power on to see the result ;)
```
To use with MiniUI :
```
	1 - rename the folder to logotweak.pak
	2 - Put it in the Tools folder.
	3 - Run the app logotweak, and choose your logo during the slideshow. That' all : power off -> power on to see the result ;)
```
After that you will find a backup called backup_xxxxxxxx which contains a backup of your previous logo.

To add your own logo in the collection : 
```
	- create a new folder in app\logotweak\logos
	- Put your images files inside this new folder (image1.jpg is required,image2.jpg and image3.jpg are optional) 
	- Then you can run logotweak to see the result ;)
```


If you want more technical details read documentation below.



```
/*  Release Notes (yyyy/mm/dd):                                                             */
/*  v1.0 - 2022/06/10 :                                                                     */
/*    - Initial release                                                                     */
/*  v1.1 - 2022/06/10 :                                                                     */
/*    - Logos are now dynamically generated with logomake                                   */
/*      (so it's easier to add your own logos, no problem with different firmware version)  */
/*    - New logos included, preview it here                                                 */
/*  v1.2 - 2022/06/11 :                                                                     */
/*    - Logos preview doesn't require to generate a png anymore                             */
/*      (image1.jpg is used to display the preview directly, Thanks to eggs).               */
/*    - image2.jpg and image3.jpg (logos for FW update) are now optional,                   */
/*      by default the one from "Original" folder are used.                                 */
/*    - and two new logos from the community 😉.                                            */
```


miyoomini logo tweaking tools (original documentation - manual steps) :
***********************************************************************
```
** Mishandling will cause your miyoomini to brick. Use with extreme caution and at your own risk **

logoread	Extract logo images from current NAND
		image1.jpg ....	boot logo
		image2.jpg ....	upgrade screen
		image3.jpg .... super upgrade screen
		- All images are rotated 180 degrees

logomake	Make logo.img from image1,2,3.jpg
		- logo.img size is fixed to 128KB, so the total size of 3 jpg files 
		should be less than 128KB (129,732 bytes max actually)

logowrite	Flush logo.img to NAND
		* miyoomini will brick if image is corrupted. Be very careful *

To change the image, first extract the current images with logoread, modify the image, create logo.img with logomake, 
and then flush with logowrite.

( if the firmware is old (202111201656 or 202112110956), there is no super upgrade screen. in this case, 
logoread will fail to extract the 3rd image, so prepare a dummy image3.jpg after logoread )
```


=======================================================================

This section describe all the step necessary before the use of Easy Logotweak.

It can be usefull to understand all the steps of a custom boot logo flash.

------------------------------------------------
<details>
  <summary>Reddit Full Tutorial by GumbyXGames, Click here to read </summary>


https://www.reddit.com/r/MiyooMini/comments/v6e1f1/custom_boot_screen_tutorial/

1.Download the Boot Image Changer (https://github.com/jimgraygit/Onion/wiki/6.-Miyoo-mini-apps#boot-logo-changer-credit-eggs)

2.Extract the ZIP

3.Go into the resulting logotweak folder and move the following files out of the folder: image1.jpg, image2.jpg, and image3.jpg

4.Copy the logotweak folder to your microSD card

5.Put your microSD card back into your Mini and power it on

6.Open File Explorer under App from the main menu

7.Browse to the logotweak folder

8.Select logoread by highlighting it and pressing A

9.Select Execute. The screen will go black but then load the App Menu

10.Power the Mini off and remove the microSD card

11.In the logotweak folder on the microSD card there will now be three files: image1.jpg, image2.jpg, and image3.jpg

12.OPTIONAL: I suggest making a backup of the three files in case you want to go back to stock

13.Delete the image you are going to replace:
* image1.jpg is the image shown at boot
* image2.jpg is the image shown when performing a normal firmware update/upgrade
* image3.jpg is the image shown when performing a "Super Upgrade"

14.Copy the new images to the logotweak folder and rename them using the naming in step 13. Be sure the files match the dimensions and file size listed in logotweak_readme.txt

15.Put the microSD card back into your Mini and power it on.

16.Connect your Mini to a USB charger (5v, 1amp) using a USB-A-to-USB-C cable. Do not continue unless you have the Mini connected to external power or you risk bricking it.

17.Open File Explorer under App from the main menu

18.Browse to the logotweak folder

19.Select logomake by highlighting it and pressing A

20.Select Execute. The screen will go black but then load the App Menu

21.Open File Explorer again

22.Browse to the logotweak folder again

23.There should now be a logo.img file in the folder

24.As long as the logo.img folder is present, select logowrite and press A

25.Select Execute. The screen will go black but then load the App Menu

26.You have now flashed the new boot, upgrade, and super upgrade images to your device.

</details>
------------------------------------------------
=======================================================================




 ## Thanks
You like this project ? You want to improve this project ? 

Do not hesitate, **Participate**, there are many ways :
- If you don't know bash language you can test releases , and post some issues, some tips and tricks for daily use.
- If you're a coder or a graphist you can fork, edit and publish your modifications with Pull Request on github :)<br/>
- Or you can buy me a coffee to keep me awake during night coding sessions :dizzy_face: !<br/><br/>
[![Buy me a coffee][buymeacoffee-shield]][buymeacoffee]
<br/><br/>

[buymeacoffee-shield]: https://www.buymeacoffee.com/assets/img/guidelines/download-assets-sm-2.svg
[buymeacoffee]: https://www.buymeacoffee.com/schmurtz
 ===========================================================================
 
