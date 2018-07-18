#include <iostream>
#include "closestCPU.h"

using namespace std;

int main(){

	// Number of points
	const int count = 10000;

	// Create an array of points and floats
	int* index = new int[count];
	struct float3D* Newpoints = new float3D[count];

	for(int i=0; i<count; i++){
		Newpoints[i].x = (float)((rand()%10000)-5000);
		Newpoints[i].y = (float)((rand()%10000)-5000);
		Newpoints[i].z = (float)((rand()%10000)-5000);
	}

	// Upper bound of fastest time
	long fastest = 1000000;
	for(int j=0; j<20; j++){

		long start = clock();
		// Run the algorithm
		findClosest(Newpoints, index, count);

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
		cout<<i<<" --> "<< index[i]<< endl;
	}


	// Deallocate ram
	delete[] index;
	delete[] Newpoints;

	return 0;
}