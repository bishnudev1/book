String? validateEmptyString(String value, String fieldName) {
  if (value.isEmpty) {
    return "      $fieldName is required!";
  }
  return null;
}

String validateEmptyDouble(double value) {
  if (value == 0) {
    return "Field is required!";
  }
  return '';
}

String? validateName(String value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return "Name is Required";
  } else if (!regExp.hasMatch(value)) {
    return "Name must be a-z and A-Z";
  }
  return null;
}

String? validateMobile(String value, String validateName) {
  if (value.isEmpty) {
    return validateName.isNotEmpty ? "$validateName is Required" : "Mobile number is Required";
  } else if (value.length < 7) {
    return "Please enter valid mobile number";
  }
  return null;
}

String? validateMobileNumWithRgx(String value) {
  String patterns = "^(\\d{3}[- ]?){2}\\d{4}";
  RegExp regExp = RegExp(patterns);
  if (value.isEmpty) {
    return 'Please enter a valid phone number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter a valid mobile number';
  } else if (value.length > 10) {
    return "Please enter only 10 digit numbers";
  }
  return null;
}

String? validateZipCode(String value) {
  if (value.isEmpty) {
    return "Zip code is required";
  } else if (value.length < 5) {
    return "Please enter valid zip code";
  }
  return null;
}

String? validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return "      Email is Required";
  } else if (!regExp.hasMatch(value)) {
    return "      Invalid Email";
  } else {
    return null;
  }
}

bool isValidateEmailId(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    //"Email is Required"
    return false;
  } else if (!regExp.hasMatch(value)) {
    //"Invalid Email"
    return false;
  } else {
    //"Valid Email";
    return true;
  }
}

String? validatePass(String value, bool isConfirmPass) {
  if (value.isEmpty) {
    return isConfirmPass ? 'Please enter your password' : 'Password is Required';
  } else if (value.length < 8) {
    return 'Please enter atleast 8 character';
  }
  return null;
}
