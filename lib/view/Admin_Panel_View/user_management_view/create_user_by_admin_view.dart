/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/resources/components/custom_app_bar.dart';
import 'package:rise_college/viewModel/AdminViewModel/user_management_view_model/create_user_by_admin_view_model.dart';
import '../../../resources/components/round_button.dart';
import '../../../utils/utils.dart';

class CreateUserByAdminView extends StatefulWidget {
  const CreateUserByAdminView({super.key});

  @override
  State<CreateUserByAdminView> createState() => _CreateUserByAdminViewState();
}

class _CreateUserByAdminViewState extends State<CreateUserByAdminView> {
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _rollNumberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();

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
    _obscurePassword.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleWidget: Text("Create New User")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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

                  // Name input
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
                    nextFocusNode: _emailFocus,
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
                    nextFocusNode: _passwordFocus,
                  ),

                  const SizedBox(height: 12),
                  // Password input
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
                  const SizedBox(height: 12),
                  // Faculty input
                  Consumer<CreateUserByAdminViewModel>(
                    builder: (context, provider, child) {
                      return DropdownButtonFormField<String>(
                        initialValue: provider.selectedFaculty,
                        hint: const Text('Select Faculty'),
                        onChanged: (String? newValue) {
                          provider.setSelectedFaculty(newValue);
                        },
                        validator: (value) =>
                            value == null ? 'Please select a Faculty' : null,
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
                  SizedBox(height: 12),
                  Consumer<CreateUserByAdminViewModel>(
                    builder: (context, provider, child) {
                      return DropdownButtonFormField<String>(
                        initialValue: provider.userRole,
                        hint: const Text('Select Role'),
                        validator: (value) =>
                            value == null ? 'Please select a User Role' : null,
                        items: provider.userRoleOptions.map((e) {
                          return DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          labelText: 'User Role',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (String? newValue) {
                          provider.setUserRole(newValue);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Account Creation Button Button
                  Consumer<CreateUserByAdminViewModel>(
                    builder: (context, provider, child) {
                      return RoundButton(
                        loading: provider.loading,
                        onPress: () async {
                          try {
                            if (_formKey.currentState!.validate()) {
                              bool success = await provider.createUser(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                phone: _phoneController.text,
                                role: provider.userRole!,
                                faculty: provider.selectedFaculty!,
                                context: context,
                              );

                              if (success && context.mounted) {
                                clearController();
                                provider.resetForm();
                                FocusScope.of(context).unfocus();
                                _formKey.currentState!.reset();
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              Utils.snackBar(
                                "Error in the View File of Account Creation",
                                context,
                              );
                            }
                          }
                        },
                        title: 'Create Account',
                      );
                    },
                  ),
                ],
              ),
            ),
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
  }
}
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/resources/components/custom_app_bar.dart';
import 'package:rise_college/viewModel/AdminViewModel/user_management_view_model/create_user_by_admin_view_model.dart';
import '../../../resources/components/round_button.dart';
import '../../../utils/utils.dart';

class CreateUserByAdminView extends StatefulWidget {
  const CreateUserByAdminView({super.key});

  @override
  State<CreateUserByAdminView> createState() => _CreateUserByAdminViewState();
}

class _CreateUserByAdminViewState extends State<CreateUserByAdminView> {
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleWidget: const Text("Create New User")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    "Create New User",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text("Fill in the details below"),
                  const SizedBox(height: 20),

                  // ── Name ──────────────────────────────────────────────────
                  _buildTextField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    label: 'Name',
                    icon: Icons.person,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter name'
                        : null,
                    nextFocusNode: _phoneFocus,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 12),

                  // ── Phone ─────────────────────────────────────────────────
                  _buildTextField(
                    controller: _phoneController,
                    focusNode: _phoneFocus,
                    label: 'Phone Number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      if (!RegExp(r'^\+?\d{10,15}$').hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                    nextFocusNode: _emailFocus,
                  ),
                  const SizedBox(height: 12),

                  // ── Email ─────────────────────────────────────────────────
                  _buildTextField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    nextFocusNode: _passwordFocus,
                  ),
                  const SizedBox(height: 12),

                  // ── Password ──────────────────────────────────────────────
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
                  const SizedBox(height: 12),

                  // ── Role Dropdown ─────────────────────────────────────────
                  Consumer<CreateUserByAdminViewModel>(
                    builder: (context, provider, child) {
                      return DropdownButtonFormField<String>(
                        initialValue: provider.userRole,
                        hint: const Text('Select Role'),
                        validator: (value) =>
                        value == null ? 'Please select a user role' : null,
                        items: provider.userRoleOptions.map((e) {
                          return DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          labelText: 'User Role',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (value) => provider.setUserRole(value),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // ── Faculty Dropdown (Students only, live from Firestore) ──
                  // Hidden when role is Teacher — teachers don't belong to a section
                  Consumer<CreateUserByAdminViewModel>(
                    builder: (context, provider, _) {
                      // Hide faculty field entirely for Teacher role
                      if (provider.userRole == 'Teacher') {
                        return const SizedBox.shrink();
                      }

                      return StreamBuilder<List<String>>(
                        stream: provider.facultyOptionsStream,
                        builder: (context, snapshot) {
                          // Loading state
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return _buildFacultyLoadingSkeleton();
                          }

                          final faculties = snapshot.data ?? [];

                          // No classes yet
                          if (faculties.isEmpty) {
                            return _buildNoClassesWarning();
                          }

                          // Ensure selected value still exists in list
                          final validValue =
                          faculties.contains(provider.selectedFaculty)
                              ? provider.selectedFaculty
                              : null;

                          return DropdownButtonFormField<String>(
                            initialValue: validValue,
                            hint: const Text('Select Class & Section'),
                            onChanged: (value) =>
                                provider.setSelectedFaculty(value),
                            validator: (value) => value == null
                                ? 'Please select a class'
                                : null,
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
                  const SizedBox(height: 20),

                  // ── Submit Button ─────────────────────────────────────────
                  Consumer<CreateUserByAdminViewModel>(
                    builder: (context, provider, child) {
                      return RoundButton(
                        loading: provider.loading,
                        onPress: () async {
                          try {
                            if (_formKey.currentState!.validate()) {
                              bool success = await provider.createUser(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                phone: _phoneController.text,
                                role: provider.userRole!,
                                // Teachers get empty faculty, Students get selected class
                                faculty: provider.userRole == 'Teacher'
                                    ? null
                                    : provider.selectedFaculty,
                                context: context,
                              );

                              if (success && context.mounted) {
                                clearController();
                                provider.resetForm();
                                FocusScope.of(context).unfocus();
                                _formKey.currentState!.reset();
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              Utils.snackBar(
                                "Error creating account: $e",
                                context,
                              );
                            }
                          }
                        },
                        title: 'Create Account',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Helper widgets ────────────────────────────────────────────────────────

  Widget _buildFacultyLoadingSkeleton() {
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
          Text('Loading classes…',
              style: TextStyle(color: Colors.grey[600])),
          const Spacer(),
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      ),
    );
  }

  Widget _buildNoClassesWarning() {
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
              'No classes available yet. Create a class first.',
              style: TextStyle(color: Colors.orange),
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
  }
}
