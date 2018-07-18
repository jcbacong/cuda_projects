#ifndef CLOSESTGPU_H
#define CLOSESTGPU_H


#include <iostream>
#include <cuda.h>
#include <cuda_runtime.h>

using namespace std;
__global__ void findClosestGPU(float3* points, int* index, int count){
	
	if(count<=1) return;

	// Set identity of each thread
	int idx = threadIdx.x + blockIdx.x*blockDim.x;

	// Limited only to the number of count
	if(idx < count){ 
		// Create point struct for each thread
		float3 thisPoint = points[idx];
		float maxDist = 3.40282e38f;

		// Each thread runs a loop to find global minimum
		for(int i=0; i< count; i++){
			if(i==idx) continue;

			float dist = (thisPoint.x - points[i].x)*(thisPoint.x - points[i].x) +
				(thisPoint.y - points[i].y)*(thisPoint.y - points[i].y) +
				(thisPoint.z - points[i].z)*(thisPoint.z - points[i].z);

			if(dist < maxDist){
				maxDist = dist;
				index[idx]=i;
			}
		}

	}


}

#endif