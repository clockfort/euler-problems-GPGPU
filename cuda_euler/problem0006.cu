#include <thrust/device_vector.h>
#include <thrust/sequence.h>
#include <stdio.h>

struct square { // older cards could use __mul24 here to do this on the FPU
	__device__ int operator()(int n) {
		return n*n;
	}
};

using namespace thrust;

int main() {
	device_vector<int> d_sequence(100);

	sequence(d_sequence.begin(), d_sequence.end(), 1);
	int squareOfSum = pow(reduce(d_sequence.begin(), d_sequence.end()), 2);

	transform(d_sequence.begin(), d_sequence.end(), d_sequence.begin(), square());
	int sumOfSquares = reduce(d_sequence.begin(), d_sequence.end());

	std::cout << "answer is: " << squareOfSum - sumOfSquares << std::endl;

    return 0;
}
