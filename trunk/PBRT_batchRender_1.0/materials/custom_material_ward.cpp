//reduced custom source
//ward model material
//dpl 11 august 2005

// custom_material_ward.cpp*
#include "pbrt.h"
#include "material.h"
#include <string.h>
#include "reflection_custom.h"
// Custom Class Declarations
class custom_material_ward : public Material {
public:
	// specularIntensity Public Methods
	custom_material_ward(Reference<Texture<Spectrum> > kd,
			Reference<Texture<Spectrum> > ks, 
			float _roughness) {				
		Kd = kd;
		Ks = ks;
		roughness=_roughness;
		Info("roughness set to: %f",roughness);
	}
	BSDF *GetBSDF(const DifferentialGeometry &dgGeom,
	              const DifferentialGeometry &dgShading) const;
private:
	// custom_material_ward Private Data
	Reference<Texture<Spectrum> > Kd, Ks;
	float roughness;
};

BSDF *custom_material_ward::GetBSDF(const DifferentialGeometry &dgGeom,
		const DifferentialGeometry &dgShading) const {
	
	//no bump mapping; use shading geometry as set before
	DifferentialGeometry dgs=dgShading;
	BSDF *bsdf = BSDF_ALLOC(BSDF)(dgs, dgGeom.nn);
	
	//allocate to diff a custom BxDF with reflection spectrum kd
	Spectrum kd = Kd->Evaluate(dgs).Clamp();
	BxDF *diff = BSDF_ALLOC(custom_BxDF_wardDiffuse)(kd);
	bsdf->Add(diff);
	
	//my specular reflectance
	Spectrum ks = Ks->Evaluate(dgs).Clamp();
	if(ks!=0.f) {
		BxDF *spec = BSDF_ALLOC(custom_BxDF_wardSpecular)(ks,roughness);
		bsdf->Add(spec);
	}


	
	return bsdf;
}
// custom_material_ward Dynamic Creation Routine
extern "C" DLLEXPORT Material * CreateMaterial(const Transform &xform,
		const TextureParams &mp) {
	Reference<Texture<Spectrum> > Kd = mp.GetSpectrumTexture("Kd", Spectrum(1.f));
	Reference<Texture<Spectrum> > Ks = mp.GetSpectrumTexture("Ks", Spectrum(1.f));
    float roughness = mp.FindFloat("roughness", 0.01f);
	Info("roughness: %f\n",roughness);
	return new custom_material_ward(Kd, Ks, roughness);
}
