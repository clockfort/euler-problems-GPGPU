#include <thrust/device_vector.h>
#include <thrust/sequence.h>
#include <thrust/extrema.h>
#include <stdio.h>


struct number_of_unique_right_triangle_solutions_for_integer_perimeter {
	__device__ int operator()(int perimeter) {
		int solutions = 0;
		for (int c = 1; c < 400; c++) {
			for (int b = 1; b < c; b++) {
				for (int a = 1; a < b; a++) {
					solutions += ((a + b + c == perimeter) && (a*a + b*b == c*c)) ? 1 : 0;
				}
			}
		}
		return solutions;
	}
};

using namespace thrust;

int main() {
	device_vector<int> d_solutions(1000, 0);

	transform(make_counting_iterator(0), make_counting_iterator(1000), d_solutions.begin(), number_of_unique_right_triangle_solutions_for_integer_perimeter());
	int perimeter_with_max_solutions = (max_element(d_solutions.begin(), d_solutions.end())) - d_solutions.begin();
	
	std::cout << perimeter_with_max_solutions << std::endl;

	return 0;
}
