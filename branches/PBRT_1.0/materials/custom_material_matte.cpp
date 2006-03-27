//
// Dan Lichtman
// 23 August 2004
// custom_material_matte material cpp source code. 

#include "pbrt.h"
#include "material.h"
#include <string.h>

class custom_material_matte : public Material {
public:
	custom_material_matte(Reference<Texture<Spectrum> > kd) {
		Kd = kd;
	}
	BSDF *GetBSDF(const DifferentialGeometry &dgGeom,
	              const DifferentialGeometry &dgShading) const;
private:
	Reference<Texture<Spectrum> > Kd;
};

BSDF *custom_material_matte::GetBSDF(const DifferentialGeometry &dgGeom,
		const DifferentialGeometry &dgShading) const {
	
	//not sure about this yet
	DifferentialGeometry dgs=dgShading;
	
	//or this:
	//allocate memory for BSDF, poiting bsdf to a new BSDF
	BSDF *bsdf = BSDF_ALLOC(BSDF)(dgs, dgGeom.nn);
	
	//allocate to diff a custom BxDF with reflection spectrum kd
	Spectrum kd = Kd->Evaluate(dgs).Clamp();
	BxDF *diff = BSDF_ALLOC(custom_BxDF_Lambertian)(kd);
		
	//add both diff and spec BSDFS to the BSDF of this material
	bsdf->Add(diff);
	
	return bsdf;
}
// custom_material_phong Dynamic Creation Routine
extern "C" DLLEXPORT Material * CreateMaterial(const Transform &xform,
		const TextureParams &mp) {
	Reference<Texture<Spectrum> > Kd = mp.GetSpectrumTexture("Kd", Spectrum(1.f));
	return new custom_material_matte(Kd);
}
