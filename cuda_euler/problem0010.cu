#include <thrust/device_vector.h>
#include <thrust/sequence.h>
#include <stdio.h>

const int UPPER_BOUND = 2000000;
__device__ __int64* input_ptr;
__device__ __int64* output_ptr;

struct sieve {
	__device__ __int64 operator()(int index) {
		if (index <= 1) {
			output_ptr[index] = 0;
		}
		else {
			for (__int64 multiplier = 2, result; (result = multiplier * index) < UPPER_BOUND; multiplier++) {
				output_ptr[result] = 0; // zero out all composites
			}
		}
		return index;
	}
};

using namespace thrust;

int main() {
	device_vector<__int64> d_input(UPPER_BOUND);
	device_vector<__int64> d_output(UPPER_BOUND);
	__int64* h_input_ptr = raw_pointer_cast(d_input.data());
	__int64* h_output_ptr = raw_pointer_cast(d_output.data());
	cudaMemcpyToSymbol(input_ptr, &h_input_ptr, sizeof(__int64*));
	cudaMemcpyToSymbol(output_ptr, &h_output_ptr, sizeof(__int64*));

	sequence(d_output.begin(), d_output.end());

	transform(make_counting_iterator(0), make_counting_iterator(UPPER_BOUND), d_input.begin(), sieve());

	__int64 sum = reduce(d_output.begin(), d_output.end());
	std::cout << "answer is: " << sum << std::endl;

	return 0;
}
