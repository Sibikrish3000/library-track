class Validators {
  const Validators._();

  static String? requiredField(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  static String? validateIsbn(String? value) {
    if (value == null || value.isEmpty) {
      return null; // ISBN is optional
    }

    // Remove hyphens and spaces
    final cleanedValue = value.replaceAll(RegExp(r'[-\s]'), '');

    // Check if it's 10 or 13 digits
    if (!RegExp(r'^\d{10}$|^\d{13}$').hasMatch(cleanedValue)) {
      return 'Invalid ISBN format (must be 10 or 13 digits)';
    }

    return null;
  }

  static String? validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Year is optional
    }

    final year = int.tryParse(value);
    if (year == null) {
      return 'Invalid year';
    }

    final currentYear = DateTime.now().year;
    if (year < 1000 || year > currentYear) {
      return 'Year must be between 1000 and $currentYear';
    }

    return null;
  }
}
