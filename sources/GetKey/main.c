#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <linux/input.h>
#include <linux/fb.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <unistd.h>


#define BUTTON_UP 		KEY_UP
#define BUTTON_DOWN 		KEY_DOWN
#define BUTTON_LEFT 		KEY_LEFT
#define BUTTON_RIGHT 		KEY_RIGHT

#define BUTTON_A 		KEY_SPACE
#define BUTTON_B 		KEY_LEFTCTRL
#define BUTTON_X 		KEY_LEFTSHIFT
#define BUTTON_Y 		KEY_LEFTALT

#define BUTTON_START 		KEY_ENTER
#define BUTTON_SELECT 		KEY_RIGHTCTRL
#define BUTTON_MENU	 	KEY_ESC

#define BUTTON_L 		KEY_E
#define BUTTON_R 		KEY_T
#define BUTTON_L2 		KEY_TAB
#define BUTTON_R2 		KEY_BACKSPACE

#define BUTTON_POWER 		KEY_POWER



char * main(int argc , char* argv[]) {

	char * KEY_PRESSED;		
	
	int input_fd = open("/dev/input/event0", O_RDONLY);
	struct input_event	event;
	while (read(input_fd, &event, sizeof(event))==sizeof(event)) {
		if (event.type!=EV_KEY || event.value>1) continue;
		if (event.type==EV_KEY) {
	  
		       switch ( event.code )
		      {
			 case BUTTON_UP:
			    printf  ("up", KEY_PRESSED);
			    break;
			 case BUTTON_DOWN:
			    printf  ("down", KEY_PRESSED);
			    break;
			 case BUTTON_LEFT:
			    printf  ("left", KEY_PRESSED);
			    break;
			 case BUTTON_RIGHT:
			    printf  ("right", KEY_PRESSED);
			    break;
			 case BUTTON_A:
			    printf  ("A", KEY_PRESSED);
			    break;
			 case BUTTON_B:
			    printf  ("B", KEY_PRESSED);
			    break;
			 case BUTTON_X:
			    printf  ("X", KEY_PRESSED);
			    break;
			 case BUTTON_Y:
			    printf  ("Y", KEY_PRESSED);
			    break;
			 case BUTTON_START:
			    printf  ("start", KEY_PRESSED);
			    break;
			 case BUTTON_SELECT:
			    printf  ("select", KEY_PRESSED);
			    break;
			 case BUTTON_L:
			    printf  ("L", KEY_PRESSED);
			    break;
			 case BUTTON_R:
			    printf  ("R", KEY_PRESSED);
			    break;
			 case BUTTON_MENU:
			    printf  ("menu", KEY_PRESSED);
			    break;
			 case BUTTON_L2:
			    printf  ("L2", KEY_PRESSED);
			    break;
			 case BUTTON_R2:
			    printf  ("R2", KEY_PRESSED);
			    break;
			 case BUTTON_POWER:
			    printf  ("power", KEY_PRESSED);
			    break;
			 default:
			    printf  ("unknown", KEY_PRESSED);
			 
		      }
		      //puts (KEY_PRESSED);
		      printf  ("%c\n", KEY_PRESSED);
		      break;	
			
		}
	}

	// clear screen
	// int fb0_fd = open("/dev/fb0", O_RDWR);
	// struct fb_var_screeninfo vinfo;
	// ioctl(fb0_fd, FBIOGET_VSCREENINFO, &vinfo);
	// int map_size = vinfo.xres * vinfo.yres * (vinfo.bits_per_pixel / 8); // 640x480x4
	// char* fb0_map = (char*)mmap(0, map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fb0_fd, 0);
	// memset(fb0_map, 0, map_size);
	// munmap(fb0_map, map_size);
	// close(fb0_fd);

	close(input_fd);

	return KEY_PRESSED;
}
