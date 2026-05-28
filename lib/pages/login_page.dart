import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final user = await _authService.signInWithGoogle();
      if (user == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('sign in cancelled')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('sign in failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _LoginPageBody(
          isLoading: _isLoading,
          onSignInPressed: _handleGoogleSignIn,
        ),
      ),
    );
  }
}

class _LoginPageBody extends StatelessWidget {
  const _LoginPageBody({
    required this.isLoading,
    required this.onSignInPressed,
  });

  final bool isLoading;
  final VoidCallback onSignInPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final horizontalPadding = width < 420 ? 33.0 : 48.0;

        return Column(
          children: [
            Expanded(
              child: Center(
                child: Transform.translate(
                  offset: const Offset(0, -42),
                  child: const _BrandLockup(),
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                29,
                horizontalPadding,
                38,
              ),
              child: _GoogleSignInButton(
                isLoading: isLoading,
                onPressed: onSignInPressed,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 104,
          height: 98,
          child: CustomPaint(
            painter: _CoffeeCupPainter(),
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          '我還沒想好他要叫什麼',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'GenRyuMin2TW',
            fontSize: 27,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          disabledBackgroundColor: const Color(0xFFD9D9D9),
          backgroundColor: const Color(0xFFD9D9D9),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'GenRyuMin2TW',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: isLoading
              ? const SizedBox(
                  key: ValueKey('loading'),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.3,
                    color: Colors.black,
                  ),
                )
              : const Text(
                  'sign in/register with Google',
                  key: ValueKey('label'),
                ),
        ),
      ),
    );
  }
}

class _CoffeeCupPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cup = Path()
      ..moveTo(size.width * 0.07, size.height * 0.33)
      ..lineTo(size.width * 0.93, size.height * 0.33)
      ..lineTo(size.width * 0.93, size.height * 0.74)
      ..cubicTo(
        size.width * 0.93,
        size.height * 0.88,
        size.width * 0.76,
        size.height * 0.99,
        size.width * 0.5,
        size.height * 0.99,
      )
      ..cubicTo(
        size.width * 0.24,
        size.height * 0.99,
        size.width * 0.07,
        size.height * 0.88,
        size.width * 0.07,
        size.height * 0.74,
      )
      ..close();

    canvas.drawPath(cup, paint);

    for (final x in const [0.26, 0.5, 0.74]) {
      canvas.drawLine(
        Offset(size.width * x, size.height * 0.03),
        Offset(size.width * x, size.height * 0.18),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
