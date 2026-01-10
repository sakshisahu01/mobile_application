import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class NoScrollbarBehavior extends MaterialScrollBehavior {
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Disable default scrollbars on web/desktop
    return child;
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  bool _loading = false;

  late final AnimationController _animController;
  late final Animation<double> _logoScaleAnim;
  late final Animation<Offset> _formSlideAnim;
  late final Animation<double> _fadeAnim;

  // Focus nodes for styled inputs
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  bool _buttonPressed = false;
  bool _isHoveringWelcome = false;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoScaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.45, curve: Curves.elasticOut),
      ),
    );

    _formSlideAnim =
        Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.45, 1.0, curve: Curves.decelerate),
          ),
        );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.45, 1.0, curve: Curves.easeIn),
    );

    _animController.forward();

    // Update UI when inputs gain/lose focus for subtle effects
    _emailFocus.addListener(() => setState(() {}));
    _passFocus.addListener(() => setState(() {}));
  }

  void _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    // Simulate authentication delay
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);

    // On success, navigate to dashboard
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushReplacementNamed(AppRoutes.userDashboard);
  }

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: Stack(
        children: [
          // No background header - color only applied to logo
          SizedBox.shrink(),

          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final height = constraints.maxHeight;
                      return ScrollConfiguration(
                        behavior: NoScrollbarBehavior(),
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: height),
                            child: IntrinsicHeight(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: height * 0.03),
                        // Animated logo (simple white circle)
                        ScaleTransition(
                          scale: _logoScaleAnim,
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: CustomIconWidget(
                              iconName: 'flash_on',
                              color: theme.colorScheme.primary,
                              size: 44,
                            ),
                          ),
                        ),

                        SizedBox(height: 2.h),

                        // Welcome text with hover effect
                        FadeTransition(
                          opacity: _fadeAnim,
                          child: Column(
                            children: [
                              MouseRegion(
                                onEnter: (_) =>
                                    setState(() => _isHoveringWelcome = true),
                                onExit: (_) =>
                                    setState(() => _isHoveringWelcome = false),
                                child: AnimatedScale(
                                  scale: _isHoveringWelcome ? 1.02 : 1.0,
                                  duration: const Duration(milliseconds: 160),
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 160),
                                    style:
                                        (theme.textTheme.headlineSmall ??
                                                const TextStyle(fontSize: 20))
                                            .copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: _isHoveringWelcome
                                                  ? Colors.green
                                                  : theme
                                                        .colorScheme
                                                        .onBackground,
                                            ),
                                    child: const Text(
                                      'Welcome to Flash Hustle',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 0.6.h),
                              Text(
                                'Sign in to continue',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onBackground
                                      .withOpacity(0.75),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 4.h),

                        // Animated form card
                        SlideTransition(
                          position: _formSlideAnim,
                          child: FadeTransition(
                            opacity: _fadeAnim,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 6,
                              child: Padding(
                                padding: EdgeInsets.all(4.w),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 56,
                                        child: TextFormField(
                                          focusNode: _emailFocus,
                                          controller: _emailCtl,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            prefixIcon: Container(
                                              width: 40,
                                              height: 40,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: theme.colorScheme.surface,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.email,
                                                color: theme.colorScheme.onSurfaceVariant,
                                                size: 20,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(40),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.06),
                                            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(40),
                                              borderSide: BorderSide(
                                                color: theme.colorScheme.primary,
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                          validator: (v) => v == null || v.isEmpty ? 'Please enter email' : null,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      SizedBox(
                                        height: 56,
                                        child: TextFormField(
                                          focusNode: _passFocus,
                                          controller: _passCtl,
                                          decoration: InputDecoration(
                                            labelText: 'Password',
                                            prefixIcon: Container(
                                              width: 40,
                                              height: 40,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: theme.colorScheme.surface,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.lock,
                                                color: theme.colorScheme.onSurfaceVariant,
                                                size: 20,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(40),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.06),
                                            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(40),
                                              borderSide: BorderSide(
                                                color: theme.colorScheme.primary,
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                          obscureText: true,
                                          validator: (v) => v == null || v.isEmpty ? 'Please enter password' : null,
                                        ),
                                      ),

                                      SizedBox(height: 1.h),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            'Forgot?',
                                            style: theme.textTheme.bodySmall,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 2.h),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: AnimatedScale(
                                          scale: _buttonPressed ? 0.98 : 1.0,
                                          duration: const Duration(
                                            milliseconds: 120,
                                          ),
                                          child: GestureDetector(
                                            onTapDown: (_) {
                                              if (!_loading)
                                                setState(
                                                  () => _buttonPressed = true,
                                                );
                                            },
                                            onTapUp: (_) {
                                              if (!_loading) {
                                                setState(
                                                  () => _buttonPressed = false,
                                                );
                                                _signIn();
                                              }
                                            },
                                            onTapCancel: () {
                                              setState(
                                                () => _buttonPressed = false,
                                              );
                                            },
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.resolveWith((states) => theme.colorScheme.primary),
                                                foregroundColor: MaterialStateProperty.resolveWith((states) => theme.colorScheme.onPrimary),
                                                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                )),
                                                elevation: MaterialStateProperty.all(3),
                                              ),
                                              onPressed: null,
                                              child: _loading
                                                  ? SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: CircularProgressIndicator(
                                                        color: theme.colorScheme.onPrimary,
                                                        strokeWidth: 2,
                                                      ),
                                                    )
                                                  : Text(
                                                      'Sign In',
                                                      style: theme.textTheme.titleMedium?.copyWith(
                                                        color: theme.colorScheme.onPrimary,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 1.h),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(
                                            context,
                                            rootNavigator: true,
                                          ).pushReplacementNamed(
                                            AppRoutes.userDashboard,
                                          );
                                        },
                                        child: Text(
                                          'Continue as guest',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onBackground
                                                    .withOpacity(0.8),
                                              ),
                                        ),
                                      ),

                                      SizedBox(height: 1.5.h),
                                      Row(
                                        children: [
                                          Expanded(child: Divider()),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 2.w,
                                            ),
                                            child: Text(
                                              'or',
                                              style: theme.textTheme.bodySmall,
                                            ),
                                          ),
                                          Expanded(child: Divider()),
                                        ],
                                      ),
                                      SizedBox(height: 1.5.h),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.black,
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () =>
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Google sign-in not configured',
                                                    ),
                                                  ),
                                                ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: 12,
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.g_mobiledata,
                                                    color: theme
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                  SizedBox(width: 2.w),
                                                  Text('Google'),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 3.w),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              foregroundColor: Colors.white,
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () =>
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Apple sign-in not configured',
                                                    ),
                                                  ),
                                                ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: 12,
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.apple),
                                                  SizedBox(width: 2.w),
                                                  Text('Apple'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 1.h),
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          'Don\'t have an account? Sign up',
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                                  SizedBox(height: height * 0.03),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}