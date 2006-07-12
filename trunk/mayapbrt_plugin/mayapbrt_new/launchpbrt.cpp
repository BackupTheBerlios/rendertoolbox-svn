/*
 *  launchpbrt.cpp
 *  mayapbrt
 *
 *  Created by Mark Colbert on 10/17/04.
 *  Copyright 2004 __MyCompanyName__. All rights reserved.
 *
 */

#include <maya/MSimple.h>
#include <maya/MStatus.h>
#include <maya/MGlobal.h>
#include <maya/MProgressWindow.h>
#include <string>
#include <pthread.h>

using namespace std;

#include <stdlib.h>
#include <iostream>

static bool rendering;
void *render(void *arg);
void *progress(void *arg);

DeclareSimpleCommand(LaunchPBRT, "Mark Colbert", "6.0");

MStatus LaunchPBRT::doIt( const MArgList &args ) {
	MString arg;
	MStatus status;
	
	if (args.length() < 1) {
		MGlobal::displayError("LaunchPBRT must have an input file to launch");
		return MStatus::kFailure;
	}
	
	arg = args.asString(0, &status);
	if (!status) {
		MGlobal::displayError("Error parsing argument");
		return MStatus::kFailure;
	}
	
	// get the pbrt search path from the environment
	string searchpath = getenv("PBRT_SEARCHPATH");
	if (searchpath == "PBRT_SEARCHPATH=") { 
		MGlobal::displayError("PBRT_SEARCH path not set");
		return MStatus::kFailure;
	}
	
	// set executable path
	string executable = searchpath + "/pbrt";
	executable += " ";
	executable += arg.asChar();	
	
	rendering = true;
	pthread_t renderThread, progressThread;
	
	char *exec = const_cast<char *> (executable.c_str());
	if (pthread_create(&renderThread, NULL, render,  (void*) exec) < 0) {
		MGlobal::displayError("Unable to create render thread");
		return MStatus::kFailure;
	}
	if (pthread_create(&progressThread, NULL, progress, NULL) < 0) {
		MGlobal::displayError("Unable to create progress thread");
		return MStatus::kFailure;
	}
	
	int returnVal[1];
	pthread_join(renderThread, (void**) &returnVal);
	
	return MStatus::kSuccess;
	
}

void *render(void *arg) {
	cout << (const char*) arg << endl;
	system((const char*) arg);
	rendering = false;
	return NULL;
}

void *progress(void *arg) {
	MStatus status;
	
	if (!MProgressWindow::reserve())
	{
		MGlobal::displayError("Progress window already in use.");
		status = MS::kFailure;
		return NULL;
	}
	
	MProgressWindow::setProgressRange(0, 100);
	MProgressWindow::setTitle("PBRT Rendering");
	MProgressWindow::setInterruptable(false);
	MProgressWindow::setProgress(0);
	
	MProgressWindow::startProgress();
	
	int i=0;
	while (rendering) {
		i = (i+1)%100;
		MProgressWindow::setProgress(i);		
		sleep(2);
	}
	
	MProgressWindow::endProgress();
	
	return NULL;
}
