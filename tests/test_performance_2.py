import time
import pytest

# Simple performance test
@pytest.mark.benchmark
def test_slow_2():
    start = time.time()
    time.sleep(5)  # Simulate a slow operation
    end = time.time()
    assert (end - start) < 6  # Expect it to finish in under 6 seconds
