#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <fcntl.h>

int main(int argc , char* argv[]) {
	uint8_t		readbuf[8];
	uint32_t	segsize, x, y, quit;
	int		fd;

	if (argc != 2) { puts("Usage: checkjpg jpeg_filename"); return 1; }

	fd = open(argv[1], O_RDONLY);
	if (fd < 0) { puts("failed to open"); return 1; }

	if (read(fd, readbuf, 2) != 2) { puts("failed to read"); return 1; }
	if ((readbuf[0] != 0xFF)||(readbuf[1] != 0xD8)) { puts("file is not jpeg"); return 1; }

	x = y = quit = 0;
	while(!quit) {
		if (read(fd, readbuf, 4) != 4) { puts("failed to read"); return 1; }
		if (readbuf[0] != 0xFF) { puts("jpeg format error"); return 1; }
		segsize = ((readbuf[2]<<8) | readbuf[3]) - 2;
		switch(readbuf[1]) {
			case 0xC0:
			case 0xC1:
			case 0xC2:
			case 0xC3:
			case 0xC5:
			case 0xC6:
			case 0xC7:
			case 0xC9:
			case 0xCA:
			case 0xCB:
			case 0xCD:
			case 0xCE:
			case 0xCF:
				if (read(fd, readbuf, 5) != 5) { puts("failed to read"); return 1; }
				segsize -= 5;
				x = ((readbuf[3]<<8) | (readbuf[4]));
				y = ((readbuf[1]<<8) | (readbuf[2]));
				break;
			case 0xDA:
				quit = 1;
				break;
			default:
				break;
		}
		lseek(fd, segsize, SEEK_CUR);
	}
	close(fd);

	if ((x!=640)||(y!=480)) { puts("file is jpeg but not VGA sized"); return 2; }

	puts("file is VGA sized jpeg");
	return 0;
}
