//
// Dan Lichtman
// 23 June 2005
// custom_material material cpp source code. 

// custom_material.cpp*
#include "pbrt.h"
#include "material.h"
// Custom Class Declarations
class custom_material : public Material {
public:
	// Plastic Public Methods
	custom_material(Reference<Texture<Spectrum> > kd,	//diffuse reflectance spectrum
			Reference<Texture<Spectrum> > ks,			//spectral reflectance spectrum
			Reference<Texture<float> > rough,			//roughness
			Reference<Texture<float> > bump) {			//bumpiness (?)
		Kd = kd;
		Ks = ks;
		roughness = rough;
		bumpMap = bump;
	}
	BSDF *GetBSDF(const DifferentialGeometry &dgGeom,
	              const DifferentialGeometry &dgShading) const;
private:
	// custom_material Private Data
	Reference<Texture<Spectrum> > Kd, Ks;
	Reference<Texture<float> > roughness, bumpMap;
};
// custom_material Method Definitions
BSDF *custom_material::GetBSDF(const DifferentialGeometry &dgGeom,
		const DifferentialGeometry &dgShading) const {
	
	//issue debugging warning
	//Warning("custom_material\n");
	
	//declare geometry that will be used in BRDF
	DifferentialGeometry dgs;
	
	//if there is to be a bump map, call Bump, which modifies dgs
	if (bumpMap)
		Bump(bumpMap, dgGeom, dgShading, &dgs);
	else
		dgs = dgShading;
		
	//allocate memory for BSDF, poiting bsdf to a new BSDF
	BSDF *bsdf = BSDF_ALLOC(BSDF)(dgs, dgGeom.nn);
	
	//set a spectrum kd to the spectrum stored in texure Kd
	//***gets color spectrum of diffuse reflection***
	Spectrum kd = Kd->Evaluate(dgs).Clamp();
	
	//allocate to diff a custom BxDF with reflection spectrum kd
	//***diffuse reflection characteristics***
	BxDF *diff = BSDF_ALLOC(custom_BxDF3)(kd);
	
	/* commented dpl 10 august 2005
	// specular reflectance from pbrt's plastic model
	//allocate to (temp) fresnes a fresneldielectric bsdf with
	//parameters (1.5, 1)
	//***will set part of specular reflection properties***
	Fresnel *fresnel =
		BSDF_ALLOC(FresnelDielectric)(1.5f, 1.f);
	
	//set a spectrum ks to the spectrum stored in the texture Ks
	//***gets color spectrum of specular reflection***
	Spectrum ks = Ks->Evaluate(dgs).Clamp();
	
	//get the roughness from roughness (?)
	float rough = roughness->Evaluate(dgs);
	
	//allocate memory for specular reflection BSDF
	//***sets specular BSDF according to microfacet model
	//with color params ks, fresnel and blinn models (?) ***
	BxDF *spec = BSDF_ALLOC(Microfacet)(ks, fresnel,
		BSDF_ALLOC(Blinn)(1.f / rough));
	*/
	
	//my specular reflectance
	Spectrum ks = Ks->Evaluate(dgs).Clamp();
	BxDF *spec = BSDF_ALLOC(custom_BxDF2)(ks);
	
	//add both diff and spec BSDFS to the BSDF of this material
	//***sets the BSDF of this material
	bsdf->Add(diff);
	bsdf->Add(spec);
	
	return bsdf;
}
// custom_material Dynamic Creation Routine
extern "C" DLLEXPORT Material * CreateMaterial(const Transform &xform,
		const TextureParams &mp) {
	Reference<Texture<Spectrum> > Kd = mp.GetSpectrumTexture("Kd", Spectrum(1.f));
	Reference<Texture<Spectrum> > Ks = mp.GetSpectrumTexture("Ks", Spectrum(1.f));
	Reference<Texture<float> > roughness = mp.GetFloatTexture("roughness", .1f);
	Reference<Texture<float> > bumpMap = mp.GetFloatTexture("bumpmap", 0.f);
	return new custom_material(Kd, Ks, roughness, bumpMap);
}
