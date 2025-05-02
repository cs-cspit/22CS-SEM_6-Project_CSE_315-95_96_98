import 'dart:convert';
import 'dart:io';
import 'package:driver_app/api_helper/Driver_basic/driver_basic.dart';
import 'package:driver_app/state_classes/Authentication/auth_state.dart';
import 'package:driver_app/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:driver_app/utils/app_colors.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController plateNumberController;
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode plateFocusNode = FocusNode();
  File? profileImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 80);

      if (pickedFile != null) {
        setState(() {
          profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Image picker error: $e");
    }
  }

  Future<void> _submitData() async {
    final name = nameController.text.trim();
    final plateNumber = plateNumberController.text.trim();

    if (name.isEmpty && plateNumber.isEmpty && profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please make at least one change.")),
      );
      return;
    }

    try {
      final response = await DriverBasic.updateDriverProfile(
        name: name.isNotEmpty ? name : null,
        plateNumber: plateNumber.isNotEmpty ? plateNumber : null,
        profileImage: profileImage,
        context: context,
      );

      final responseData = jsonDecode(response.body);

      // Check if the response was successful
      if (response.statusCode == 200 && responseData['success'] == true) {
        final driver = responseData['driver'];

        if (driver != null) {
          final authState = Provider.of<AuthState>(context, listen: false);
          // Update AuthState with driver data
          authState.updateFullName(driver['full_name']);
          authState.updatePhoneNumber(driver['phone_no']);
          authState.updatePlateNumber(driver['plate_number']);
          authState.updateImagePath(driver['driver_photo']);
          authState.updateOnDuty(driver['on_duty']);
          authState.updateIsAvailable(driver['is_available']);
          authState.updateWalletAmount(driver['wallet_amount']);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(responseData['message'] ??
                    "Profile updated successfully!")),
          );
          
          Navigator.pop(context); // Close the profile update screen
        } else {
          // Handle case where driver data is null
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text("Failed to update profile. Driver data is missing.")),
          );
        }
      } else {
        // Handle case where API response is unsuccessful
        final errorMessage =
            responseData['message'] ?? "Failed to update profile.";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      // Handle network or unexpected errors
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final authState = Provider.of<AuthState>(context, listen: false);
    nameController = TextEditingController(text: authState.fullName);
    plateNumberController = TextEditingController(text: authState.plateNumber);
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: profileImage != null
                        ? FileImage(profileImage!) // Local image if selected
                        : authState.imagePath.isNotEmpty
                            ? NetworkImage(
                                "${AppConstants.getProfilePhoto}${authState.imagePath}",
                              ) as ImageProvider
                            : AssetImage('assets/images/driver_captain.jpg'),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  authState.fullName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: nameController,
                  focusNode: nameFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: plateNumberController,
                  focusNode: plateFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Plate Number',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellowGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
