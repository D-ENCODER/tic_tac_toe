class FormController {
  String validator(String value, String label, [int length = 255]) {
    if (value.isEmpty) {
      return 'Please enter your $label';
    } else if (value.length > length) {
      return 'Maximum character is $length for $label';
    } else {
      return null;
    }
  }
}
