#include <cuda.h>
#include <cuda_runtime.h>
#include <stdio.h>
#include <time.h>

#define SIZE 9

__global__ void min(int *input)
{
	int tid = threadIdx.x;
	int step_size = 1;
	int number_of_threads = blockDim.x;
	while(number_of_threads>0){
		if(tid<number_of_threads){
			int first = tid*step_size*2;
			int second = first+step_size;
			if(input[second]<input[first])
				input[first]=input[second];
		}
		step_size*= 2;
		number_of_threads/=2;
	}
}

__global__ void max(int *input)u
{
	int tid = threadIdx.x;
        int step_size = 1;
        int number_of_threads = blockDim.x;
        while(number_of_threads>0){ 
                if(tid<number_of_threads){ 
                        int first = tid*step_size*2;
                        int second = first+step_size;
                        if(input[second]>input[first])
                                input[first]=input[second];
                }
                step_size*= 2;
                number_of_threads/=2;
        }
}

__global__ void summation(int *input)
{
	const int tid = threadIdx.x;
	int step_size = 1;
	int number_of_threads = blockDim.x;
	while(number_of_threads>0){
		if(tid<number_of_threads){
			const int first = tid*step_size*2;
			const int second = first+step_size;
			input[first] +=	input[second];
		}
		step_size*=2;
		number_of_threads/=2;
	}
}

__global__ void average(int *input)
{
	const int tid = threadIdx.x;
        int step_size = 1;
        int number_of_threads = blockDim.x;
        while(number_of_threads>0){
                if(tid<number_of_threads){
                        const int first = tid*step_size*2;
                        const int second = first+step_size;
                        input[first] += input[second];
                }
                step_size*=2;
                number_of_threads/=2;
        }
	input[0] = input[0]/10;
}

__global__ void standardDeviation(int *input,int mean)
{
	const int tid = threadIdx.x;
	int step_size = 1;
	int number_of_threads = blockDim.x;
	int std = 0;
	while(number_of_threads>0){
		if(tid<number_of_threads){
			const int first = tid*step_size*2;
			const int second = first+step_size;
			std = ((input[first]-mean)*(input[first]-mean))+((input[second]-mean)*(input[second]-mean));
		}
		step_size*=2;
		number_of_threads/=2;
	}
	input[0] = std;
}

int main()
{
	int input[SIZE],i;
	for( i = 0 ; i < SIZE ; i++)
	{
		input[i] = rand()% 100;
	}
	for( i = 0 ; i < SIZE ; i++)
	{
		printf("%d ",input[i]);
	}
	printf("\n");
	int byte_size = SIZE*sizeof(int);

	//Allocate mem for min
	int *arr_min, result_min;
	cudaMalloc(&arr_min,byte_size);
	cudaMemcpy(arr_min,input,byte_size,cudaMemcpyHostToDevice);
	min<<<1,SIZE/2>>>(arr_min);
	cudaMemcpy(&result_min,arr_min,sizeof(int),cudaMemcpyDeviceToHost);
	printf("Minimun: %d\n",result_min);
	
	//Allocate mem for max
	int *arr_max, result_max;
	cudaMalloc(&arr_max,byte_size);
	cudaMemcpy(arr_max,input,byte_size,cudaMemcpyHostToDevice);
	max<<<1,SIZE/2>>>(arr_max);
	cudaMemcpy(&result_max,arr_max,sizeof(int),cudaMemcpyDeviceToHost);
	printf("Maximum: %d\n",result_max);

	//Allocate mem for sum
	int *arr_sum, sum;
	cudaMalloc(&arr_sum,byte_size);
	cudaMemcpy(arr_sum,input,byte_size,cudaMemcpyHostToDevice);
	summation<<<1,SIZE>>>(arr_sum);
	cudaMemcpy(&sum,arr_sum,sizeof(int),cudaMemcpyDeviceToHost);
	printf("Sum: %d\n",sum);

	//Allocate mem for avg
	int *arr_avg, avg;
	cudaMalloc(&arr_avg,byte_size);
	cudaMemcpy(arr_avg,input,byte_size,cudaMemcpyHostToDevice);
	average<<<1,SIZE>>>(arr_avg);
	cudaMemcpy(&avg,arr_avg,sizeof(int),cudaMemcpyDeviceToHost);
	printf("Average: %d\n",avg);
	printf("CPUAVG: %d\n",(sum/SIZE));
	
	//Allcate mem for std
	int *arr_std, std;
	const int mean = avg;
	cudaMalloc(&arr_std,byte_size);
	cudaMemcpy(arr_std,input,byte_size,cudaMemcpyHostToDevice);
	standardDeviation<<<1,SIZE>>>(arr_std,mean);
	cudaMemcpy(&std,arr_std,sizeof(int),cudaMemcpyDeviceToHost);
	std = sqrt(std/10);
	printf("Standard Deviation: %d\n",std);	

	return 0;
}

