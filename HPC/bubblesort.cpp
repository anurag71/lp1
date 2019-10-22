#include<bits/stdc++.h>
#define SIZE 2000
using namespace std;

void bubblesort(int *a)
{
	for(int i=0;i<SIZE;i++)
	{
		for(int j=0;j<SIZE-1;j++)
		{
			if(a[j]>a[j+1])
			{
				swap(a[j],a[j+1]);
			}
		}
	}
}

void parallel_bubblesort(int *a)
{
	for(int i=0;i<SIZE;i++)
	{
		int first = i%2;

		#pragma omp parallel for default(none),shared(a,first)
		for(int j=first;j<SIZE-1;j=j+1)
		{
			if(a[j] > a[j+1]){
				swap(a[j], a[j+1]);
			}
		}
	}
}

int main()
{
	int *a,*b;
	a = (int *)malloc(SIZE*sizeof(int));
	b = (int *)malloc(SIZE*sizeof(int));
	
	for(int i=0;i<SIZE;i++)
	{
		a[i]=rand()%324392;
		b[i]=a[i];
		
	}

	clock_t timer = clock();
	bubblesort(a);
	cout<<"Time taken for serial bubble sort"<<(float)(clock() - timer)/CLOCKS_PER_SEC;
	cout<<"\n";
	timer = clock();
	parallel_bubblesort(b);
	cout<<"Time taken for parallel bubble sort"<<(float)(clock()-timer)/CLOCKS_PER_SEC;
	for(int i = 0;i < SIZE;i ++){
		if(a[i] != b[i]){
			cout << "\nIncorrect result";
			break;
		}
	}

}