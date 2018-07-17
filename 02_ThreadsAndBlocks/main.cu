#include <iostream>
#include <cuda.h>
#include <stdlib.h>
#include <ctime>
using namespace std;

__global__ void AddInts(int *a, int *b, int count){
	// Create a unique index for each thread
	int id = blockIdx.x * blockDim.x + threadIdx.x;

	// Check id if within the bounds of count and add only those items
	if(id < count){
		a[id] += b[id];
	}
}


int main(){
	srand(time(NULL));
	int count = 100;
	int *h_a = new int[count];
	int *h_b = new int[count];

	for (int i = 0; i<count; i++){
		h_a[i] = rand() % 1000;
		h_b[i] = rand() % 1000; 
	}

	cout << "Prior to addition: "<< endl;
	for(int i = 0; i < 5; i++){
		cout << h_a[i] << " " << h_b[i] << endl;
	}

	// Device copies of the arrays
	int *d_a, *d_b;

	if(cudaMalloc(&d_a, sizeof(int)*count) != cudaSuccess){
		cout << "Error in memory allocation of array A.";
		return 0;
	}

	if(cudaMalloc(&d_b, sizeof(int)*count) != cudaSuccess){
		cout << "Error in memory allocation of array B.";
		cudaFree(d_a);
		return 0;
	}

	// Copy array contents from host to device
	if(cudaMemcpy(d_a, h_a, sizeof(int)*count, cudaMemcpyHostToDevice) != cudaSuccess){
		cout << "Could not copy array A."<<endl;
		cudaFree(d_a);
		cudaFree(d_b);
		return 0;
	}

	if(cudaMemcpy(d_b, h_b, sizeof(int)*count, cudaMemcpyHostToDevice) != cudaSuccess){
		cout << "Could not copy array B."<<endl;
		cudaFree(d_a);
		cudaFree(d_b);
		return 0;
	}

	// Initialize kernel function
	// In this case only 1 block but 256 threads
	AddInts <<< count / 256 + 1, 256 >>> (d_a, d_b,count);


	// Copy answer to host
	if (cudaMemcpy(h_a, d_a, sizeof(int)*count, cudaMemcpyDeviceToHost) != cudaSuccess){
		cout << "Could not copy from device!"<<endl;
		delete[] h_a;
		delete[] h_b;
		cudaFree(d_a);
		cudaFree(d_b);
		return 0;
	}

	for(int i=0; i<5; i++){
		cout << "It's "<<h_a[i] << endl;
	}


	cudaFree(d_a);
	cudaFree(d_b);
	delete[] h_a;
	delete[] h_b;

	return 0;
}