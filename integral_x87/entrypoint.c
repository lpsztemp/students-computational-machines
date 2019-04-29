#include <stdio.h>

extern "C" double integral(double a, double b);
	
int main(int argc, char** argv)
{
	printf("%g\n", (float) integral(0, 1));
	return 0;
}