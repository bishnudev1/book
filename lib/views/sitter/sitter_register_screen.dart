import 'package:book/services/sitter_services.dart';
import 'package:book/utils/asset_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../services/auth_services.dart';
import '../../widgets/exit_app.dart';
import '../../widgets/show_toast.dart';
import 'confirm_sitter_register.dart';

class SitterRegisterScreen extends StatefulWidget {
  const SitterRegisterScreen({Key? key}) : super(key: key);

  @override
  State<SitterRegisterScreen> createState() => _SitterRegisterScreenState();
}

class _SitterRegisterScreenState extends State<SitterRegisterScreen> {
  bool showPassword = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController(); // Description controller
  final TextEditingController _perHourChargeController =
      TextEditingController(); // Per Hour Charge controller

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => Provider.of<AuthServices>(context, listen: false).getPinCodeList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              onback(context);
            }
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    AssetManager.loginBG, // Replace with your asset path
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Sitter Register",
                  style: GoogleFonts.abel(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Please sign up to create an account.",
                  style: GoogleFonts.abel(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),

                // First Name Field
                buildTextField(
                    label: 'First Name', icon: Icons.person_outline, controller: _firstNameController),
                const SizedBox(height: 16),

                // Last Name Field
                buildTextField(
                    label: 'Last Name', icon: Icons.person_outline, controller: _lastNameController),
                const SizedBox(height: 16),

                // Zip Code Field
                // buildTextField(
                //     label: 'Zip Code',
                //     icon: Icons.location_on_outlined,
                //     keyboardType: TextInputType.number,
                //     controller: _zipCodeController),
                Consumer<AuthServices>(builder: (context, value, _) {
                  return buildZipCodeAutocompleteField(otps: value.pinCodeList);
                }),
                const SizedBox(height: 16),

                // Email Field
                buildTextField(
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController),
                const SizedBox(height: 16),

                // Password Field
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade200,
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: showPassword,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.key_outlined,
                        color: Colors.grey[600],
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: showPassword
                            ? const Icon(Icons.remove_red_eye_outlined)
                            : const Icon(Icons.remove_red_eye),
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.grey[900]),
                  ),
                ),
                const SizedBox(height: 20),

                // Per Hour Charge Field (added here)
                buildTextField(
                    label: 'Per Hour Charge',
                    icon: Icons.money_outlined,
                    keyboardType: TextInputType.number,
                    controller: _perHourChargeController),
                const SizedBox(height: 16),

                // Description Field
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade200,
                  ),
                  child: TextFormField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    minLines: 5, // Minimum number of lines
                    maxLines: 10, // Maximum number of lines
                    textAlignVertical: TextAlignVertical.top, // Align text to the top
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.description_outlined,
                        color: Colors.grey[600],
                      ),
                      labelText: 'Description'.toUpperCase(),
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.grey[900]),
                  ),
                ),
                const SizedBox(height: 28),

                // Next Button
                Consumer<SitterServices>(builder: (context, value, _) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AssetManager.baseTextColor11, // Button background color
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: InkWell(
                      onTap: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (_firstNameController.text.isNotEmpty &&
                              _lastNameController.text.isNotEmpty &&
                              _zipCodeController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty &&
                              _perHourChargeController
                                  .text.isNotEmpty && // Include Per Hour Charge validation
                              _descriptionController.text.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConfirmSitterRegister(sitter: {
                                  'firstName': _firstNameController.text,
                                  'lastName': _lastNameController.text,
                                  'zipCode': _zipCodeController.text,
                                  'email': _emailController.text,
                                  'password': _passwordController.text,
                                  'perHourCharge': _perHourChargeController.text, // Pass Per Hour Charge
                                  'description': _descriptionController.text
                                }),
                              ),
                            );
                          } else {
                            showToast(message: "Please fill out all fields", type: ToastificationType.error);
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            'Next',
                            style: GoogleFonts.lato(
                              color: Colors.white, // Button text color
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build TextFormField
  Widget buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isUpperCase = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade200,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.grey[600],
          ),
          labelText: isUpperCase ? label.toUpperCase() : label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.grey[900]),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget buildZipCodeAutocompleteField({required List<String> otps}) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return otps.where((zip) => zip.contains(textEditingValue.text));
      },
      onSelected: (String selection) {
        _zipCodeController.text = selection;
      },
      fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), // Border radius for the text field
            color: Colors.grey.shade200,
          ),
          child: TextFormField(
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            decoration: InputDecoration(
              labelText: 'Zip Code',
              prefixIcon: const Icon(Icons.location_on_outlined),
              labelStyle: TextStyle(color: Colors.grey[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20), // Apply border radius to the text field
                borderSide: BorderSide.none, // Remove border side for a clean look
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
            ),
          ),
        );
      },
      optionsViewBuilder:
          (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20), // Border radius for the dropdown
              elevation: 4.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), // Applying border radius
                  color: Colors.white,
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        onSelected(option);
                      },
                      child: ListTile(
                        title: Text(option),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
