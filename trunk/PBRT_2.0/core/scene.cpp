
/*
 * pbrt source code Copyright(c) 1998-2005 Matt Pharr and Greg Humphreys
 *
 * All Rights Reserved.
 * For educational use only; commercial use expressly forbidden.
 * NO WARRANTY, express or implied, for this software.
 * (See file License.txt for complete license)
 */

// scene.cpp*
#include "scene.h"
#include "camera.h"
#include "film.h"
#include "sampling.h"
#include "dynload.h"
#include "volume.h"
// Scene Methods
void Scene::Render() {
	Info("Start Render");

	// Allocate and initialize _sample_
	Sample *sample = new Sample(surfaceIntegrator,
	                            volumeIntegrator,
	                            this);
	// Allow integrators to do pre-processing for the scene
	surfaceIntegrator->Preprocess(this);
	volumeIntegrator->Preprocess(this);
	// Trace rays: The main loop
	ProgressReporter progress(sampler->TotalSamples(), "Rendering");
	Info("Render: going through samples");
	while (sampler->GetNextSample(sample)) {
		Info("// Find camera ray for _sample_");
		RayDifferential ray;
		float rayWeight = camera->GenerateRay(*sample, &ray);
		Info("// Generate ray differentials for camera ray");
		++(sample->imageX);
		camera->GenerateRay(*sample, &ray.rx);
		--(sample->imageX);
		++(sample->imageY);
		camera->GenerateRay(*sample, &ray.ry);
		ray.hasDifferentials = true;
		--(sample->imageY);
		Info("// Evaluate radiance along camera ray");
		float alpha;
		Info("declare spectrum");
		Spectrum Ls = 0.f;
		Info("check rayWeight");
		if (rayWeight > 0.f) {
			Ls = rayWeight * Li(ray, sample, &alpha); 
			Info("finished check");
		}
		Info("// Issue warning if unexpected radiance value returned");
		if (Ls.IsNaN()) {
			Error("Not-a-number radiance value returned "
		          "for image sample.  Setting to black.");
			Ls = Spectrum(0.f);
		}
		else if (Ls.y() < -1e-5) {
			Error("Negative luminance value, %g, returned "
		          "for image sample.  Setting to black.", Ls.y());
			Ls = Spectrum(0.f);
		}
		else if (isinf(Ls.y())) {
			Error("Infinite luminance value returned "
		          "for image sample.  Setting to black.");
			Ls = Spectrum(0.f);
		}
		Info("// Add sample contribution to image");
		camera->film->AddSample(*sample, ray, Ls, alpha);
		Info("// Free BSDF memory from computing image sample value");
		BSDF::FreeAll();
		Info("// Report rendering progress");
		static StatsCounter cameraRaysTraced("Camera", "Camera Rays Traced");
		++cameraRaysTraced;
		progress.Update();
		Info("Render: Finished first sample");
	}
	Info("Render:finsihed taking samples");
	// Clean up after rendering and store final image
	delete sample;
	progress.Done();
	camera->film->WriteImage();
}
Scene::~Scene() {
	delete camera;
	delete sampler;
	delete surfaceIntegrator;
	delete volumeIntegrator;
	delete aggregate;
	delete volumeRegion;
	for (u_int i = 0; i < lights.size(); ++i)
		delete lights[i];
}
Scene::Scene(Camera *cam, SurfaceIntegrator *si,
             VolumeIntegrator *vi, Sampler *s,
             Primitive *accel, const vector<Light *> &lts,
             VolumeRegion *vr) {
	lights = lts;
	aggregate = accel;
	camera = cam;
	sampler = s;
	surfaceIntegrator = si;
	volumeIntegrator = vi;
	volumeRegion = vr;
	if (lts.size() == 0)
		Warning("No light sources defined in scene; "
			"possibly rendering a black image.");
	// Scene Constructor Implementation
	bound = aggregate->WorldBound();
	if (volumeRegion) bound = Union(bound, volumeRegion->WorldBound());
}
const BBox &Scene::WorldBound() const {
	return bound;
}
Spectrum Scene::Li(const RayDifferential &ray,
		const Sample *sample, float *alpha) const {
	Spectrum Lo = surfaceIntegrator->Li(this, ray, sample, alpha);
	Spectrum T = volumeIntegrator->Transmittance(this, ray, sample, alpha);
	Spectrum Lv = volumeIntegrator->Li(this, ray, sample, alpha);
	return T * Lo + Lv;
}
Spectrum Scene::Transmittance(const Ray &ray) const {
	return volumeIntegrator->Transmittance(this, ray, NULL, NULL);
}
