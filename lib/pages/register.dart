import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herogamescase/components/my_button.dart';
import 'package:herogamescase/components/my_text_field.dart';
import 'package:herogamescase/services/auth/auth_services.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final  birthDateController="";
   final biographyController = "";

  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match.'),
        ),
      );
      return;
    }

    try {
      await Provider.of<AuthService>(context, listen: false).signUpWithEmailAndPassword(
        emailController.text,
        passwordController.text,
        nameController.text,
        surnameController.text,
        phoneNumberController.text,

      );

      print('User registered successfully');

    } catch (e) {
      print('Error during registration: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.message, size: 80),
                  const SizedBox(height: 50),
                  const Text(
                    "Create an account for HeroGames",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 50),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: nameController,
                    hintText: 'Name',
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: surnameController,
                    hintText: 'Surname',
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: phoneNumberController,
                    hintText: 'Phone Number',
                    obscureText: false,
                  ),
                  const SizedBox(height: 25),
                  MyButton(onTap: signUp, text: "Sign Up"),
                  const SizedBox(height: 25),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    const Text('Already a member'),
    const SizedBox(width: 4),
    GestureDetector(
    onTap: widget.onTap,
    child: Text(
    'Login',
    style: TextStyle(
    fontWeight: FontWeight.bold,),),
    ),
    ],),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
