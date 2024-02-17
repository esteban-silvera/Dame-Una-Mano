import 'package:flutter/material.dart';

import 'auth_field.dart';

class RegisterFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const RegisterFormFields({
    Key? key,
    required this.nameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        NameField(controller: nameController),
        const SizedBox(height: 10),
        LastNameField(controller: lastNameController),
        const SizedBox(height: 10),
        EmailField(controller: emailController),
        const SizedBox(height: 10),
        PasswordField(controller: passwordController),
        const SizedBox(height: 20),
      ],
    );
  }
}
