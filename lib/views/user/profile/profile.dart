import 'dart:developer';
import 'dart:io';

import 'package:book/services/appstore.dart';
import 'package:book/services/auth_services.dart';
import 'package:book/views/auth/login.dart';
import 'package:book/widgets/show_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../../utils/asset_manager.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isPasswordVisible = false;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _old_passwordController = TextEditingController();
  final TextEditingController _new_passwordController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => {Provider.of<Appstore>(context, listen: false).initializeUserData()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          'My Profile',
          style: GoogleFonts.nunito(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<Appstore>(builder: (context, value, _) {
          _firstNameController.text = value.user?.firstName ?? "";
          _lastNameController.text = value.user?.lastName ?? "";
          _emailController.text = value.user?.email ?? "";

          return ListView(
            children: [
              _buildProfileImageSection(
                  image: value.user?.profile_pic ??
                      "https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg",
                  id: value.user?.userId.toString() ?? ""),
              const SizedBox(height: 24),
              _buildNameAndEmailSection(value),
              const SizedBox(height: 24),
              _buildPasswordSection(
                  id: value.user?.userId.toString() ?? "",
                  old: _old_passwordController,
                  news: _new_passwordController),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildProfileImageSection({required String image, required String id}) {
    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: _selectedImage != null
                    ? FileImage(_selectedImage!)
                    : CachedNetworkImageProvider(image != ""
                            ? image
                            : "https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg")
                        as ImageProvider,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: AssetManager.baseTextColor11,
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Consumer<AuthServices>(builder: (context, value, _) {
          return ElevatedButton(
            onPressed: () async {
              // _selectedImage != null ? _updateProfileImage() : null;
              if (_selectedImage != null) {
                // _updateProfileImage(file: _selectedImage!, id: id);
                final resp = await value.updateProfilePicture(image: _selectedImage!, id: id, isUser: true);

                if (resp == true) {
                  showToast(
                      message: "Profile pic has updated successfully", type: ToastificationType.success);
                  navigatePopUp();
                } else {
                  showToast(
                      message: "Error updating profile photo. Try again later.",
                      type: ToastificationType.error);
                }
              } else {
                showToast(message: "Nothing to update", type: ToastificationType.success);
              }
            },
            child: value.isLoading
                ? SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(),
                  )
                : Text('Update Profile Image'),
          );
        }),
      ],
    );
  }

  void _pickImage() async {
    // var status = await Permission.storage.request();
    // if (status.isGranted) {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
    // } else {
    //   showToast(message: "Storage permission is required", type: ToastificationType.warning);
    // }
  }

  void _updateProfileImage({required File file, required String id}) async {
    log("_updateProfileImage called.");
    final resp =
        await Provider.of<AuthServices>(context).updateProfilePicture(image: file, id: id, isUser: true);

    if (resp == true) {
      showToast(message: "Profile pic has updated successfully", type: ToastificationType.success);
      navigatePopUp();
    } else {
      showToast(message: "Error updating profile photo. Try again later.", type: ToastificationType.error);
    }
  }

  void navigatePopUp() {
    Navigator.pop(context);
  }

  Widget _buildNameAndEmailSection(Appstore value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('First Name', _firstNameController),
        const SizedBox(height: 16),
        _buildTextField('Last Name', _lastNameController),
        const SizedBox(height: 16),
        _buildTextField('E-mail', _emailController),
        const SizedBox(height: 16),
        Consumer<AuthServices>(builder: (context, auth, _) {
          return ElevatedButton(
            onPressed: () async {
              if (_firstNameController.text == value.user?.firstName &&
                  _lastNameController.text == value.user?.lastName &&
                  _emailController.text == value.user?.email) {
                showToast(message: "No fields to update.", type: ToastificationType.success);
                return;
              }

              final user_id = value.user?.userId;
              final first_name =
                  _firstNameController.text.isEmpty ? value.user?.firstName ?? "" : _firstNameController.text;
              final last_name =
                  _lastNameController.text.isEmpty ? value.user?.lastName ?? "" : _lastNameController.text;
              final email = _emailController.text.isEmpty ? value.user?.email ?? "" : _emailController.text;

              final resp = await Provider.of<AuthServices>(context, listen: false).updateProfile(
                  id: user_id.toString(),
                  first_name: first_name,
                  last_name: last_name,
                  email: email,
                  context: context,
                  isUser: true);

              if (resp == true) {
                showToast(message: "Profile has updated successfully.", type: ToastificationType.success);
                // await Provider.of<Appstore>(context, listen: false).signOut();
                // navigateToLogin();
                navigatePopUp();
              } else {
                showToast(message: "Something went wrong. Try again later.", type: ToastificationType.error);
              }
            },
            child: auth.isLoading
                ? SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      strokeAlign: 2,
                    ),
                  )
                : const Text('Update Details'),
          );
        }),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            color: Colors.grey.withOpacity(.8),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: GoogleFonts.nunito(
              color: Colors.grey.withOpacity(.8),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(.8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _updateUserDetails(
      {required int user_id,
      required String first_name,
      required String last_name,
      required String email}) async {
    final resp = await Provider.of<AuthServices>(context, listen: false).updateProfile(
        id: user_id.toString(),
        first_name: first_name,
        last_name: last_name,
        email: email,
        context: context,
        isUser: true);

    if (resp == true) {
      showToast(message: "Profile has updated successfully.", type: ToastificationType.success);
      // await Provider.of<Appstore>(context, listen: false).signOut();
      // navigateToLogin();
      navigatePopUp();
    } else {
      showToast(message: "Something went wrong. Try again later.", type: ToastificationType.error);
    }
  }

  Widget _buildPasswordSection(
      {required String id, required TextEditingController old, required TextEditingController news}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Change Password',
          style: GoogleFonts.nunito(
            color: Colors.grey.withOpacity(.8),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        _buildPasswordField(() {
          isPasswordVisible = !isPasswordVisible;
          setState(() {});
        }, "Old password", old),
        const SizedBox(height: 8),
        _buildPasswordField(() {
          isPasswordVisible = !isPasswordVisible;
          setState(() {});
        }, "New password", news),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            _changePassword(id: id, old_password: old.text, new_password: news.text);
          },
          child: const Text('Change Password'),
        ),
      ],
    );
  }

  Widget _buildPasswordField(Function() toggleVisibility, String hinttext, TextEditingController value) {
    return TextFormField(
      obscureText: isPasswordVisible,
      controller: value,
      decoration: InputDecoration(
        hintText: hinttext,
        hintStyle: GoogleFonts.nunito(
          color: Colors.grey.withOpacity(.8),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: toggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(.8),
          ),
        ),
      ),
    );
  }

  void _changePassword(
      {required String id, required String old_password, required String new_password}) async {
    log("_changePassword called.");

    log("id: ${id}");
    log("new_password: ${new_password}");
    log("old_password: ${old_password}");

    if (new_password == "" || old_password == "") {
      showToast(message: "Passwords field can't be empty", type: ToastificationType.error);
      return;
    }

    final resp = await Provider.of<AuthServices>(context, listen: false)
        .changePassword(id: id, old_password: old_password, new_password: new_password, isUser: false);

    if (resp == true) {
      showToast(message: "Password has changed successfully", type: ToastificationType.success);
      await Provider.of<Appstore>(context, listen: false).signOut();
      navigateToLogin();
    } else {
      showToast(
          message: "Something went wrong! or old password won't matched", type: ToastificationType.error);
    }
  }

  void navigateToLogin() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
