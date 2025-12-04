import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';

import '../../resources/components/round_button.dart';
import '../../utils/utils.dart';
import '../../viewModel/auth_view_model.dart';
import '../../widgets/image_uploader.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 4),
  );
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _rollNumberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _rollNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _nameFocus.dispose();
    _rollNumberFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _phoneFocus.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("SignUp Whole Screen Rebuilding");
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Center(
        child: Text("Sign Up"),
      ),
      ),
      body: Stack(
        children: [
          // Watermark in the background
          Opacity(
            opacity: 0.15,
            child: Center(child: Image.asset('assets/logo.png', width: 600)),
          ),
          // Main content with confetti to display the confetti effect
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -1.0,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            maxBlastForce: 50,
            minBlastForce: 20,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.blue, Colors.green, Colors.pink],
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Column for the Text Widget which Is showing
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Create Your Account",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Please enter your info"),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Image Widget here
                    ImageUploader(),

                    const SizedBox(height: 30),

                    // Name input
                    _buildTextField(
                      controller: _nameController,
                      focusNode: _nameFocus,
                      label: 'Name',
                      icon: Icons.person,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your name'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    // Roll Number input
                    _buildTextField(
                      controller: _rollNumberController,
                      focusNode: _rollNumberFocus,
                      label: 'Roll Number',
                      icon: Icons.numbers,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your roll number'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    // Faculty input
                    Consumer<AuthViewModel>(
                      builder: (context, provider, child) {
                        return DropdownButtonFormField<String>(
                          value: provider.selectedFaculty,
                          hint: const Text('Select Faculty'),
                          onChanged: (String? newValue) {
                            provider.setSelectedFaculty(newValue);
                          },
                          validator: (value) =>
                              value == null ? 'Please select a faculty' : null,
                          items: provider.facultyOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.subject),
                            labelText: 'Faculty',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    // Phone Number input
                    _buildTextField(
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      label: 'Phone Number',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (!RegExp(r'^\+?\d{10,15}$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    // Email input
                    _buildTextField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    // Password input
                    ValueListenableBuilder(
                      valueListenable: _obscurePassword,
                      builder: (context, value, child) {
                        return _buildTextField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          label: 'Password',
                          icon: Icons.key,
                          obscurePassword: _obscurePassword.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              _obscurePassword.value = !_obscurePassword.value;
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    Consumer<AuthViewModel>(
                      builder: (context, authProvider, child) {
                        return RoundButton(
                          loading: authProvider.signupLoading,
                          onPress: () {
                            if (_formKey.currentState!.validate() && authProvider.selectedFaculty != null) {
                              authProvider.registerWithFirebase(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                                _rollNumberController.text.trim(),
                                authProvider.selectedFaculty!,
                                _nameController.text.trim(),
                                _phoneController.text.trim(),
                                context,
                                _confettiController,
                              );
                            } else {
                              Utils.flushbarMessage(
                                context,
                                "Please fill all fields and select a faculty",
                                Colors.red,
                                Colors.black,
                              );
                            }
                          },
                          title: 'Sign Up',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    AutovalidateMode autoValidate = AutovalidateMode.onUserInteraction,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    bool obscurePassword = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        obscureText: obscurePassword,
        autovalidateMode: autoValidate,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: suffixIcon,
        ),
        validator: validator,
      ),
    );
  }
}
