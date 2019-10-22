#include<iostream>
#include<cuda.h>
#include<cuda_runtime.h>

#define SIZE 9

using namespace std;

__global__ void vectoradd(int *p,int *q,int *result){

	int tid = threadIdx.x + blockDim.x * blockIdx.x;
	if(tid<SIZE){
		// for(int i=0;i<SIZE;i++){
			result[tid] = p[tid] + q[tid];
		// }
	}
}

int main(int argc, char const *argv[]){
		
	int v1[SIZE],v2[SIZE],z[SIZE];
	for(int i=0;i<SIZE;i++){
		v1[i] = rand()%100+1;
        v2[i] = rand()%50+1;
        z[i] = 0;
	}

	printf("First Vector:\n");
	for(int i=0;i<SIZE;i++){
		printf("%d ",v1[1]);
	}
	printf("\nSecond Vector:\n");
	for(int i=0;i<SIZE;i++){
		printf("%d ",v2[1]);
	}

	int byte_size = SIZE * sizeof(int);

	int *a,*b,*c;
	cudaMalloc(&a,byte_size);
	cudaMalloc(&b,byte_size);
	cudaMalloc(&c,byte_size);
	cudaMemcpy(a,v1,byte_size,cudaMemcpyHostToDevice);
	cudaMemcpy(b,v2,byte_size,cudaMemcpyHostToDevice);
	cudaMemcpy(c,z,byte_size,cudaMemcpyHostToDevice);
	vectoradd<<<2,SIZE>>>(a,b,c);
	cudaMemcpy(&z,c,byte_size,cudaMemcpyDeviceToHost);

	printf("\nResult:\n");
	for(int i=0;i<SIZE;i++){
		printf("%d ",z[1]);
	}

	return 0;
}