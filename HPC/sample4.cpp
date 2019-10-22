#include<bits/stdc++.h>
#include<ctime>
#include<omp.h>

using namespace std;

class node{
public:
	int data;
	node *left;
	node *right;
	node(int d){
		data=d;
	}
};

void dfs(node *current){
	if(current==NULL){
		return;
	
	dfs(current->left);
	cout<<current->data<<" ";
	dfs(current->right);
}

void parallel_dfs(node *current){
	if(current!=NULL){
#pragma omp parallel sections
		{
#pragma omp section
			{
				parallel_dfs(current->left);
			}
#pragma omp section
			{
				cout<<current->data<<"  ";
			}
#pragma omp section
			{
				parallel_dfs(current->right);
			}
		}
	}
}

int main(int argc, char const *argv[])
{
	node *root  = new node(5);
	root->left = new node(7);
	root->right = new node(1);
	root->left->left = new node(8);
	root->left->right = new node(10);

	cout<<"Sequencial traversal"<<endl;
	dfs(root);
	cout<<endl;
	cout<<"Parallel traversal"<<endl;
	float start = omp_get_wtime();
	parallel_dfs(root);
	float end = omp_get_wtime();
	cout<<"Time taken : "<<end-start<<endl;


	return 0;
}