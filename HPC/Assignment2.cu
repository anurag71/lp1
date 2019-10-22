#include<iostream>
#include<ctime>
#include<cmath>
#include<stdexcept>

using namespace std;

#define MaxElement 1000

__global__ void Sum(int* Array1, int* Array2, int* Result, int ElementCount){
	int Index = blockIdx.x * blockDim.x + threadIdx.x;

	if(Index < ElementCount)
		Result[Index] = Array1[Index] + Array2[Index];
}

void HostVectorSum(int ArraySize=1000, int ThreadsPerBlock=100){
	int ArrayMemory = ArraySize * sizeof(int);

	int* HostArray1 = (int*) malloc(ArrayMemory);
	int* HostArray2 = (int*) malloc(ArrayMemory);
	int* HostResult = (int*) malloc(ArrayMemory);

	int* DeviceArray1;
	int* DeviceArray2;
	int* DeviceResult;

	srand(time(0));

	for(int i=0;i<ArraySize;i++){
		HostArray1[i] = rand() % MaxElement;
		HostArray2[i] = rand() % MaxElement;
	}

	cudaMalloc(&DeviceArray1, ArrayMemory);
	cudaMalloc(&DeviceArray2, ArrayMemory);
	cudaMalloc(&DeviceResult, ArrayMemory);

	cudaMemcpy(DeviceArray1, HostArray1, ArrayMemory, cudaMemcpyHostToDevice);
	cudaMemcpy(DeviceArray2, HostArray2, ArrayMemory, cudaMemcpyHostToDevice);
	
	int BlocksPerGrid = 1;

	if(ArraySize > ThreadsPerBlock)
		BlocksPerGrid = ceil(double(ArraySize) / double(ThreadsPerBlock));

	Sum<<<BlocksPerGrid, ThreadsPerBlock>>>(DeviceArray1, DeviceArray2, DeviceResult, ArraySize);
	
	cudaMemcpy(HostResult, DeviceResult, ArrayMemory, cudaMemcpyDeviceToHost);

	cudaFree(DeviceArray1);
	cudaFree(DeviceArray2);
	cudaFree(DeviceResult);

	for(int i=0;i<ArraySize;i++)
		printf("Index %d --> %d + %d = %d\n", i+1, HostArray1[i], HostArray2[i], HostResult[i]);

	free(HostArray1);
	free(HostArray2);
	free(HostResult);
}

__global__ void VectorMatrixMultiplication(int* Vector, int* Matrix, int* Result, int Row, int Column){
	int Index = blockIdx.x * blockDim.x + threadIdx.x;

	int Sum = 0;

	if(Index < Column){
		int ColumnStartIndex = Index * Row;
		for(int i=0;i<Row;i++)
			Sum += Vector[i] * Matrix[ColumnStartIndex + i];

		Result[Index] = Sum;
	}
}

void HostVectorMatrixMultiplication(int Row, int Column){
	int* HostArray = (int*) malloc(Row * sizeof(int));
	int* HostMatrix = (int*) malloc(Row * Column * sizeof(int));
	int* HostResult = (int*) malloc(Column * sizeof(int));

	int* DeviceArray;
	int* DeviceMatrix;
	int* DeviceResult;

	srand(time(0));

	for(int i=0;i<Row;i++)
		HostArray[i] = rand() % MaxElement;

	for(int i=0;i<Column;i++)
		for(int j=0;j<Row;j++)
			HostMatrix[i*Row+j] = rand() % MaxElement;

	cudaMalloc(&DeviceArray, Row*sizeof(int));
	cudaMalloc(&DeviceMatrix, Row*Column*sizeof(int));
	cudaMalloc(&DeviceResult, Column*sizeof(int));

	cudaMemcpy(DeviceArray, HostArray, Row*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(DeviceMatrix, HostMatrix, Row*Column*sizeof(int), cudaMemcpyHostToDevice);

	VectorMatrixMultiplication<<<Column, 1>>>(DeviceArray, DeviceMatrix, DeviceResult, Row, Column);

	cudaMemcpy(HostResult, DeviceResult, Column*sizeof(int), cudaMemcpyDeviceToHost);

	cudaFree(DeviceArray);
	cudaFree(DeviceMatrix);
	cudaFree(DeviceResult);

	for(int i=0;i<Column;i++)
		printf("Index %d --> %d\n", i+1,HostResult[i]);

	free(HostArray);
	free(HostMatrix);
	free(HostResult);
}

__global__ void MatrixMultiplication(int* MatrixA, int* MatrixB, int* Result, int Dimension){
	int Row = blockIdx.y * blockDim.y + threadIdx.y;
	int Column = blockIdx.x * blockDim.x + threadIdx.x;

	int Sum = 0;
	if(Row < Dimension && Column < Dimension){
		for(int i=0;i<Dimension;i++)
			Sum += MatrixA[Row * Dimension + i] * MatrixB[i * Dimension + Column];
		__syncthreads();
		Result[Row * Dimension + Column] = Sum;
	}
}

void HostMatrixMultiplication(int Dimension){
	int MatrixMemory = Dimension * Dimension * sizeof(int);

	int* HostMatrixA = (int*) malloc(MatrixMemory);
	int* HostMatrixB = (int*) malloc(MatrixMemory);
	int* HostResult = (int*) malloc(MatrixMemory);

	srand(time(0));

	for(int i=0;i<Dimension;i++){
		for(int j=0;j<Dimension;j++){
			HostMatrixA[i * Dimension + j] = rand() % 30;
			HostMatrixB[i * Dimension + j] = rand() % 30;
		}
	}

	int* DeviceMatrixA;
	int* DeviceMatrixB;
	int* DeviceResult;

	cudaMalloc(&DeviceMatrixA, MatrixMemory);
	cudaMalloc(&DeviceMatrixB, MatrixMemory);
	cudaMalloc(&DeviceResult, MatrixMemory);

	cudaMemcpy(DeviceMatrixA, HostMatrixA, MatrixMemory, cudaMemcpyHostToDevice);
	cudaMemcpy(DeviceMatrixB, HostMatrixB, MatrixMemory, cudaMemcpyHostToDevice);

	dim3 ThreadsPerBlock(Dimension, Dimension);
	dim3 BlocksPerGrid(1, 1);

	MatrixMultiplication<<<BlocksPerGrid, ThreadsPerBlock>>>(DeviceMatrixA, DeviceMatrixB, DeviceResult, Dimension);

	cudaError_t Exception = cudaGetLastError();

	if(Exception != cudaSuccess){
		printf("Cuda Error: %s", cudaGetErrorString(Exception));
		return;
	}

	cudaDeviceSynchronize();

	cudaMemcpy(HostResult, DeviceResult, MatrixMemory, cudaMemcpyDeviceToHost);

	cudaFree(DeviceMatrixA);
	cudaFree(DeviceMatrixB);
	cudaFree(DeviceResult);

	for(int i=0;i<Dimension;i++){
		for(int j=0;j<Dimension;j++){
			printf("%d ", HostResult[i * Dimension + j]);
		}
		printf("\n");
	}
}

int main(){
	int Choice;

	printf("1.Vector Addition\n2.Vector Matrix Multiplication\n3.Matrix Multiplication\n4.Exit\n");
	printf("Enter The Operation To Be Performed: : ");
	scanf("%d", &Choice);

	if(Choice==1){
		int ArraySize;
		printf("Enter The Array Size: : ");
		scanf("%d", &ArraySize);
		HostVectorSum(ArraySize);
	}
	else if(Choice==2){
		int Row, Column;
		printf("Enter The Rows And Columns Of The Matrix: : ");
		scanf("%d %d", &Row, &Column);
		HostVectorMatrixMultiplication(Row, Column);
	}
	else if(Choice==3){
		int Dimension;
		printf("Enter The Dimensions Of The Matrix: : ");
		scanf("%d", &Dimension);
		HostMatrixMultiplication(Dimension);
	}
	else
		return 0;
	
	return 0;
}
