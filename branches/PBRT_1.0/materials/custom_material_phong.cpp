//
// Dan Lichtman
// 23 June 2005
// custom_material_phong material cpp source code. 
 
#include "pbrt.h"
#include "material.h"
#include <string.h>

class custom_material_phong : public Material {
public:
	custom_material_phong(Reference<Texture<Spectrum> > kd,	
			Reference<Texture<Spectrum> > ks,
			float smoothness) {				
		Kd = kd;
		Ks = ks;
		n=smoothness;
		Info("smoothness set to: %f:",n);
	}
	BSDF *GetBSDF(const DifferentialGeometry &dgGeom,
	              const DifferentialGeometry &dgShading) const;
private:
	Reference<Texture<Spectrum> > Kd, Ks;
	float n;
};

BSDF *custom_material_phong::GetBSDF(const DifferentialGeometry &dgGeom,
		const DifferentialGeometry &dgShading) const {
	
	//not sure about this yet
	DifferentialGeometry dgs=dgShading;
	
	//or this:
	//allocate memory for BSDF, poiting bsdf to a new BSDF
	BSDF *bsdf = BSDF_ALLOC(BSDF)(dgs, dgGeom.nn);
	
	//allocate to diff a custom BxDF with reflection spectrum kd
	Spectrum kd = Kd->Evaluate(dgs).Clamp();
	BxDF *diff = BSDF_ALLOC(custom_BxDF_phongDiffuse)(kd);
	
	//my specular reflectance
	Spectrum ks = Ks->Evaluate(dgs).Clamp();
	BxDF *spec = BSDF_ALLOC(custom_BxDF_phongSpecular)(ks,float(n));

	
	//add both diff and spec BSDFS to the BSDF of this material
	//***sets the BSDF of this material
	bsdf->Add(diff);
	bsdf->Add(spec);
	
	return bsdf;
}
// custom_material_phong Dynamic Creation Routine
extern "C" DLLEXPORT Material * CreateMaterial(const Transform &xform,
		const TextureParams &mp) {
	Reference<Texture<Spectrum> > Kd = mp.GetSpectrumTexture("Kd", Spectrum(1.f));
	Reference<Texture<Spectrum> > Ks = mp.GetSpectrumTexture("Ks", Spectrum(1.f));
	float n = mp.FindFloat("smoothness", 0.f);
	return new custom_material_phong(Kd, Ks, n);
}
//Reference<Texture<float> > bumpMap = mp.GetFloatTexture("bumpmap", 0.f);
