#include<bits/stdc++.h>
#include<omp.h>
#include<time.h>
// #include<ctime>
using namespace std;
// C program to demonstrate insert operation in binary search tree 
#include<stdio.h> 
#include<stdlib.h> 

struct node 
{ 
	int key; 
	struct node *left, *right; 
}; 

// A utility function to create a new BST node 
struct node *newNode(int item) 
{ 
	struct node *temp = (struct node *)malloc(sizeof(struct node)); 
	temp->key = item; 
	temp->left = temp->right = NULL; 
	return temp; 
} 

// A utility function to do inorder traversal of BST 

/* A utility function to insert a new node with given key in BST */
struct node* insert(struct node* node, int key) 
{ 
	/* If the tree is empty, return a new node */
	if (node == NULL) return newNode(key); 

	/* Otherwise, recur down the tree */
	if (key < node->key) 
		node->left = insert(node->left, key); 
	else if (key > node->key) 
		node->right = insert(node->right, key); 

	/* return the (unchanged) node pointer */
	return node; 
} 



void dfs(struct node *root)
{
	if(root==NULL)
		return;
	dfs(root->left);
	// cout<<root->key<<" ";
	dfs(root->right);
}
void parallelDfs(node *root){
	if(root != NULL){
#pragma omp parallel sections
		{
		#pragma omp section
			{
				parallelDfs(root->left);
			}
#pragma omp section
			{
				// cout << root->key << " ";
			}
#pragma omp section
			{
				parallelDfs(root->right);
			}
		}
	}
}

int main()
{
	struct node *root = NULL; 
	root = insert(root, 50); 
	// srand(clock());
	int i=100000;
	while(i>0){
	insert(root, rand()); 
	i--;
	}
	cout<<"Inorder traversal\n";
	clock_t start = clock();
	// cout<<start<<endl;
	dfs(root);
	// float end = omp_get_wtime();
	cout << "\nTime for serial : " << (float)(clock()-start)/(CLOCKS_PER_SEC)<<endl;
	clock_t start1 = clock();
    // start = omp_get_wtime();
	parallelDfs(root);
	// float end = omp_get_wtime();	
	cout << "\nTime for Parallel : " << (float)(clock() - start1)/(CLOCKS_PER_SEC)<<endl;
	return 0;

}