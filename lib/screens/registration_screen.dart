import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:special_one_student/services/authentication_service.dart';
import 'package:special_one_student/config/localization.dart';
import 'package:special_one_student/widgets/custom_button.dart';
import 'package:special_one_student/widgets/custom_textfield.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _studentPhoneController = TextEditingController();
  final TextEditingController _parentPhoneController = TextEditingController();
  final TextEditingController _stageController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _centerController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.register),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: _fullNameController,
                labelText: l.fullName,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _usernameController,
                labelText: l.username,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _studentPhoneController,
                labelText: l.studentPhone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _parentPhoneController,
                labelText: l.parentPhone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _stageController,
                labelText: l.educationStage,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _ageController,
                labelText: l.age,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _centerController,
                labelText: l.learningCenter,
              ),
              const SizedBox(height: 16.0),
              if (_imageFile != null)
                Image.file(File(_imageFile!.path), height: 150),
              CustomButton(
                onPressed: _pickImage,
                text: l.uploadImage,
              ),
              const SizedBox(height: 16.0),
              CustomButton(
                onPressed: () async {
                  if (_imageFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l.required),
                      ),
                    );
                    return;
                  }
                  final Uint8List imageBytes = await _imageFile!.readAsBytes();
                  final String imageName = _imageFile!.name;
                  final bool success = await _authService.register(
                    {
                      'fullName': _fullNameController.text,
                      'username': _usernameController.text,
                      'studentPhone': _studentPhoneController.text,
                      'parentPhone': _parentPhoneController.text,
                      'stage': _stageController.text,
                      'age': _ageController.text,
                      'center': _centerController.text,
                    },
                    imageBytes,
                    imageName,
                  );
                  if (success) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l.registrationFailed),
                      ),
                    );
                  }
                },
                text: l.register,
              ),
            ],
          ),
        ),
      ),
    );
  }
}