import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/equestrian_logo_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _showBiometric = false;
  String? _errorMessage;

  // Mock credentials for testing
  final Map<String, String> _mockCredentials = {
    'rider@equestrianmind.com': 'rider123',
    'coach@equestrianmind.com': 'coach456',
    'admin@equestrianmind.com': 'admin789',
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate authentication delay
    await Future.delayed(Duration(seconds: 2));

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Check mock credentials
    if (_mockCredentials.containsKey(email) &&
        _mockCredentials[email] == password) {
      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      // Show biometric option for future logins
      setState(() {
        _showBiometric = true;
        _isLoading = false;
      });

      // Navigate to dashboard using correct route
      Navigator.pushReplacementNamed(context, AppRoutes.dashboardHome);
    } else {
      // Authentication failed
      setState(() {
        _isLoading = false;
        _errorMessage = _getErrorMessage(email, password);
      });

      // Show error feedback
      HapticFeedback.heavyImpact();
      _showErrorSnackBar(_errorMessage!);
    }
  }

  String _getErrorMessage(String email, String password) {
    if (!_mockCredentials.containsKey(email)) {
      return 'No rider account found with this email. Please check your credentials or sign up.';
    } else {
      return 'Incorrect password. Please try again or reset your password.';
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Reset Password',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Password reset functionality will be available soon. For now, please use the provided demo credentials.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleSocialLogin(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider login will be available soon'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _handleBiometricSuccess() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, AppRoutes.dashboardHome);
  }

  void _navigateToSignUp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sign up functionality will be available soon'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo Section
                  EquestrianLogoWidget(),

                  SizedBox(height: 2.h),

                  // Welcome Text
                  Text(
                    'Welcome Back, Rider',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 1.h),

                  Text(
                    'Sign in to continue your equestrian journey',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 4.h),

                  // Login Form
                  LoginFormWidget(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    formKey: _formKey,
                    onLogin: _handleLogin,
                    onForgotPassword: _handleForgotPassword,
                    isLoading: _isLoading,
                  ),

                  // Biometric Authentication
                  BiometricAuthWidget(
                    isEnabled: _showBiometric,
                    onBiometricSuccess: _handleBiometricSuccess,
                  ),

                  // Social Login Options
                  SocialLoginWidget(
                    onGoogleLogin: () => _handleSocialLogin('Google'),
                    onAppleLogin: () => _handleSocialLogin('Apple'),
                  ),

                  SizedBox(height: 4.h),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New rider? ',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      GestureDetector(
                        onTap: _navigateToSignUp,
                        child: Text(
                          'Sign Up',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Demo Credentials Info
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: AppTheme.lightTheme.dividerColor,
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Demo Credentials:',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        ..._mockCredentials.entries
                            .map((entry) => Padding(
                                  padding: EdgeInsets.only(bottom: 0.5.h),
                                  child: Text(
                                    '${entry.key} / ${entry.value}',
                                    style: AppTheme.dataTextStyle(
                                      isLight: true,
                                      fontSize: 12,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
