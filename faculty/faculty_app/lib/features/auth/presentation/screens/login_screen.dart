import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _tenantController = TextEditingController();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _tenantController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_tenantController.text.isEmpty ||
        _identifierController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    ref.read(authProvider.notifier).login(
          tenantSlug: _tenantController.text.trim(),
          identifier: _identifierController.text.trim(),
          password: _passwordController.text,
        );
  }

  void _handleDemoMode() {
    ref.read(authProvider.notifier).loginDemoMode();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ref.listen<AuthState>(authProvider, (prev, next) {
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo & Title
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
                  child: Icon(
                    Icons.school_rounded,
                    size: 40,
                    color: colorScheme.onPrimary,
                  ),
                ).animate().fadeIn(duration: 500.ms).scale(delay: 200.ms),
                const SizedBox(height: 24),
                Text(
                  'CampusSphere',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 4),
                Text(
                  'Faculty Portal',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 40),

                // Institution Code
                TextField(
                  controller: _tenantController,
                  decoration: const InputDecoration(
                    labelText: 'Institution Code',
                    hintText: 'e.g. xyz-engineering',
                    prefixIcon: Icon(Icons.business_rounded),
                  ),
                  textInputAction: TextInputAction.next,
                ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.1),
                const SizedBox(height: 16),

                // Email / Phone
                TextField(
                  controller: _identifierController,
                  decoration: const InputDecoration(
                    labelText: 'Email or Phone',
                    hintText: 'Enter your email or phone',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.1),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
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
                  onSubmitted: (_) => _handleLogin(),
                ).animate().fadeIn(delay: 700.ms).slideX(begin: -0.1),
                const SizedBox(height: 24),

                // Login Button
                ElevatedButton(
                  onPressed: authState.status == AuthStatus.loading
                      ? null
                      : _handleLogin,
                  child: authState.status == AuthStatus.loading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Sign In'),
                ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.1),
                const SizedBox(height: 16),

                // Demo Mode
                OutlinedButton.icon(
                  onPressed: authState.status == AuthStatus.loading
                      ? null
                      : _handleDemoMode,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Enter Demo Mode'),
                ).animate().fadeIn(delay: 900.ms),
                const SizedBox(height: 8),
                Text(
                  'Try with sample data — no login required',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ).animate().fadeIn(delay: 1000.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
