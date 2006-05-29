//reduced custom source
//dpl 10 august 2005
//dpl 11 august 2004 - added ward
//dpl 23 august 2005 - added lambertian


#include "reflection_custom.h"
#include "color.h"
#include "mc.h"
#include "sampling.h"
#include <stdarg.h>

//**************
//	Phong BRDFS
//**************
Spectrum custom_BxDF_phongDiffuse::f(const Vector &wo,
		const Vector &wi) const {
	return RoverPI;
}
Spectrum custom_BxDF_phongSpecular::f(const Vector &wo,
		const Vector &wi) const {
	Vector rotated=Vector(-wi.x,-wi.y,wi.z);
	float cosangle=fabsf(Dot(rotated,wo));
	return RoverPI*pow(cosangle,n);
}


//**************
//	Ward BRDFS
//**************
Spectrum custom_BxDF_wardDiffuse::f(const Vector &wo,
		const Vector &wi) const {
	return RoverPI;
}
Spectrum custom_BxDF_wardSpecular::f(const Vector &wo,
		const Vector &wi) const {
	
	//calculate half vector
	Vector wh=Normalize((wi+wo)*.5);
	
	//calculate cosines of theta and delta
	float cosThetaI=CosTheta(wi);
	float cosThetaR=CosTheta(wo);
	float cosDeltaH=CosTheta(wh);

	//calculate tan^2(delta)
	float tan2delta=(1-pow(cosDeltaH,2))/pow(cosDeltaH,2);
	
	//set blur const
	float alpha=blurConst;
	float alpha2=pow(alpha,2);
	
	//calculate illuminocity
	Spectrum I = RoverPI*(1/sqrt(cosThetaI*cosThetaR))*exp(-tan2delta/alpha2)/(4*alpha2);
	return I/4;
}

//**************
//	Lambertian BRDF
//**************
Spectrum custom_BxDF_Lambertian::f(const Vector &wo,
		const Vector &wi) const {
	return RoverPI;
}



