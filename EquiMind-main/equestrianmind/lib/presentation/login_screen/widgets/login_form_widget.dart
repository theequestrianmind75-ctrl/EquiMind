import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final VoidCallback? onLogin;
  final VoidCallback? onForgotPassword;
  final bool isLoading;

  const LoginFormWidget({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    this.onLogin,
    this.onForgotPassword,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  bool _isPasswordVisible = false;
  String? _emailError;
  String? _passwordError;

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = 'Please enter your email to continue your ride';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        _emailError = 'Please enter a valid email address';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = 'Password is required to access your coaching';
      } else if (value.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
      } else {
        _passwordError = null;
      }
    });
  }

  bool get _isFormValid {
    return _emailError == null &&
        _passwordError == null &&
        widget.emailController.text.isNotEmpty &&
        widget.passwordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email Field
          Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: widget.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !widget.isLoading,
                  onChanged: _validateEmail,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'person_outline',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                    ),
                    errorText: null,
                  ),
                ),
                if (_emailError != null) ...[
                  SizedBox(height: 1.h),
                  Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Text(
                      _emailError!,
                      style: AppTheme.errorTextStyle(
                        isLight: true,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Password Field
          Container(
            margin: EdgeInsets.only(bottom: 1.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: widget.passwordController,
                  obscureText: !_isPasswordVisible,
                  textInputAction: TextInputAction.done,
                  enabled: !widget.isLoading,
                  onChanged: _validatePassword,
                  onFieldSubmitted: (_) {
                    if (_isFormValid && !widget.isLoading) {
                      widget.onLogin?.call();
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'lock_outline',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: _isPasswordVisible
                              ? 'visibility_off'
                              : 'visibility',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                      ),
                    ),
                    errorText: null,
                  ),
                ),
                if (_passwordError != null) ...[
                  SizedBox(height: 1.h),
                  Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Text(
                      _passwordError!,
                      style: AppTheme.errorTextStyle(
                        isLight: true,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.isLoading ? null : widget.onForgotPassword,
              child: Text(
                'Forgot Password?',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Login Button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed:
                  (_isFormValid && !widget.isLoading) ? widget.onLogin : null,
              child: widget.isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 5.w,
                          height: 5.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Signing In...',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Login',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
