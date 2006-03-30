//reduced custom source
//dpl 10 august 2005
//dpl 11 august 2005 - added ward
//dpl 23 august 2005 - added lambertian

#ifndef PBRT_REFLECTION_CUSTOM_H
#define PBRT_REFLECTION_CUSTOM_H

#include "reflection.h"
#include "pbrt.h"
#include "geometry.h"
#include "shape.h"

//**************
//	Phong BRDFS
//**************

//phong specular brdf
class COREDLL custom_BxDF_phongSpecular : public BxDF {
public:
	custom_BxDF_phongSpecular(const Spectrum &reflectance, const float smoothness)
		: BxDF(BxDFType(BSDF_REFLECTION | BSDF_DIFFUSE)),
		  R(reflectance), RoverPI(reflectance * INV_PI), n(smoothness) {
	}
	Spectrum f(const Vector &wo, const Vector &wi) const;
	Spectrum rho(const Vector &, int, float *) const {
		return R;
	}
	Spectrum rho(int, float *) const { return R; }
private:
	Spectrum R, RoverPI;
	float  n;
};


//PHONG diffuse reflection
class COREDLL custom_BxDF_phongDiffuse : public BxDF {
public:
	custom_BxDF_phongDiffuse(const Spectrum &reflectance)
		: BxDF(BxDFType(BSDF_REFLECTION | BSDF_DIFFUSE)),
		  R(reflectance), RoverPI(reflectance * INV_PI) {
	}
	Spectrum f(const Vector &wo, const Vector &wi) const;
	Spectrum rho(const Vector &, int, float *) const {
		return R;
	}
	Spectrum rho(int, float *) const { return R; }
private:
	Spectrum R, RoverPI;
};



//**************
//	Ward BRDFS
//**************

//WARD diffuse reflection
class COREDLL custom_BxDF_wardDiffuse : public BxDF {
public:
	custom_BxDF_wardDiffuse(const Spectrum &reflectance)
		: BxDF(BxDFType(BSDF_REFLECTION | BSDF_DIFFUSE)),
		  R(reflectance), RoverPI(reflectance * INV_PI) {
	}
	Spectrum f(const Vector &wo, const Vector &wi) const;
	Spectrum rho(const Vector &, int, float *) const {
		return R;
	}
	Spectrum rho(int, float *) const { return R; }
private:
	Spectrum R, RoverPI;
};


//WARD specular reflection
class COREDLL custom_BxDF_wardSpecular : public BxDF {
public:
	custom_BxDF_wardSpecular(const Spectrum &reflectance, const float blur)
		: BxDF(BxDFType(BSDF_REFLECTION | BSDF_DIFFUSE)),
		  R(reflectance), RoverPI(reflectance * INV_PI), blurConst(blur) {
	}
	Spectrum f(const Vector &wo, const Vector &wi) const;
	Spectrum rho(const Vector &, int, float *) const {
		return R;
	}
	Spectrum rho(int, float *) const { return R; }
private:
	Spectrum R, RoverPI;
	float  blurConst;
};

//**************
//	Lambertian BRDF
//**************
class COREDLL custom_BxDF_Lambertian : public BxDF {
public:
	custom_BxDF_Lambertian(const Spectrum &reflectance)
		: BxDF(BxDFType(BSDF_REFLECTION | BSDF_DIFFUSE)),
		  R(reflectance), RoverPI(reflectance * INV_PI) {
	}
	Spectrum f(const Vector &wo, const Vector &wi) const;
	Spectrum rho(const Vector &, int, float *) const {
		return R;
	}
	Spectrum rho(int, float *) const { return R; }
private:
	Spectrum R, RoverPI;
};



#endif


