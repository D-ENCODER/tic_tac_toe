import 'dart:math';

class RandomGenerator {
  Random _random;

  RandomGenerator() {
    _random = Random();
  }

  String generateNumber(int length) {
    String number = '';
    for (int i = 0; i < length; i++) {
      number += _random.nextInt(9).toString();
    }
    return number;
  }
}
