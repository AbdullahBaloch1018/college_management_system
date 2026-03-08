/*
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resources/components/custom_app_bar.dart';
import '../../resources/components/round_button.dart';
import '../../utils/routes/routes_name.dart';
import '../../utils/utils.dart';
import '../../viewModel/auth_view_model.dart';
import '../../viewModel/image_upload_provider.dart';
import '../../widgets/image_uploader.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 4),);
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _rollNumberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _rollNoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _nameFocus.dispose();
    _rollNumberFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _obscurePassword.dispose();
    _phoneFocus.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Read once — stream is managed inside StreamBuilder, no listen needed here
    final authViewModel = context.read<AuthViewModel>();

    return Scaffold(
      appBar: CustomAppBar(titleWidget: const Text('Sign Up')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              // Watermark
              Opacity(
                opacity: 0.15,
                child: Center(
                  child: Image.asset('assets/logo.png', width: 600),
                ),
              ),

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      const SizedBox(height: 20),

                      // Profile image picker
                      const ImageUploader(),
                      const SizedBox(height: 20),

                      // Name
                      _buildTextField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        label: 'Name',
                        icon: Icons.person,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter your name'
                            : null,
                        nextFocusNode: _rollNumberFocus,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 12),

                      // Roll Number
                      _buildTextField(
                        controller: _rollNoController,
                        focusNode: _rollNumberFocus,
                        label: 'Roll Number',
                        icon: Icons.numbers,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter your roll number'
                            : null,
                        nextFocusNode: _phoneFocus,
                      ),
                      const SizedBox(height: 12),

                      // ── Faculty Dropdown (live from Firestore) ────────────
                      // Shows full "ClassName – Section" e.g. "ICS – A"
                      // Stored as 'faculty' on student doc for attendance filtering
                      StreamBuilder<List<String>>(
                        stream: authViewModel.facultyOptionsStream,
                        builder: (context, snapshot) {
                          // Loading state
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              height: 56,
                              padding:const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                                border:
                                Border.all(color: Colors.grey.shade400),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.subject,
                                      color: Colors.grey),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Loading classes…',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  const Spacer(),
                                  const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                ],
                              ),
                            );
                          }

                          final faculties = snapshot.data ?? [];

                          // No classes created by Admin yet
                          if (faculties.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.orange),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.warning_amber,
                                      color: Colors.orange),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'No classes available yet. Please contact Admin.',
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          // Dropdown populated with live Firestore classes
                          return Consumer<AuthViewModel>(
                            builder: (context, provider, _) {
                              // If previously selected value no longer exists
                              // in the list, reset it to avoid dropdown error
                              final validValue = faculties.contains(provider.selectedFaculty) ? provider.selectedFaculty : null;

                              return DropdownButtonFormField<String>(
                                initialValue: validValue,
                                hint: const Text('Select Class & Section'),
                                onChanged: (String? newValue) {
                                  provider.setSelectedFaculty(newValue);
                                },
                                validator: (value) => value == null
                                    ? 'Please select your class'
                                    : null,
                                items: faculties.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value), // e.g. "ICS – A"
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.class_),
                                  labelText: 'Class & Section',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Phone Number
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
                        nextFocusNode: _emailFocus,
                      ),
                      const SizedBox(height: 12),

                      // Email
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
                        nextFocusNode: _passwordFocus,
                      ),
                      const SizedBox(height: 12),

                      // Password
                      ValueListenableBuilder(
                        valueListenable: _obscurePassword,
                        builder: (context, value, child) {
                          return _buildTextField(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            textInputAction: TextInputAction.done,
                            label: 'Password',
                            icon: Icons.lock_outline,
                            obscurePassword: _obscurePassword.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                _obscurePassword.value =
                                !_obscurePassword.value;
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

                      // Sign Up button
                      Consumer<AuthViewModel>(
                        builder: (context, authProvider, child) {
                          return RoundButton(
                            loading: authProvider.signupLoading,
                            onPress: () async {
                              if (!_formKey.currentState!.validate()) {
                                Utils.flushbarMessage(
                                  context,
                                  "Please fix the errors above",
                                  Colors.red,
                                  Colors.white,
                                );
                                return;
                              }

                              final imageProvider = Provider.of<ImageUploadProvider>(context,listen: false,);

                              if (imageProvider.imageFile == null) {
                                Utils.flushbarMessage(context,
                                  "Please select a profile picture",
                                  Colors.orange,
                                  Colors.white,
                                );
                                return;
                              }

                              bool success =await authProvider.registerWithFirebase(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                                _rollNoController.text.trim(),
                                authProvider.selectedFaculty!, // e.g. "ICS – A"
                                _nameController.text.trim(),
                                _phoneController.text.trim(),
                                imageProvider.imageFile,
                                context,
                                _confettiController,
                              );

                              if (success && mounted) {
                                _confettiController.play();
                                imageProvider.clearImage();
                                await Future.delayed(
                                  const Duration(milliseconds: 1800),
                                );
                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    RoutesName.navMenu,
                                        (route) => false,
                                  );
                                clearController();
                                }
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    AutovalidateMode autoValidate = AutovalidateMode.onUserInteraction,
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    required String label,
    required IconData icon,
    bool obscurePassword = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      child: TextFormField(
        focusNode: focusNode,
        textInputAction: textInputAction,
        onFieldSubmitted: (_) {
          if (nextFocusNode != null) {
            Utils.fieldFocusChange(context, focusNode, nextFocusNode);
          } else {
            FocusScope.of(focusNode.context!).unfocus();
          }
        },
        controller: controller,
        obscureText: obscurePassword,
        autovalidateMode: autoValidate,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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

  void clearController() {
    _emailController.clear();
    _nameController.clear();
    _phoneController.clear();
    _passwordController.clear();
    _rollNoController.clear();
  }
}*/
// for pending approval and user roll number
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resources/components/custom_app_bar.dart';
import '../../resources/components/round_button.dart';
import '../../utils/routes/routes_name.dart';
import '../../utils/utils.dart';
import '../../viewModel/auth_view_model.dart';
import '../../viewModel/image_upload_provider.dart';
import '../../widgets/image_uploader.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 4),
  );
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _obscurePassword.dispose();
    _phoneFocus.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();

    return Scaffold(
      appBar: CustomAppBar(titleWidget: const Text('Sign Up')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              // Watermark
              Opacity(
                opacity: 0.15,
                child: Center(
                  child: Image.asset('assets/logo.png', width: 600),
                ),
              ),

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      const SizedBox(height: 8),

                      // Info box - tells student about roll number
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue[700], size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Your Roll Number will be assigned by Admin after account approval.',
                                style: TextStyle(color: Colors.blue[700], fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Profile image picker
                      const ImageUploader(),
                      const SizedBox(height: 20),

                      // Name
                      _buildTextField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        label: 'Name',
                        icon: Icons.person,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter your name'
                            : null,
                        nextFocusNode: _phoneFocus,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 12),

                      // Faculty Dropdown - live from Firestore
                      StreamBuilder<List<String>>(
                        stream: authViewModel.facultyOptionsStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              height: 56,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.class_, color: Colors.grey),
                                  const SizedBox(width: 12),
                                  Text('Loading classes...', style: TextStyle(color: Colors.grey[600])),
                                  const Spacer(),
                                  const SizedBox(
                                    width: 16, height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ],
                              ),
                            );
                          }

                          final faculties = snapshot.data ?? [];

                          if (faculties.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.orange),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.warning_amber, color: Colors.orange),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'No classes available. Contact Admin.',
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return Consumer<AuthViewModel>(
                            builder: (context, provider, _) {
                              final validValue = faculties.contains(provider.selectedFaculty)
                                  ? provider.selectedFaculty
                                  : null;

                              return DropdownButtonFormField<String>(
                                value: validValue,
                                hint: const Text('Select Class & Section'),
                                onChanged: (value) => provider.setSelectedFaculty(value),
                                validator: (value) =>
                                value == null ? 'Please select your class' : null,
                                items: faculties.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.class_),
                                  labelText: 'Class & Section',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Phone Number
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
                        nextFocusNode: _emailFocus,
                      ),
                      const SizedBox(height: 12),

                      // Email
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
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        nextFocusNode: _passwordFocus,
                      ),
                      const SizedBox(height: 12),

                      // Password
                      ValueListenableBuilder(
                        valueListenable: _obscurePassword,
                        builder: (context, value, child) {
                          return _buildTextField(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            textInputAction: TextInputAction.done,
                            label: 'Password',
                            icon: Icons.lock_outline,
                            obscurePassword: _obscurePassword.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () =>
                              _obscurePassword.value = !_obscurePassword.value,
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

                      // Sign Up button
                      Consumer<AuthViewModel>(
                        builder: (context, authProvider, child) {
                          return RoundButton(
                            loading: authProvider.signupLoading,
                            onPress: () async {
                              if (!_formKey.currentState!.validate()) {
                                Utils.flushbarMessage(
                                  context,
                                  "Please fix the errors above",
                                  Colors.red,
                                  Colors.white,
                                );
                                return;
                              }

                              final imageProvider = Provider.of<ImageUploadProvider>(
                                  context, listen: false);

                              if (imageProvider.imageFile == null) {
                                Utils.flushbarMessage(
                                  context,
                                  "Please select a profile picture",
                                  Colors.orange,
                                  Colors.white,
                                );
                                return;
                              }

                              bool success = await authProvider.registerWithFirebase(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                                authProvider.selectedFaculty!,
                                _nameController.text.trim(),
                                _phoneController.text.trim(),
                                imageProvider.imageFile,
                                context,
                                _confettiController,
                              );

                              if (success && mounted) {
                                _confettiController.play();
                                imageProvider.clearImage();
                                await Future.delayed(const Duration(milliseconds: 1800));
                                if (context.mounted) {
                                  // Route to pending approval screen, not navMenu
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    RoutesName.pendingApprovalView,
                                        (route) => false,
                                  );
                                }
                                clearController();
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    AutovalidateMode autoValidate = AutovalidateMode.onUserInteraction,
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    required String label,
    required IconData icon,
    bool obscurePassword = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      child: TextFormField(
        focusNode: focusNode,
        textInputAction: textInputAction,
        onFieldSubmitted: (_) {
          if (nextFocusNode != null) {
            Utils.fieldFocusChange(context, focusNode, nextFocusNode);
          } else {
            FocusScope.of(focusNode.context!).unfocus();
          }
        },
        controller: controller,
        obscureText: obscurePassword,
        autovalidateMode: autoValidate,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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

  void clearController() {
    _emailController.clear();
    _nameController.clear();
    _phoneController.clear();
    _passwordController.clear();
  }
}
