/*
 *  spotlight.cpp
 *  mayapbrt
 *
 *  Created by Mark Colbert on 10/9/04.
 *  Copyright 2004 __MyCompanyName__. All rights reserved.
 *
 */

#include "spotlight.h"

#include <maya/MColor.h>
#include <maya/MPoint.h>
#include <maya/MVector.h>
#include <maya/MMatrix.h>
#include <maya/MItGeometry.h>
#include <maya/MGlobal.h>

namespace pbrt {
	void SpotLight::Insert(std::ostream& fout) const {
		MStatus status;
			
		//get name and output it
		MString name = dagPath.partialPathName();
		fout << "#SpotLightName:" << name.asChar() << std::endl;
			
		fout << "TransformBegin" << std::endl;
		
		if (TranslationMatrix(fout) != MStatus::kSuccess) { MGlobal::displayError("Error in outputting light translation"); return; }
		
		// get the color data
		MColor color = light.color();
		float intensity = light.intensity();
		
	
		// output the light source

		
		//(output just the R intensity so that it can work with mono spectral pbrt as is.
		//this will be changed by the render toolbox. we leave it like this so we can do
		//a quick rendering of this file with pbrt manually)
		fout << "LightSource \"spot\" ";
		fout << "\"color I\" [" << color.r*intensity << "]" << " ";
		fout << "\"point from\" [0 0 0] \"point to\" [0 0 -1]" << std::endl;
		fout << "\"float coneangle\" [" << light.coneAngle()*180.f/M_PI << "]" << " ";
		fout << "\"float conedeltaangle\" [" << light.dropOff()*180.f/M_PI << "]" << std::endl;
		fout << "TransformEnd" << std::endl;
		
	}
	
}
