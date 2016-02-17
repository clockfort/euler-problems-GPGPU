#include <thrust/device_vector.h>
#include <thrust/sequence.h>
#include <stdio.h>

__int64 MAX_VALUE = 300000000;

struct divisibleByAll {
	__device__ bool operator()(int n) {
		for (int i = 1; i < 20; i++) {
			if (n % i != 0)
				return false;
		}
		return true;
	}
};

using namespace thrust;

int main() {
	device_vector<int> d_sequence(MAX_VALUE);
	device_vector<bool> d_results(MAX_VALUE, false);

	sequence(d_sequence.begin(), d_sequence.end(), 1);

	transform(d_sequence.begin(), d_sequence.end(), d_results.begin(), divisibleByAll());

	__int64 minDivisibleByAll = find(d_results.begin(), d_results.end(), true) - d_results.begin() + 1;

	std::cout << "answer is: " << minDivisibleByAll << std::endl;

	return 0;
}
