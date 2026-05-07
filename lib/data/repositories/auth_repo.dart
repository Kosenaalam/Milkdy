import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:milkdy/data/repositories/initialise.dart';
import 'package:milkdy/presentation/sell/buy_home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();

  bool _isLoading = false;
  bool _isOtpSent = false;
  String? _userEmail;
  String? _errorMessage;

  final _internetChecker = InternetConnectionChecker.instance;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() {
    Future.delayed(Duration.zero, () {
      final session = supabase.auth.currentSession;

      if (session != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BuyHomeScreen()),
        );
      }
    });
  }

  Future<bool> _hasInternet() async {
    return await _internetChecker.hasConnection;
  }

  Future<void> _sendOtp() async {
    final rawEmail = _emailController.text.trim();

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(rawEmail)) {
      setState(() => _errorMessage = 'Enter a valid email address');
      return;
    }

    if (!await _hasInternet()) {
      setState(() => _errorMessage = 'No Internet Connection');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await supabase.auth.signInWithOtp(email: rawEmail);

      if (!mounted) return;

      setState(() {
        _isOtpSent = true;
        _userEmail = rawEmail;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent to your email')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to send OTP. Try again  ${e}.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();

    if (otp.length != 6) {
      setState(() => _errorMessage = 'Enter 6-digit OTP');
      return;
    }

    if (_userEmail == null) {
      setState(() => _errorMessage = 'Session expired. Try again.');
      return;
    }

    if (!await _hasInternet()) {
      setState(() => _errorMessage = 'No Internet Connection');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await supabase.auth.verifyOTP(
        email: _userEmail!,
        token: otp,
        type: OtpType.email,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );

      setState(() {
        _isOtpSent = false;
        _emailController.clear();
        _otpController.clear();
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BuyHomeScreen()),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Invalid OTP. Try again.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email OTP Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isOtpSent) ...[
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Enter OTP',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _isLoading ? null : _verifyOtp,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check),
                label: Text(_isLoading ? 'Verifying...' : 'Verify OTP'),
              ),
            ] else ...[
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _isLoading ? null : _sendOtp,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: Text(_isLoading ? 'Sending...' : 'Send OTP'),
              ),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _internetChecker.dispose();
    super.dispose();
  }
}