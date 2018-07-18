struct float3D{
	float x,y,z;
};

void findClosestCPU(float3* points, int* indices, int count){
	// Base case
	if (count<=1) return;

	// Loops every point
	for (int currentPt = 0; currentPt < count; currentPt++){
		// Max floating point representation for comparison
		float maxDist = 3.40282e38f;

		// Iterate to next points
		for(int i=0; i<count; i++){
			if (i==currentPt) continue;
			float dist = (points[currentPt].x - points[i].x)*(points[currentPt].x - points[i].x) +
				(points[currentPt].y - points[i].y)*(points[currentPt].y - points[i].y) + 
				(points[currentPt].z - points[i].z)*(points[currentPt].z - points[i].z);

			// FInding the global minimum
			if(dist < maxDist) {
				maxDist = dist; // CHange maximum value
				indices[currentPt] = i; // Record index
			}
		}
	}


}

