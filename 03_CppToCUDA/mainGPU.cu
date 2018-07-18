#include <iostream>
#include "closestGPU.h"
#include "closestCPU.h"
#include <cuda.h>
#include <cuda_runtime.h>

using namespace std;

int main(){

	// Number of points
	const int count = 100000;

	// Create an array of points and floats (HOST)
	int* index = new int[count];
	float3* Newpoints = new float3[count];
	for(int i=0; i<count; i++){
		Newpoints[i].x = (float)((rand()%10000)-5000);
		Newpoints[i].y = (float)((rand()%10000)-5000);
		Newpoints[i].z = (float)((rand()%10000)-5000);
	}

	// Create an array of points and floats (DEVICE)
	int* d_index;
	float3* d_Newpoints;
	
	// Allocate memory to GPU
	if(cudaMalloc(&d_index, sizeof(int)*count) != cudaSuccess){
		cout << "Error in memory allocation of array index.";
		return 0;
	}

	if(cudaMalloc(&d_Newpoints, sizeof(float3)*count) != cudaSuccess){
		cout << "Error in memory allocation of array Newpoints.";
		cudaFree(d_index);
		return 0;
	}

	// Copy to device memory
	cudaMemcpy(d_index,index, sizeof(int)*count, cudaMemcpyHostToDevice);
	cudaMemcpy(d_Newpoints, Newpoints, sizeof(float3)*count, cudaMemcpyHostToDevice);

	// Upper bound of fastest time
	long fastest = 1000000;
	for(int j=0; j<20; j++){

		// Start time
		long start = clock();

		// Run the algorithm
		// findClosestCPU(Newpoints, index, count); // CPU
		findClosestGPU <<<(count/32)+1,32>>> (d_Newpoints, d_index,count);
		cudaMemcpy(index, d_index, sizeof(int)*count, cudaMemcpyDeviceToHost);

		// End time
		long finish = clock();

		cout <<"Run "<<j<<" took "<<(finish-start)<<" millis "<<endl;

		if((finish-start) < fastest){
			fastest = (finish-start);
		}
	}

	

	// Print fastest time
	cout<<"======================="<<endl;
	cout << "Fastest time: "<<fastest<<" millis "<<endl;

	// Print results
	cout<<"+++++++++++++++++++++++"<<endl;
	cout<< "Printing 5 sample results..."<<endl;
	for(int i=0; i<5; i++){
		cout<<i<<" --> ("<< Newpoints[i].x<< ","<<Newpoints[i].y<<","<<Newpoints[i].z<<")"<<endl;
	}

	cout<<"+++++++++++++++++++++++"<<endl;
	cout<< "Printing 5 sample results..."<<endl;
	for(int i=0; i<5; i++){
		cout<<i<<" --> "<< index[i]<< endl;
	}


	// Deallocate ram
	cudaFree(d_Newpoints);
	cudaFree(d_index);
	delete[] index;
	delete[] Newpoints;


	return 0;
}