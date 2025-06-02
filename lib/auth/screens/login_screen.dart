import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mobile/auth/bloc/auth_bloc.dart';
import 'package:mobile/auth/bloc/auth_event.dart';
import 'package:mobile/auth/repositories/auth_repository.dart';
import 'package:mobile/auth/screens/account_type_selection_screen.dart';
import 'package:mobile/core/theme/paint_app_colors.dart';
import 'package:mobile/core/widgets/paint_app_text_field.dart';
import 'package:mobile/core/widgets/paint_app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  final AuthRepository authRepository = AuthRepository();

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _paintController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _paintAnimation;

  // Form controllers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // State
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Fade animation for the overall screen
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Slide animation for form elements
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Paint animation for decorative elements
    _paintController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _paintAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _paintController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _paintController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _paintController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final formData = _formKey.currentState?.value;
        if (formData != null) {
          final loginResponse = await authRepository.login(
            formData['username_or_email'],
            formData['password'],
          );

          if (loginResponse != null && mounted) {
            final token = loginResponse['access_token'];
            final user = loginResponse['user'];
            final username = user['username'] ?? formData['username_or_email'];

            context.read<AuthBloc>().add(
              LoggedIn(token: token, username: username),
            );
          } else if (mounted) {
            setState(() {
              _errorMessage =
                  'Invalid credentials. Please check your username and password.';
            });
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Login failed. Please try again.';
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(gradient: PaintAppColors.warmGradient),
        child: Stack(
          children: [
            // Animated Paint Brushes Background
            _buildAnimatedBackground(),

            // Main Content
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.08),

                        // App Logo and Branding
                        _buildAppBranding(),

                        SizedBox(height: screenHeight * 0.06),

                        // Login Form Card
                        _buildLoginFormCard(),

                        const SizedBox(height: 32),

                        // Register Link
                        _buildRegisterLink(),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _paintAnimation,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: PaintBrushBackgroundPainter(_paintAnimation.value),
          ),
        );
      },
    );
  }

  Widget _buildAppBranding() {
    return Column(
      children: [
        // App Icon/Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: PaintAppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: PaintAppColors.shadowPrimary,
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.palette,
            size: 40,
            color: PaintAppColors.textInverse,
          ),
        ),

        const SizedBox(height: 24),

        // App Name
        Text(
          'Color Swap',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: PaintAppColors.textPrimary,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 8),

        // App Tagline
        Text(
          'Visualize your perfect paint colors',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: PaintAppColors.textSecondary,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginFormCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: PaintAppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: PaintAppColors.shadowMedium,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text
              Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: PaintAppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Sign in to continue your paint journey',
                style: TextStyle(
                  fontSize: 16,
                  color: PaintAppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 32),

              // Error Message
              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: PaintAppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: PaintAppColors.error.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: PaintAppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: PaintAppColors.error,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Username/Email Field
              FormBuilderField<String>(
                name: 'username_or_email',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                builder:
                    (field) => PaintAppTextField(
                      label: 'Username or Email',
                      hint: 'Enter your username or email',
                      controller: _usernameController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: PaintAppColors.textSecondary,
                        size: 20,
                      ),
                      onChanged: (value) => field.didChange(value),
                      errorText: field.errorText,
                    ),
              ),

              const SizedBox(height: 24),

              // Password Field
              FormBuilderField<String>(
                name: 'password',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(8),
                ]),
                builder:
                    (field) => PaintAppTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: PaintAppColors.textSecondary,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: PaintAppColors.textSecondary,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      onChanged: (value) => field.didChange(value),
                      onSubmitted: (_) => _handleLogin(),
                      errorText: field.errorText,
                    ),
              ),

              const SizedBox(height: 32),

              // Login Button
              PaintAppButton(
                text: 'Sign In',
                onPressed: _isLoading ? null : _handleLogin,
                variant: PaintAppButtonVariant.primary,
                size: PaintAppButtonSize.large,
                isFullWidth: true,
                isLoading: _isLoading,
                icon:
                    _isLoading
                        ? null
                        : const Icon(
                          Icons.login,
                          size: 20,
                          color: PaintAppColors.textInverse,
                        ),
              ),

              const SizedBox(height: 24),

              // Forgot Password Link
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement forgot password
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Forgot password feature coming soon!'),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: PaintAppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    'Forgot your password?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: PaintAppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: PaintAppColors.backgroundAccent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PaintAppColors.borderLight, width: 1),
      ),
      child: Column(
        children: [
          Text(
            'New to Color Swap?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: PaintAppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 12),

          PaintAppButton(
            text: 'Create Account',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountTypeSelectionScreen(),
                ),
              );
            },
            variant: PaintAppButtonVariant.outline,
            size: PaintAppButtonSize.medium,
            icon: const Icon(
              Icons.person_add_outlined,
              size: 18,
              color: PaintAppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for animated paint brush background
class PaintBrushBackgroundPainter extends CustomPainter {
  final double animationValue;

  PaintBrushBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Paint brush strokes with animation
    final brushStrokes = [
      {
        'color': PaintAppColors.paintTeal.withValues(alpha: 0.1),
        'path': _createBrushStroke(size, 0.1, 0.2, animationValue),
      },
      {
        'color': PaintAppColors.paintPurple.withValues(alpha: 0.08),
        'path': _createBrushStroke(size, 0.7, 0.6, animationValue * 0.8),
      },
      {
        'color': PaintAppColors.paintYellow.withValues(alpha: 0.05),
        'path': _createBrushStroke(size, 0.3, 0.8, animationValue * 1.2),
      },
    ];

    for (final stroke in brushStrokes) {
      paint.color = stroke['color'] as Color;
      canvas.drawPath(stroke['path'] as Path, paint);
    }
  }

  Path _createBrushStroke(
    Size size,
    double startX,
    double startY,
    double animation,
  ) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    final animatedOffset = animation * 50;

    path.moveTo(width * startX - animatedOffset, height * startY);
    path.quadraticBezierTo(
      width * (startX + 0.2) + animatedOffset,
      height * (startY - 0.1),
      width * (startX + 0.3) - animatedOffset,
      height * (startY + 0.1),
    );
    path.quadraticBezierTo(
      width * (startX + 0.5) + animatedOffset,
      height * (startY + 0.2),
      width * (startX + 0.6) - animatedOffset,
      height * (startY + 0.05),
    );

    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
