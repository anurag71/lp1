#include<omp.h>
#include<stdio.h>
#include<stdlib.h>
// #include<string.h>

void swap(int *num1, int *num2){
	int temp = *num1;
	*num1 = *num2;
	*num2 = temp;
}

void generate(int *a, int SIZE){
	for(int i=0;i<SIZE;i++){
		a[i]=rand()%50;
	}
}

void print(int *a, int SIZE){
	for(int i=0;i<SIZE;i++){
		printf("%d ",a[i]);
	}
	printf("\n\n");
}

void merge(int *a,int SIZE, int *temp)
{
	int i=0,j=SIZE/2,ti=0;
	while(i<(SIZE/2) && j<SIZE)
	{
		if(a[i]<a[j]){
			temp[ti]=a[i];
			i++;
			ti++;
		}
		else{
			temp[ti]=a[j];
			j++;
			ti++;
		}
	}
	while(i<(SIZE/2)){
		temp[ti]=a[i];
		ti++;
		i++;
	}
	while(j<(SIZE)){
		temp[ti]=a[j];
		ti++;
		j++;
	}
	memcpy(a,temp,SIZE*sizeof(int));
}

void mergesort(int *a,int SIZE, int *temp)
{
	 if(SIZE<2)
	 {
	 	return;
	 }
	 #pragma omp task firstprivate (a,SIZE,temp)
	 mergesort(a,SIZE/2,temp);
	 #pragma omp task firstprivate (a,SIZE,temp)
	 mergesort(a+(SIZE/2),SIZE-(SIZE/2),temp);
	 #pragma omp taskwait
	 merge(a,SIZE,temp);
}


int main(int argc, char const *argv[])
{
	int SIZE;
	printf("Enter the size of array:");
	scanf("%d",&SIZE);
	int a[SIZE];
	generate(a,SIZE);
	printf("BUBBLE SORT\n");
	printf("Before sorting\n");
	// print(a,SIZE);

	double start,end;
	start = omp_get_wtime();
	int first;
	for(int i=0;i<SIZE;i++)
	{
		first=i%2;
		#pragma omp parallel for default(none), shared(a,first,SIZE)
		for(int j=first;j<SIZE-1;j++)
		{
			if(a[j]>a[j+1])
			{
				swap(&a[j],&a[j+1]);
			}
		}
	}
	end = omp_get_wtime();
	printf("AFTER SORTING\n");
	// print(a,SIZE);
	printf("Time required:%f",(end-start));


	printf("MERGE SORT\n");
	generate(a,SIZE);
	printf("Before sorting\n");
	// print(a,SIZE);
	int temp[SIZE];

	start = omp_get_wtime();
	#pragma omp parallel
       	{
                #pragma omp single
                mergesort(a,SIZE,temp);
        }
	end = omp_get_wtime();
	printf("AFTER SORTING\n");
	// print(a,SIZE);
	printf("Time required:%f",(end-start));
	return 0;
}