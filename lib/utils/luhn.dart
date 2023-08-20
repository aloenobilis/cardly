class Luhn {
  static int _compute(
    String data, {
    bool hasCheckDigit = true,
  }) {
    var isDouble = !hasCheckDigit;
    var sum = 0;

    for (var i = data.length - 1; i >= 0; i--) {
      final digit = data.codeUnitAt(i) - 48;

      if (digit < 0 || digit > 9) {
        throw ArgumentError('Only digits are valid input.');
      }

      if (isDouble) {
        final doubledDigit = digit * 2;
        if (doubledDigit > 9) {
          sum += doubledDigit - 9;
        } else {
          sum += doubledDigit;
        }
      } else {
        sum += digit;
      }
      isDouble = !isDouble;
    }

    return sum;
  }

  bool validate(String? data) {
    if (data == null || data.length < 2) {
      return false;
    }
    return _compute(data) % 10 == 0;
  }
}
