#include <iostream>
#include <cuda.h>
using namespace std;

__global__ void AddIntsCuda(int *a, int *b){
	a[0] +=b[0]*b[0];
}

// Basic implementation of CUDA

int main(){
	
	// Initialize host variables
	int h_a=2, h_b=3;
	int *d_a, *d_b; //Device pointer

	// Allocate memory to device
	cudaMalloc((void**)&d_a, sizeof(int));
	cudaMalloc(&d_b, sizeof(int));


	// Copy to device memory
	cudaMemcpy(d_a,&h_a, sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b,&h_b, sizeof(int), cudaMemcpyHostToDevice);

	// Call the kernel
	AddIntsCuda<<<1,1>>>(d_a,d_b);

	// Copy answer from GPU to HOST
	cudaMemcpy(&h_a, d_a, sizeof(int), cudaMemcpyDeviceToHost);

	// Print from host
	cout<<"Answer "<<h_a<<endl;

	// Free memory
	cudaFree(d_a);
	cudaFree(d_b);

	return 0;
}