#include <iostream>
#include <cuda.h>
using namespace std;

__global__ void AddIntsCuda(int *a, int *b){
for(int i = 0; i<10000005; i++)
	a[0] +=b[0]*b[0];
}


int main(){
	
	int h_a=2, h_b=3;
	int *d_a, *d_b; //Device pointer

	// Allocate memory to device
	if(cudaMalloc((void**)&d_a, sizeof(int))!=cudaSuccess){
		cout << "Error allocating memory!"<<endl;
		return 0;
	}

	if(cudaMalloc(&d_b, sizeof(int)) !=cudaSuccess){
		cout << "Error allocating memory!"<<endl;
		cudaFree(d_a);
		return 0;
	}


	// Copy to device memory
	if(cudaMemcpy(d_a,&h_a, sizeof(int), cudaMemcpyHostToDevice) != cudaSuccess){
		cout << "Error copying memory!"<<endl;
		cudaFree(d_a);
		cudaFree(d_b);
		return 0;
	}
		if(cudaMemcpy(d_b,&h_b, sizeof(int), cudaMemcpyHostToDevice) != cudaSuccess){
		cout << "Error copying memory!"<<endl;
		cudaFree(d_a);
		cudaFree(d_b);
		return 0;
	}

	// Call the kernel
	AddIntsCuda<<<1,1>>>(d_a,d_b);

	// Copy answer from GPU to HOST
	if(cudaMemcpy(&h_a, d_a, sizeof(int), cudaMemcpyDeviceToHost) != cudaSuccess){
		cout << "Error copying to memory!" << endl;
		cudaFree(d_a);
		cudaFree(d_b);
		return 0;
	}

	// Print from host
	cout<<"Answer "<<h_a<<endl;

	// Free memory
	cudaFree(d_a);
	cudaFree(d_b);

	cudaDeviceReset();

	return 0;
}