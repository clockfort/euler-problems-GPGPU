#include <thrust/device_vector.h>
#include <thrust/sequence.h>
#include <stdio.h>

struct matches {
	__host__ __device__ int operator()(int x) {
		return (x % 3 == 0 || x % 5 == 0) ? x : 0;
	}
};

using namespace thrust;

int main() {
	device_vector<int> d_sequence(1000);
	sequence(d_sequence.begin(), d_sequence.end(), 0);
	transform(d_sequence.begin(), d_sequence.end(), d_sequence.begin(), matches());
	int sum = reduce(d_sequence.begin(), d_sequence.end(), 0, thrust::plus<int>());
	std::cout << "answer is :" << sum << std::endl;

    return 0;
}