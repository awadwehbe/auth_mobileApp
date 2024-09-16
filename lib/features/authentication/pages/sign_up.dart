import 'package:auth_app/features/authentication/pages/login.dart';
import 'package:auth_app/features/authentication/state_management/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/routes/routes.dart';
import '../repositories/sign_up_repository.dart';
import '../state_management/sign_up_cubit.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool rememberMe = false;
  bool _isObscured = true;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //1-wrap the scaffold with blocProvider.
    return BlocProvider(
      //2-add this line
      create: (_) => SignUpCubit(SignUpRepository()), // Provide your repository
  child: Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/pw.webp', // Path to your image asset
              fit: BoxFit.cover, // Adjusts the image to cover the entire screen
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double widthFactor = constraints.maxWidth > 600 ? 0.4 : 0.9; // Adjust the widthFactor for responsiveness
                double contentWidth = MediaQuery.of(context).size.width * widthFactor;

                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 30),
                          _buildHeader(),
                          SizedBox(height: 30),
                          _buildFields(context, contentWidth), // Using contentWidth
                          SizedBox(height: 10),
                          _buildRememberMeAndForgotPassword(context, contentWidth),
                          SizedBox(height: 20),
                          _buildSignUpButton(contentWidth),
                          SizedBox(height: 20),
                          _buildLoginLink(contentWidth),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
);
  }

  // Build header function
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(''),
        Icon(Icons.menu, color: Colors.purple, size: 40),
      ],
    );
  }

  // Build fields function with consistent width
  Widget _buildFields(BuildContext context, double contentWidth) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create an account',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 20),
          _buildTextField(_firstNameController, 'First Name', Icons.person, contentWidth),
          SizedBox(height: 20),
          _buildTextField(_lastNameController, 'Last Name', Icons.person, contentWidth),
          SizedBox(height: 20),
          _buildTextField(_emailController, 'Email', Icons.mail, contentWidth),
          SizedBox(height: 20),
          _buildPasswordField(_passwordController, 'Password', contentWidth),
          SizedBox(height: 20),
          _buildPasswordField(_confirmPasswordController, 'Confirm Password', contentWidth),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, IconData icon, double contentWidth) {
    return Container(
      width: contentWidth,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          prefixIcon: Icon(icon),
          prefixIconColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hintText, double contentWidth) {
    return Container(
      width: contentWidth,
      child: TextField(
        controller: controller,
        obscureText: _isObscured,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          prefixIcon: Icon(Icons.lock),
          prefixIconColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white),
          suffixIcon: IconButton(
            icon: Icon(
              _isObscured ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isObscured = !_isObscured;
              });
            },
          ),
        ),
      ),
    );
  }

  // Updated remember me and forgot password row
  Widget _buildRememberMeAndForgotPassword(BuildContext context, double contentWidth) {
    return Container(
      width: contentWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: rememberMe,
                onChanged: (value) {
                  setState(() {
                    rememberMe = value!;
                  });
                },
                activeColor: Colors.white,
              ),
              Text(
                'Remember me',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              // Handle forgot password logic here
            },
            child: Text(
              'Forgot password?',
              style: TextStyle(color: Colors.purple, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpButton(double contentWidth) {
    return Container(
      width: contentWidth,
      child: SizedBox(
        width: double.infinity,
        //3-wrap the ElevatedButton with Bloc Consumer.
        child: BlocConsumer<SignUpCubit, SignUpState>(
  listener: (context, state) {
    //4-inside listenner i  should listen for state of the cubit.
    if(state is SignUpSuccess){
      // Navigate to OTP page and pass the email as argument
      Navigator.pushNamed(context,
        AppRoutes.otp,
        arguments: _emailController.text,);// Pass the email to OTPView)
    }
    else if(state is SignUpError){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage),
            backgroundColor: Colors.red,));
    }
  },
  builder: (context, state) {
    return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            // Check if all fields are filled correctly
            if (_firstNameController.text.isEmpty ||
                _lastNameController.text.isEmpty ||
                _emailController.text.isEmpty ||
                _passwordController.text.isEmpty ||
                _confirmPasswordController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please fill all fields'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            // Validate passwords match
            if (_passwordController.text != _confirmPasswordController.text) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Passwords do not match'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            // Trigger the sign-up event
            context.read<SignUpCubit>().signUp(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              email: _emailController.text,
              password: _passwordController.text,
            );

            // Add sign-up logic here
          },
      child: state is SignUpLoading
          ? CircularProgressIndicator(color: Colors.purple)
          : Text('SIGN UP', style: TextStyle(fontSize: 18, color: Colors.purple)),
    );
  },
),
      ),
    );
  }

  Widget _buildLoginLink(double contentWidth) {
    return Container(
      width: contentWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Already have an account?'),
          TextButton(
            onPressed: () {
              // Navigate to login page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text(
              'Login',
              style: TextStyle(color: Colors.purple),
            ),
          ),
        ],
      ),
    );
  }
}
