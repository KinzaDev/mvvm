import 'package:flutter/material.dart';
import 'package:mvvm/res/color.dart';
import 'package:mvvm/res/components/round_button.dart';
import 'package:mvvm/utils/routes/routes_name.dart';
import 'package:mvvm/utils/utils.dart';
import 'package:mvvm/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final ValueNotifier<bool> _togglePasswordVisibility = ValueNotifier<bool>(
    true,
  );

  final TextEditingController _emailController =
      TextEditingController(text: 'eve.holt@reqres.in');
  final TextEditingController _passwordController =
      TextEditingController(text: 'pistol');

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _togglePasswordVisibility.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.whiteColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                focusNode: _emailFocusNode,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                  prefixIcon: Icon(
                    Icons.alternate_email,
                    color: AppColors.primaryBlue,
                  ),
                ),
                onFieldSubmitted: (value) {
                  Utils.fieldFocusChange(
                    context,
                    _emailFocusNode,
                    _passwordFocusNode,
                  );
                },
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder(
                valueListenable: _togglePasswordVisibility,
                builder: (context, value, child) {
                  return TextFormField(
                    controller: _passwordController,
                    obscureText: _togglePasswordVisibility.value,
                    obscuringCharacter: "*",
                    focusNode: _passwordFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.primaryBlue,
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          _togglePasswordVisibility.value =
                              !_togglePasswordVisibility.value;
                        },
                        child: Icon(
                          _togglePasswordVisibility.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: height * 0.085),
              RoundButton(
                title: 'Sign Up',
                loading: authViewModel.signUpLoading,
                onPress: () {
                  if (_emailController.text.trim().isEmpty) {
                    Utils.flushBarErrorMessage('Please enter email', context);
                  } else if (!_emailController.text.contains('@')) {
                    Utils.flushBarErrorMessage(
                      'Please enter a valid email',
                      context,
                    );
                  } else if (_passwordController.text.isEmpty) {
                    Utils.flushBarErrorMessage(
                      'Please enter password',
                      context,
                    );
                  } else if (_passwordController.text.length < 6) {
                    Utils.flushBarErrorMessage(
                      'Please enter 6 digit password',
                      context,
                    );
                  } else {
                    Map<String, String> data = {
                      'email': _emailController.text.trim(),
                      'password': _passwordController.text.trim(),
                    };
                    authViewModel.signUpApi(data, context);
                  }
                },
              ),
              SizedBox(height: height * 0.02),
              InkWell(
                onTap: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacementNamed(context, RoutesName.login);
                  }
                },
                child: RichText(
                  text: const TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(color: AppColors.blackColor, fontSize: 14),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
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
}
