miyoomini logo tweaking tools by Eggs

** Mishandling will cause your miyoomini to brick. Use with extreme caution and at your own risk **

logoread	Extract logo images from current NAND
		image1.jpg ....	boot logo
		image2.jpg ....	upgrade screen
		image3.jpg .... super upgrade screen
		- All images are rotated 180 degrees

logomake	Make logo.img from image1,2,3.jpg
		- logo.img size is fixed to 128KB, so the total size of 3 jpg files should be less than 128KB (129,732 bytes max actually)

logowrite	Flush logo.img to NAND
		* miyoomini will brick if image is corrupted. Be very careful *

To change the image, first extract the current images with logoread, modify the image, create logo.img with logomake, and then flush with logowrite.

( if the firmware is old (202111201656 or 202112110956), there is no super upgrade screen. in this case, logoread will fail to extract the 3rd image, so prepare a dummy image3.jpg after logoread )
