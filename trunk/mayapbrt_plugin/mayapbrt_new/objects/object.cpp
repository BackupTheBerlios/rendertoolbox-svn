/*
 *  object.cpp
 *  mayapbrt
 *
 *  Created by Mark Colbert on 10/5/04.
 *  Copyright 2004 __MyCompanyName__. All rights reserved.
 *
 */

#include "object.h"

using namespace std;

namespace pbrt {
	
	std::ostream& operator<< (std::ostream& fout, const Object& obj) {
		obj.Insert(fout);
		return fout;
	}

}
