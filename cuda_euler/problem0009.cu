#include <thrust/device_vector.h>
#include <thrust/sequence.h>
#include <thrust/transform_reduce.h>
#include <stdio.h>

const int UPPER_BOUND = 1000;
__device__ int* square_lut;

struct pythagoreanTripletFilter {
	__device__ int operator()(int a) {
		for (int b = 1; b < a; b++) {
			int apb = square_lut[a] + square_lut[b];
			int c = sqrt((double)apb);
			if (a + b + c == UPPER_BOUND && c * c == apb) {
				return a*b*c;
			}
		}
		return 0;
	}
};

using namespace thrust;

int main() {
	device_vector<int> d_square(UPPER_BOUND);
	device_vector<int> d_sequence(UPPER_BOUND);

	int* h_input_ptr = raw_pointer_cast(d_square.data());
	cudaMemcpyToSymbol(square_lut, &h_input_ptr, sizeof(int*));

	// construct a LUT for small squares
	sequence(d_square.begin(), d_square.end());
	sequence(d_sequence.begin(), d_sequence.end());
	transform(d_sequence.begin(), d_sequence.end(), d_square.begin(), d_square.begin(), multiplies<__int64>());

	int justAnswer = transform_reduce(d_sequence.begin(), d_sequence.end(), pythagoreanTripletFilter(), 0, maximum<int>());

	std::cout << justAnswer << std::endl;

	return 0;
}
