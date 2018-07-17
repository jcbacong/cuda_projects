# cuda_projects
Basic projects in CUDA C. 


These are sample projects from the CUDA Tutorial playlist in YouTube for learning basic GPU computing. 
(https://www.youtube.com/playlist?list=PLKK11Ligqititws0ZOoGk3SW-TZCar4dK)

Basic steps in CUDA C/C++ programming:
1. Write a main function callable from the host. 
2. Create a '''void''' kernel function that can be read by the device using the ```__global___``` "decorator"/"parameter".
3. Initialize host and device variables from the ```main``` function. 
4. Allocate resource to the device using ```cudaMalloc``` command.
5. Copy data from host to device using ```cudaMemcpy``` and set direction to ```cudaMemcpyHostToDevice```.
6. Initialize kernel function and specify number of threads and blocks inside the triple chevrons ```<<< >>>>```. 
7. Copy results from device to host; this time, setting the direction to ```cudaMemcpyDeviceToHost```.
8. Always free memory in the device using ```cudaFree()``` command.
