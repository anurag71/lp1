#include <omp.h>
#include <stdio.h>
#include <stdlib.h>

void swap(int *num1, int *num2){
        int temp = *num1;
        *num1 = *num2;
        *num2 = temp; 
}

void generate(int *a, int SIZE){
        for (int i=0;i<SIZE;i++){
                a[i] = rand()%50+1;
        }
}

void print(int *a, int SIZE){
        for(int i=0;i<SIZE;i++){ 
                printf("%d ",a[i]);
        }
        printf("\n\n");
}

void mergesort(int *a, int SIZE, int *temp){
        if(SIZE<2){
                return;
        }
        #pragma omp task firstprivate (a,SIZE,temp)
        mergesort(a,SIZE/2,temp);
        #pragma omp task firstprivate (a,SIZE,temp)
        mergesort(a+(SIZE/2), SIZE-(SIZE/2), temp);
        #pragma omp taskwait
	merge(a,SIZE,temp);
}

void merge(int *a, int SIZE, int *temp){
        int i=0,j=SIZE/2,ti=0;
        while(i<SIZE/2 && j<SIZE){
                if(a[i]<a[j]){
                        temp[ti] = a[i];
                        ti++;
                        i++;
                }
                else{
                        temp[ti] = a[j];
                        ti++;
                        j++;
                }
        }
 	while(i<SIZE/2){
                temp[ti] = a[i];
                ti++;
                i++;
        }
        while(j<SIZE){
                temp[ti] = a[j];
                ti++;
                j++;
        }
        memcpy(a,temp,SIZE*sizeof(int));
}

int main(){
        int SIZE = 10;
        int a[SIZE];
        generate(a,SIZE);
	printf("Before Sorting: ");
        print(a,SIZE);
        int i=0,j=0,first;
        double start,end;
        printf("BUBBLE SORT:\n");
        start = omp_get_wtime();
        for(i=0;i<SIZE;i++){
                first = i%2;
                #pragma omp parallel for default(none),shared(a,first,SIZE)
                for(j=first;j<SIZE-1;j++){
                        if(a[j]>a[j+1]){
                                swap(&a[j],&a[j+1]);
                        }
                }
        }
        end = omp_get_wtime();
        printf("After Sorting: ");
	print(a,SIZE);
        printf("Time Parallel: %f\n\n",(end-start));

        printf("MERGE SORT:\n");
        int temp[SIZE];
        generate(a,SIZE);
        printf("Before Sorting: ");
        print(a,SIZE);
        start = omp_get_wtime();
        #pragma omp parallel
        {
                #pragma omp single
                mergesort(a,SIZE,temp);
        }
        end = omp_get_wtime();
        printf("After Sorting: ");
        print(a,SIZE);
	printf("Time Parallel: %f\n",(end-start));
}


