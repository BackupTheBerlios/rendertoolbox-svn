//reduced custom source
//ward model material
//dpl 11 august 2005

// custom_material_ward.cpp*
#include "pbrt.h"
#include "material.h"
#include <string.h>
// Custom Class Declarations
class custom_material_ward : public Material {
public:
	// Plastic Public Methods
	custom_material_ward(Reference<Texture<Spectrum> > kd,
			Reference<Texture<Spectrum> > ks, 
			float blur) {				
		Kd = kd;
		Ks = ks;
		blurConst=blur;
		Info("blur set to: %f",blurConst);
	}
	BSDF *GetBSDF(const DifferentialGeometry &dgGeom,
	              const DifferentialGeometry &dgShading) const;
private:
	// custom_material_ward Private Data
	Reference<Texture<Spectrum> > Kd, Ks;
	float blurConst;
};

BSDF *custom_material_ward::GetBSDF(const DifferentialGeometry &dgGeom,
		const DifferentialGeometry &dgShading) const {
	
	//no bump mapping; use shading geometry as set before
	DifferentialGeometry dgs=dgShading;
	BSDF *bsdf = BSDF_ALLOC(BSDF)(dgs, dgGeom.nn);
	
	//allocate to diff a custom BxDF with reflection spectrum kd
	Spectrum kd = Kd->Evaluate(dgs).Clamp();
	BxDF *diff = BSDF_ALLOC(custom_BxDF_wardDiffuse)(kd);
	
	//my specular reflectance
	Spectrum ks = Ks->Evaluate(dgs).Clamp();
	BxDF *spec = BSDF_ALLOC(custom_BxDF_wardSpecular)(ks,blurConst);

	
	//add both diff and spec BSDFS to the BSDF of this material
	//***sets the BSDF of this material
	bsdf->Add(diff);
	bsdf->Add(spec);
	
	return bsdf;
}
// custom_material_ward Dynamic Creation Routine
extern "C" DLLEXPORT Material * CreateMaterial(const Transform &xform,
		const TextureParams &mp) {
	Reference<Texture<Spectrum> > Kd = mp.GetSpectrumTexture("Kd", Spectrum(1.f));
	Reference<Texture<Spectrum> > Ks = mp.GetSpectrumTexture("Ks", Spectrum(1.f));
	float blurConst = mp.FindFloat("blurConst", 50.f);
	return new custom_material_ward(Kd, Ks, blurConst);
}
