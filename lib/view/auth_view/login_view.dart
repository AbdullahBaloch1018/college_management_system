import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../resources/components/round_button.dart';
import '../../utils/routes/routes_name.dart';
import '../../utils/utils.dart';
import '../../viewModel/auth_view_model.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _obscurePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Login Whole Screen Rebuilding");
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Watermark logo in the background
            Opacity(
              opacity: 0.15,
              child: Center(
                  child: Image.asset('assets/logo.png', width: 600),
              ),
            ),
            // Main login form
            Center(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo at the top
                      Image.asset('assets/logo.png', width: 200),
                      const SizedBox(height: 30),
                      // Email FormField
                      TextFormField(
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          }
                          if (!value.contains("@") || !value.contains(".")) {
                            return "Please enter a valid email (e.g., user@domain.com)";
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          Utils.fieldFocusChange(
                            context,
                            _emailFocus,
                            _passwordFocus,
                          );
                        },
                        decoration: InputDecoration(
                          hintText: "Enter Email",
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.alternate_email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Password FormField
                      /*ValueListenableBuilder(
                        valueListenable: _obscurePassword,
                        builder: (context, value, child) {
                          return TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            obscureText: _obscurePassword.value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: "Enter Password",
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  _obscurePassword.value =
                                      !_obscurePassword.value;
                                },
                                child: Icon(
                                  _obscurePassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          );
                        },
                      )*/
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,

                        obscureText: _obscurePassword.value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                        autovalidateMode:
                        AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: "Enter Password",
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              _obscurePassword.value =
                              !_obscurePassword.value;
                            },
                            child: Icon(
                              _obscurePassword.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Login button
                      Consumer<AuthViewModel>(
                        builder: (context, authProvider, child) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,

                            child: RoundButton(
                              // loading: authProvider.loginLoading,
                              onPress: () async{
                                  Navigator.pushNamedAndRemoveUntil(context, RoutesName.navMenu, (route) => false,);
                              },
                              title: 'Login',
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Sign up link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, RoutesName.signup);
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
