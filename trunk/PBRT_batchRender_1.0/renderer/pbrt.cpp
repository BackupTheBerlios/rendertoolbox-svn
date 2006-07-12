
/*
 * pbrt source code Copyright(c) 1998-2005 Matt Pharr and Greg Humphreys
 *
 * All Rights Reserved.
 * For educational use only; commercial use expressly forbidden.
 * NO WARRANTY, express or implied, for this software.
 * (See file License.txt for complete license)
 */

// pbrt.cpp*
#define OUTPUT_DEF

#include "pbrt.h"
#include "api.h"



// main program
int main(int argc, char *argv[]) {

	// Print welcome banner
	printf("pbrt version %1.3f of %s at %s\n",
	       PBRT_VERSION, __DATE__, __TIME__);
	printf("Copyright (c)1998-2005 Matt Pharr and "
	       "Greg Humphreys.\n");
	printf("For educational use only; commercial use expressly forbidden.\n");
	printf("\n**PBRT_batchRender_1.0\n**Daniel Lichtman danielp73@gmail.com\n");

	
	fflush(stdout);
	pbrtInit();
	// Process scene description
	//(dpl)original pbrt parses a scene from the standard input if no arguments
	//are passed to the program. here, we expect the first argument to be
	//the name of the file into which pbrt will write the image, pixel by pixel.
	//-if no arguments are supplied, pbrt parses from the standard input and assigns
	//a default name of "raw_image.dat" to the output.
	//-if there is only one supplied argument, pbrt assumes this is the name of the
	//script that it will parse and assigns the default name for the output file
	//-if there are two or more arguments, pbrt assumes
	//that the first one is the name of the output file and the following arguments
	//are scripts to be parsed and rendered
	if (argc == 1) {
		OUTPUT_NAME="raw_image.dat";	
		ParseFile("-");
	} else if (argc == 2) {
		OUTPUT_NAME="raw_image.dat";
		if ( !ParseFile(argv[1]))
			Error("Couldn't open scene file \"%s\"\n", argv[1]);	
	} else {
		OUTPUT_NAME=argv[1];
		// Parse scene from input files
		for (int i = 2; i < argc; i++)
			if (!ParseFile(argv[i]))
				Error("Couldn't open scene file \"%s\"\n", argv[i]);
	}
	pbrtCleanup();
	
	return 0;
}
