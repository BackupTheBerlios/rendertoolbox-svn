/*
 *  pbrtexport.cpp
 *  mayapbrt
 *
 *  Created by Mark Colbert on 10/5/04.
 *  Copyright 2004 __MyCompanyName__. All rights reserved.
 *
 */

#include "pbrtexport.h"
#include "camera.h"
#include "light.h"
#include "mesh.h"

#include <fstream>
#include <iomanip>
#include <maya/MFnPlugin.h>
#include <maya/MItDag.h>
#include <maya/MGlobal.h>

using namespace std;

namespace pbrt {
	
	void* Export::creator() {
		return new Export;
	}
	
	// main loop of the plugin
	// this will open an output file and go  through all the visible meshes and
	// lights and put them in a pbrt format
	MStatus	Export::doIt( const MArgList& args) {
		MStatus status;
		MDagPath tempDagPath;
		
		if (args.length() < 2) {
			MGlobal::displayError("At least 2 arguments are required for PBRTExport");
			return MStatus::kFailure;
		}
		
		MString outputfile = args.asString(0, &status);
		if (!status) {
			MGlobal::displayError("Error parsing output file argument");
			return MStatus::kFailure;
		}

		MString imagefile = args.asString(1, &status);
		if (!status) {
			MGlobal::displayError("Error parsing image file argument");
			return MStatus::kFailure;
		}

		
		// initialize the output
		std::ofstream fout;
		fout.open(outputfile.asChar(), ios::out);
		fout << setprecision(9) << setiosflags(ios_base::fixed);	// make sure we keep the output readable to pbrt
				
		// create default camera and output it
		Camera cam(imagefile);
		fout << cam << "WorldBegin" << endl;
		
		// loop through all the lights
		MItDag lightItDag(MItDag::kDepthFirst, MFn::kLight, &status);
		for (; !lightItDag.isDone(); lightItDag.next()) {
			lightItDag.getPath(tempDagPath);
			
			// visibility test
			MFnDagNode visTest(tempDagPath);
			if (isVisible(visTest)) {
				Light* light = Light::LightFactory(tempDagPath);
				if (light) { 
					fout << *light << endl;
					delete light;
				}
			}
		}
		
		
		// loop through all the meshes
		MItDag meshItDag(MItDag::kDepthFirst, MFn::kMesh, &status);
		for (; !meshItDag.isDone(); meshItDag.next()) {
			meshItDag.getPath(tempDagPath);
			
			// visiblity test
			MFnDagNode visTest(tempDagPath);
			if (isVisible(visTest)) {
				Mesh mesh(tempDagPath);
				fout << mesh << endl;
			}
		}
		
		// finish off the output file
		fout << "WorldEnd" << endl;
		fout.close();
		
		return MStatus::kSuccess;
	}

	bool Export::isVisible(MFnDagNode & fnDag, MStatus *status) 
	//Summary:	determines if the given DAG node is currently visible
	//Args   :	fnDag - the DAG node to check
	//Returns:	true if the node is visible;		
	//			false otherwise
	{
		bool madeStatus = false;
		if (status == NULL) { status = new MStatus; madeStatus = true; }
		
		if(fnDag.isIntermediateObject())
			return false;

		MPlug visPlug = fnDag.findPlug("visibility", status);
		if (MStatus::kFailure == *status) {
			MGlobal::displayError("MPlug::findPlug");
			if (madeStatus) delete status;
			return false;
		} else {
			bool visible;
			*status = visPlug.getValue(visible);
			if (MStatus::kFailure == *status) {
				MGlobal::displayError("MPlug::getValue");
			}
			if (madeStatus) delete status;
			return visible;
		}
	}

}

MStatus initializePlugin( MObject obj )
{ 
	MStatus status;

	MFnPlugin plugin ( obj, "Mark Colbert", "6.0", "Any" );
	status = plugin.registerCommand( "pbrtexport", pbrt::Export::creator );
	if ( !status )
		status.perror("registerCommand");
	
	return status;
}

MStatus uninitializePlugin( MObject obj )
{
	MStatus status;

	MFnPlugin plugin( obj );
	status = plugin.deregisterCommand( "pbrtexport" );
	if ( ! status )
		status.perror("deregisterCommand");

	return status;
}