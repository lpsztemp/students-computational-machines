#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

extern "C" void memmul(const void* X, const void* Y, void* Z, unsigned cb);

int main(int argc, char** argv)
{
	uint8_t X[] = {0x12, 0x34, 0x56, 0x78, 0x9a, 0xbc, 0xde};
	uint8_t Y[] = {0x12, 0x34, 0x56, 0x78, 0x9a, 0xbc, 0xde};
	uint8_t Z[sizeof(X)];

	memmul(X, Y, Z, sizeof(X));
	printf("X: ");
	for (unsigned int i = 0; i < sizeof(X); ++i)
		printf("%02X ", X[i]);
	printf("\nY: ");
	for (unsigned int i = 0; i < sizeof(Y); ++i)
		printf("%02X ", Y[i]);
	printf("\nZ: ");
	for (unsigned int i = 0; i < sizeof(Z); ++i)
		printf("%02X ", Z[i]);
	printf("\n");
	return 0;
}