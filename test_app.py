from app import multiply_by_two

def test_multiply_by_two():
    # Проверяем, что 5 умножить на 2 действительно будет 10
    assert multiply_by_two(5) == 10
