#include "pbrt.h"
#include "material.h"
// Ward Class Declarations




class WardBRDF :public BxDF
{
public:
   WardBRDF(const Spectrum &ks, float ax, float ay, float gamma) : BxDF(BxDFType(BSDF_REFLECTION | BSDF_GLOSSY)),
      Ks(ks), Ax(ax), Ay(ay), Gamma(gamma) {
         INV_Ax2 = 1.0f / (ax * ax);
         INV_Ay2 = 1.0f / (ay * ay);
         INV_4PI_AxAy = 1.0f / ( 4.0f * M_PI * Ax * Ay );

         // Used to rotate wi and wo.
         // -gamma to make this equivalet to rotating the x and y axes clockwise around z
         s = sin(-gamma);
         c = cos(-gamma);
   };
   ~WardBRDF(){};
   Spectrum f(const Vector& wo, const Vector& wi)const;
   float Pdf(const Vector &wo, const Vector &wi) const;
   Spectrum Sample_f(const Vector & wo, Vector * wi, float u1, float u2, float * pdf)const;
private:
   Spectrum Ks;
   float INV_Ax2, INV_Ay2, INV_4PI_AxAy, Ax, Ay, Gamma, s, c;
   Vector x,y,n;
};

Spectrum WardBRDF::f(const Vector &_wo, const Vector &_wi) const
{
   Vector wo = Vector(c * _wo.x - s * _wo.y, s * _wo.x + c * _wo.y, _wo.z);
   Vector wi = Vector(c * _wi.x - s * _wi.y, s * _wi.x + c * _wi.y, _wi.z);
      
   Vector wh = Normalize(wo + wi);

   float sinThetaH = SinTheta(wh);
   float cosThetaH = CosTheta(wh);

   float cosPhiH, sinPhiH;
   // Avoid divide-by-zero when calculating cosPhiH and sinPhiH
   if(sinThetaH == 0.)
   {
      cosPhiH = 0.;
      sinPhiH = 0.;
   }
   else
   {
      cosPhiH = wh.x / sinThetaH;
      sinPhiH = wh.y / sinThetaH;
   }

   float tanThetaH = sinThetaH / cosThetaH;
   float tan2ThetaH = tanThetaH * tanThetaH;

   float cosThetaO = (CosTheta(wo));
   float cosThetaI = (CosTheta(wi));

   float cos2PhiH = cosPhiH * cosPhiH;
   float sin2PhiH = sinPhiH * sinPhiH;

   return Ks * 1.f / sqrtf(cosThetaI*cosThetaO)  * exp( -tan2ThetaH * (cos2PhiH * INV_Ax2 + sin2PhiH * INV_Ay2 ) ) * INV_4PI_AxAy;
}

float WardBRDF::Pdf(const Vector &_wo, const Vector &_wi) const
{
   Vector wo = Vector(c * _wo.x - s * _wo.y, s * _wo.x + c * _wo.y, _wo.z);
   Vector wi = Vector(c * _wi.x - s * _wi.y, s * _wi.x + c * _wi.y, _wi.z);

   Vector wh = Normalize(wo + wi);

   float sinThetaH = SinTheta(wh);

   float cosPhiH, sinPhiH;
   // Avoid divide-by-zero when calculating cosPhiH and sinPhiH
   if(sinThetaH == 0.)
   {
      cosPhiH = 0.;
      sinPhiH = 0.;
   }
   else
   {
      cosPhiH = wh.x / sinThetaH;
      sinPhiH = wh.y / sinThetaH;
   }

   float cosThetaH = CosTheta(wh);
   float cosThetaO = max(0.f, CosTheta(wo));
   float cosThetaI = max(0.f, CosTheta(wi));

   float tanThetaH = sinThetaH / cosThetaH;

   return max(0.f, float(INV_4PI_AxAy * 1.0f / ( Dot(wi, wh) * cosThetaH*cosThetaH*cosThetaH ) * exp( - tanThetaH*tanThetaH * (INV_Ax2 * cosPhiH*cosPhiH + INV_Ay2 * sinPhiH * sinPhiH)) ));
}

Spectrum WardBRDF::Sample_f(const Vector &wo, Vector *wi, float u1, float u2, float * pdf) const
{
   float phih;

   if( u1 < .25f )
      phih = atanf(Ay/Ax*tanf(2.f*M_PI*u1));
   else if( u1 < .5f )
      phih = M_PI-atanf(Ay/Ax*tanf(2.f*M_PI*(.5f-u1)));
   else if( u1 < .75f )
      phih = atanf(Ay/Ax*tanf(2.f*M_PI*(u1-.5f)))+M_PI;
   else
      phih = 2.f*M_PI-atanf(Ay/Ax*tanf(2.f*M_PI*(1.f-u1)));

   float cosphi = cosf(phih);
   float sinphi = sinf(phih);

   float thetah = atanf(sqrtf(-log(u2)/( cosphi*cosphi * INV_Ax2 + sinphi*sinphi * INV_Ay2 )));
   Vector h = SphericalDirection( sinf(thetah), cosf(thetah), phih );
   
   // Rotate h to follow gamma (we're rotating the other way here = +gamma => c = c, s=-s)
   h = Vector(c * h.x + s * h.y, -s * h.x + c * h.y, h.z);
   // normal flipping problem
   if( Dot( wo, h ) < 0.f )
      h = -h;

   *wi = 2 * Dot( wo, h ) * h - wo;

   *pdf = this->Pdf(wo, *wi);

   Spectrum L = f(wo, *wi);

   return L;
}


class Ward : public Material {
public:
   // Ward Public Methods
   Ward(Reference<Texture<Spectrum> > kd,
      Reference<Texture<Spectrum> > ks,
      Reference<Texture<float> > bump,
      Reference<Texture<float> > ax,
      Reference<Texture<float> > ay,
      Reference<Texture<float> > gamma
      ) {
         Kd = kd;
         Ks = ks;
         bumpMap = bump;
         Ax = ax;
         Ay = ay;
         Gamma = gamma;
   }
   BSDF *GetBSDF(const DifferentialGeometry &dgGeom,
      const DifferentialGeometry &dgShading) const;
private:
   // Ward Private Data
   Reference<Texture<Spectrum> > Kd, Ks;
   Reference<Texture<float> > bumpMap;
   Reference<Texture<float> > Ax, Ay, Gamma;

};
// Ward Method Definitions
BSDF *Ward::GetBSDF(const DifferentialGeometry &dgGeom,
               const DifferentialGeometry &dgShading) const {
                  // Allocate _BSDF_, possibly doing bump-mapping with _bumpMap_
                  DifferentialGeometry dgs;
                  if (bumpMap)
                     Bump(bumpMap, dgGeom, dgShading, &dgs);
                  else
                     dgs = dgShading;

                  BSDF *bsdf = BSDF_ALLOC(BSDF)(dgs, dgGeom.nn);

                  Spectrum kd = Kd->Evaluate(dgs).Clamp();
                  Spectrum ks = Ks->Evaluate(dgs).Clamp();
                  float ax = Ax->Evaluate(dgs);
                  float ay = Ay->Evaluate(dgs);
                  float gamma = Gamma->Evaluate(dgs);
                  if(!ks.Black())
                     bsdf->Add(BSDF_ALLOC(WardBRDF)(ks, ax, ay, gamma));
                  bsdf->Add(BSDF_ALLOC(Lambertian)(kd));

                  return bsdf;
}
// Ward Dynamic Creation Routine
extern "C" DLLEXPORT Material * CreateMaterial(const Transform &xform,
                                    const TextureParams &mp) {
	Reference<Texture<Spectrum> > Kd = mp.GetSpectrumTexture("Kd", Spectrum(0.f));
	Reference<Texture<Spectrum> > Ks = mp.GetSpectrumTexture("Ks", Spectrum(0.f));
	Reference<Texture<float> > bumpMap = mp.GetFloatTexture("bumpmap", 0.f);
	Reference<Texture<float> > Ax = mp.GetFloatTexture("Ax", .1f);
	Reference<Texture<float> > Ay = mp.GetFloatTexture("Ay", .1f);
	Reference<Texture<float> > gamma = mp.GetFloatTexture("Gamma", 0.0f);
	return new Ward(Kd, Ks, bumpMap, Ax, Ay, gamma);
}