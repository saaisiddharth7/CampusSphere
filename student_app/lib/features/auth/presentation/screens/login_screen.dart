import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _tenantController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _showOtpLogin = false;
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _tenantController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ref.listen(authProvider, (prev, next) {
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // Logo & Branding
              _buildBranding(theme).animate().fadeIn(duration: 600.ms).slideY(
                    begin: -0.2,
                    duration: 600.ms,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: 40),

              // Login Form
              if (!_showOtpLogin) ...[
                _buildPasswordLogin(theme, authState),
              ] else ...[
                _buildOtpLogin(theme, authState),
              ],

              const SizedBox(height: 24),

              // Toggle login method
              TextButton(
                onPressed: () {
                  setState(() {
                    _showOtpLogin = !_showOtpLogin;
                    _otpSent = false;
                  });
                },
                child: Text(
                  _showOtpLogin
                      ? '🔒 Login with Password'
                      : '📱 Login with OTP',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Biometric Login
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement biometric auth with local_auth
                },
                icon: const Icon(Icons.fingerprint, size: 24),
                label: const Text('Biometric Login'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

              const SizedBox(height: 12),

              // Demo Mode (DEV ONLY — remove when backend is live)
              OutlinedButton.icon(
                onPressed: authState.status == AuthStatus.loading
                    ? null
                    : () {
                        ref.read(authProvider.notifier).loginDemoMode();
                      },
                icon: const Icon(Icons.science_outlined, size: 20),
                label: const Text('Enter Demo Mode'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  foregroundColor: colorScheme.tertiary,
                  side: BorderSide(color: colorScheme.tertiary.withValues(alpha: 0.4)),
                ),
              ).animate().fadeIn(delay: 500.ms, duration: 400.ms),

              const SizedBox(height: 40),

              // Powered by
              Text(
                'Powered by CampusSphere',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ).animate().fadeIn(delay: 600.ms),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBranding(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return Column(
      children: [
        // Placeholder for tenant logo (loaded from API)
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.school_rounded,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Welcome Back',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Sign in to your student account',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordLogin(ThemeData theme, AuthState authState) {
    final colorScheme = theme.colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tenant / Institution Code
          TextFormField(
            controller: _tenantController,
            decoration: const InputDecoration(
              labelText: 'Institution Code',
              hintText: 'e.g., xyz-engineering',
              prefixIcon: Icon(Icons.business),
            ),
            textInputAction: TextInputAction.next,
            validator: (v) =>
                v == null || v.isEmpty ? 'Institution code required' : null,
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

          const SizedBox(height: 16),

          // Email / Roll Number
          TextFormField(
            controller: _identifierController,
            decoration: const InputDecoration(
              labelText: 'Email or Roll Number',
              hintText: 'student@college.edu or 21CS101',
              prefixIcon: Icon(Icons.person_outline),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (v) =>
                v == null || v.isEmpty ? 'Email or roll number required' : null,
          ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

          const SizedBox(height: 16),

          // Password
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            validator: (v) =>
                v == null || v.isEmpty ? 'Password required' : null,
            onFieldSubmitted: (_) => _onLogin(),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

          const SizedBox(height: 12),

          // Remember me + Forgot password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (v) => setState(() => _rememberMe = v ?? false),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  Text(
                    'Remember me',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to forgot password flow
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

          const SizedBox(height: 24),

          // Login Button
          ElevatedButton(
            onPressed: authState.status == AuthStatus.loading ? null : _onLogin,
            child: authState.status == AuthStatus.loading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.login, size: 20),
                      SizedBox(width: 8),
                      Text('LOGIN'),
                    ],
                  ),
          ).animate().fadeIn(delay: 300.ms, duration: 400.ms).scale(
                begin: const Offset(0.95, 0.95),
                duration: 400.ms,
              ),
        ],
      ),
    );
  }

  Widget _buildOtpLogin(ThemeData theme, AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Tenant / Institution Code
        TextFormField(
          controller: _tenantController,
          decoration: const InputDecoration(
            labelText: 'Institution Code',
            hintText: 'e.g., xyz-engineering',
            prefixIcon: Icon(Icons.business),
          ),
          textInputAction: TextInputAction.next,
        ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

        const SizedBox(height: 16),

        // Phone Number
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: '+91 98765 43210',
            prefixIcon: Icon(Icons.phone_outlined),
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

        const SizedBox(height: 16),

        if (_otpSent) ...[
          // OTP Input
          TextFormField(
            controller: _otpController,
            decoration: const InputDecoration(
              labelText: 'Enter 6-digit OTP',
              prefixIcon: Icon(Icons.dialpad),
            ),
            keyboardType: TextInputType.number,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: authState.status == AuthStatus.loading
                ? null
                : () {
                    ref.read(authProvider.notifier).verifyOtp(
                          phone: _phoneController.text.trim(),
                          otp: _otpController.text.trim(),
                          tenantId: _tenantController.text.trim(),
                        );
                  },
            child: authState.status == AuthStatus.loading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text('VERIFY OTP'),
          ),
        ] else ...[
          ElevatedButton(
            onPressed: authState.status == AuthStatus.loading
                ? null
                : () async {
                    await ref.read(authProvider.notifier).sendOtp(
                          phone: _phoneController.text.trim(),
                          tenantId: _tenantController.text.trim(),
                        );
                    setState(() => _otpSent = true);
                  },
            child: authState.status == AuthStatus.loading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text('SEND OTP'),
          ),
        ],
      ],
    );
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() != true) return;

    ref.read(authProvider.notifier).login(
          identifier: _identifierController.text.trim(),
          password: _passwordController.text,
          tenantId: _tenantController.text.trim(),
        );
  }
}
