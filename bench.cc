#include <chrono>
#include <cstdint>
#include <iomanip>
#include <iostream>

constexpr auto iters = 500000000;

extern "C" uint64_t test_intervening_call(volatile uint64_t *, uint64_t,
                                          uint64_t);

alignas(16) volatile uint64_t buf = 0;

int main(int, char *argv[]) {
  uint64_t accumulator = 0;

  using namespace std::chrono;
  auto start = high_resolution_clock::now();
  for (size_t i = 0; i != iters; ++i)
    accumulator += test_intervening_call(&buf, 0, 1);
  auto end = high_resolution_clock::now();

  auto spent = duration_cast<milliseconds>(end - start).count();
  using namespace std;
  cout << "| "
       << fixed << setprecision(9) << (double)spent / iters << " ms/call | "
       << right << setw(9) << spent << " ms | "
       << left << setw(32) << argv[0] << " |"
       << endl;

  return 0;
}
