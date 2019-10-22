#include<stdio.h>
#include<cuda.h>
#include<cuda_runtime.h>

#define SIZE 10

__global__ void min(int *input){
	int tid = threadIdx.x;
	int step_size=1;
	int numberofthreads = blockDim.x;
	while(numberofthreads>0){
		if(tid<numberofthreads){
			int first = tid*step_size*2;
			int second = first+step_size;
			if(input[second]<input[first])
				input[first]=input[second];
		}
			step_size*=2;
			numberofthreads/=2; 
	}
}

int main()
{
	// printf("Enter size of array:");
	// scanf("%d",&SIZE);
	int arr[SIZE];

	int byte_size = SIZE*sizeof(int);

	for(int i=0;i<SIZE;i++){
		arr[i] = rand()% 100;
	}

	printf("The array is:\n");
	for(int i=0;i<SIZE;i++){
		printf("%d ",arr[i]=rand());
	}
	printf("\n");

	int *arr_min,result;
	cudaMalloc(&arr_min,byte_size);
	cudaMemcpy(arr_min,arr,byte_size,cudaMemcpyHostToDevice);
	min<<<1,SIZE/2>>>(arr_min);
	cudaMemcpy(&result,arr_min,sizeof(int),cudaMemcpyDeviceToHost);
	printf("Minimum: %d", result);

	return 0;
}