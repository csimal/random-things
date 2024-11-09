/*
*  random tree generator
*
*/


#include <stdlib.h>

#define MAX 10

struct Tree {
	void* data;
	Tree* child[MAX]
}

/*
	returns a randomly generated tree of size n

*/
Tree* random_tree(int n, int (*random)(int))
{
	Tree* tree = malloc(sizeof(Tree)); // the root of the tree
	
	int size = 1 // the current size of the tree
	int index = 0; // the index of the next subtree
	
	while(size<n){
		int i = (*random)(n-size);
		size += i;
		tree->child[index++] = random_tree(i);
	}
	
	return tree;
}

/*
	returns a random integer between 1 and n with uniform distribution
*/
int random_uniform_i(int n)
{
	return arc4random_uniform(n)+1;
}

