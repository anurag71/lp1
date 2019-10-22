#include <cuda.h>
#include <cuda_runtime.h>
#include <iostream>

#define size 4

using namespace std;

__global__ void add(int *x,int *y,int *c){
    const int tid = threadIdx.x+blockIdx.x*blockDim.x;
        if(tid<size){
            c[tid] = x[tid] + y[tid];
        }
}

__global__ void multiplyVectorAndMatrix(int *p, int *q, int *r){
    const int tid = threadIdx.x + blockIdx.x * blockDim.x;
    if(tid<size){
        for(int i=0;i<size;i++){
            r[tid] += p[(tid*size)+i] * q[i];
        }
    }
}

__global__ void matrixMultiplication(int *g, int *h, int *ii){
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    int sum = 0;
    if((row<size) && (col<size)){
        for(int i=0;i<size;i++){
            sum += g[(row*size)+i] * h[(i*size)+col];
        }
	    __syncthreads(); 
        ii[(row*size)+col] = sum;
    }
}

int main(){
    //ADDITION OF TWO VECTORS
    int x[size],y[size],z[size];
    for(int i=0;i<size;i++){
        x[i] = rand()%100+1;
        y[i] = rand()%50+1;
        z[i] = 0;
    }
    cout<<"1st Vector: ";
    for(int i=0;i<size;i++){
        cout<<x[i]<<" ";
    }
    cout<<endl<<"2nd Vector: ";
    for(int i=0;i<size;i++){
        cout<<y[i]<<" ";
    }
    cout<<endl;
    int byte_size = size*sizeof(int);
    cout<<"Addition using CPU: ";
    for(int i=0;i<size;i++){
        cout<<x[i]+y[i]<<" ";
    }
    cout<<endl;
    cout<<"Addition using GPU: ";
    int *a,*b,*c;
    cudaMalloc(&a,byte_size);
    cudaMemcpy(a,x,byte_size,cudaMemcpyHostToDevice);
    cudaMalloc(&b,byte_size);
    cudaMemcpy(b,y,byte_size,cudaMemcpyHostToDevice);
    cudaMalloc(&c,byte_size);
    cudaMemcpy(c,z,byte_size,cudaMemcpyHostToDevice);
    add<<<2,size>>>(a,b,c);
    cudaMemcpy(&z,c,byte_size,cudaMemcpyDeviceToHost);
    for(int i=0;i<size;i++){
        cout<<z[i]<<" ";
    }
    cout<<endl;

    //MULTIPLICATION: MATRIX AND VECTOR
    int m[size][size],n[size],o[size];
    for(int i=0;i<size;i++){
        for(int j=0;j<size;j++){
            m[i][j] = rand()%10+1;
        }
        n[i] = rand()%10+1;
        o[i] = 0;
    }
    cout<<endl;
    cout<<"Matrix:"<<endl;
    for(int i=0;i<size;i++){
        for(int j=0;j<size;j++){
            cout<<m[i][j]<<" ";
        }
        cout<<endl;
    }
    cout<<endl<<"Vector: ";
    for(int i=0;i<size;i++){
        cout<<n[i]<<" ";
    }
    cout<<endl<<endl;
    size_t matrix_size = size*size*sizeof(int);
    size_t vector_size = size*sizeof(int);
    cout<<"Multiplication using CPU: ";
    for(int i=0;i<size;i++){
        o[i] = 0;
        for(int j=0;j<size;j++){
            o[i]+=m[i][j]*n[j];
        }
    }
    for(int i=0;i<size;i++){
        cout<<o[i]<<" ";
        o[i] = 0;
    }
    cout<<endl;
    cout<<"Multiplication using GPU: ";
    int *p,*q,*r;
    cudaMalloc(&p,matrix_size);
    cudaMemcpy(p,m,matrix_size,cudaMemcpyHostToDevice);
    cudaMalloc(&q,vector_size);
    cudaMemcpy(q,n,vector_size,cudaMemcpyHostToDevice);
    cudaMalloc(&r,vector_size);
    cudaMemcpy(r,o,vector_size,cudaMemcpyHostToDevice);
    multiplyVectorAndMatrix<<<2,size/2>>>(p,q,r);
    cudaMemcpy(&o,r,vector_size,cudaMemcpyDeviceToHost);
    for(int i=0;i<size;i++){
        cout<<o[i]<<" ";
    }
    cout<<endl;

    //Matrix Multiplication
    int d[size][size],e[size][size],f[size][size];
    for(int i=0;i<size;i++){
        for(int j=0;j<size;j++){
            d[i][j] = rand()%10+1;
            e[i][j] = rand()%10+1;
        }
    }
    cout<<endl;
    cout<<"Matrix:"<<endl;
    for(int i=0;i<size;i++){
        for(int j=0;j<size;j++){
            cout<<d[i][j]<<" ";
        }
        cout<<endl;
    }
    cout<<endl;
    cout<<"Matrix:"<<endl;
    for(int i=0;i<size;i++){
        for(int j=0;j<size;j++){
            cout<<e[i][j]<<" ";
        }
        cout<<endl;
    }
    cout<<endl;
    cout<<"Multiplication using CPU:"<<endl;
    for(int i=0;i<size;i++){
        for(int j=0;j<size;j++){
            f[i][j] = 0;
            for(int k=0;k<size;k++){
                f[i][j] += d[i][k] * e[k][j];
            }
        }
    }
    for(int i=0;i<size;i++){
        for(int j=0;j<size;j++){
            cout<<f[i][j]<<" ";
            f[i][j] = 0;
        }
        cout<<endl;
    }
    cout<<endl;
    cout<<"Multiplication using GPU:"<<endl;
    int *g,*h,*ii;
    cudaMalloc(&g,matrix_size);
    cudaMemcpy(g,d,matrix_size,cudaMemcpyHostToDevice);
    cudaMalloc(&h,matrix_size);
    cudaMemcpy(h,e,matrix_size,cudaMemcpyHostToDevice);
    cudaMalloc(&ii,matrix_size);
    cudaMemcpy(ii,f,matrix_size,cudaMemcpyHostToDevice);
	dim3 threadsPerblock(size,size);
	dim3 blocksPerGrid(1,1);

	if(size*size>512)
	{
	threadsPerblock.x = 512;
	threadsPerblock.y=512;
	blocksPerGrid.x = ceil(double(size)/double(threadsPerblock.x));
	blocksPerGrid.y = ceil(double(size)/double(threadsPerblock.y));

	}
    matrixMultiplication<<<blocksPerGrid,threadsPerblock>>>(g,h,ii);
    cudaMemcpy(&f,ii,matrix_size,cudaMemcpyDeviceToHost);
    for(int i=0;i<size;i++){
        for(int j=0;j<size;j++){
            cout<<f[i][j]<<" ";
        }
        cout<<endl;
    }
    cout<<endl;
}
