
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'social_media_wall.dart';

class SignInScreen extends StatefulWidget {
const SignInScreen({super.key});

@override
State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
final _emailController = TextEditingController();
final _passwordController = TextEditingController();

bool _isLoading = false;
bool _obscurePassword = true;
final Map<String, int> _failedAttempts = {};
final Map<String, DateTime> _lockoutUntil = {};

static const int _maxAttempts = 6;
static const Duration _lockoutDuration = Duration(hours: 3);
Future<void> _loadAttemptData(String emailKey) async {
  final prefs = await SharedPreferences.getInstance();

  final attempts = prefs.getInt('signin_failed_$emailKey') ?? 0;
  final lockoutTimestamp = prefs.getInt('signin_lockout_$emailKey');

  _failedAttempts[emailKey] = attempts;

  if (lockoutTimestamp != null) {
    _lockoutUntil[emailKey] =
        DateTime.fromMillisecondsSinceEpoch(lockoutTimestamp);
  } else {
    _lockoutUntil.remove(emailKey);
  }
}

Future<void> _saveAttemptData(String emailKey) async {
  final prefs = await SharedPreferences.getInstance();

  final attempts = _failedAttempts[emailKey] ?? 0;
  final lockoutEnd = _lockoutUntil[emailKey];

  if (attempts > 0) {
    await prefs.setInt('signin_failed_$emailKey', attempts);
  } else {
    await prefs.remove('signin_failed_$emailKey');
  }

  if (lockoutEnd != null) {
    await prefs.setInt(
      'signin_lockout_$emailKey',
      lockoutEnd.millisecondsSinceEpoch,
    );
  } else {
    await prefs.remove('signin_lockout_$emailKey');
  }
}

Future<void> _signIn() async {
final email = _emailController.text.trim();
final password = _passwordController.text;
final emailKey = email.toLowerCase();
await _loadAttemptData(emailKey);
final lockoutEnd = _lockoutUntil[emailKey];

if (lockoutEnd != null) {
  if (DateTime.now().isBefore(lockoutEnd)) {
    final remaining = lockoutEnd.difference(DateTime.now());
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Too many failed attempts. Try again in '
              '${hours}h ${minutes}m.',
        ),
      ),
    );
    return;

  } else {
    _lockoutUntil.remove(emailKey);
    _failedAttempts.remove(emailKey);
    await _saveAttemptData(emailKey);
  }
}
if (email.isEmpty || password.isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Please enter your email and password.'),
),
);
return;
}

setState(() {
_isLoading = true;
});

try {
await FirebaseAuth.instance.signInWithEmailAndPassword(
email: email,
password: password,
);
_failedAttempts.remove(emailKey);
_lockoutUntil.remove(emailKey);
await _saveAttemptData(emailKey);

if (!mounted) return;

Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (context) => const SocialMediaWall(),
),
);
} on FirebaseAuthException catch (e) {
String message;
if (e.code == 'wrong-password' ||
    e.code == 'user-not-found' ||
    e.code == 'invalid-credential') {
  _failedAttempts[emailKey] =
      (_failedAttempts[emailKey] ?? 0) + 1;

  final attempts = _failedAttempts[emailKey]!;
  await _saveAttemptData(emailKey);

  if (attempts >= _maxAttempts) {
    _lockoutUntil[emailKey] ??=
        DateTime.now().add(_lockoutDuration);

    await _saveAttemptData(emailKey);

    message =
    'You have reached 6 failed attempts. '
        'Please try again after 3 hours.';
  }else {
    final remainingAttempts = _maxAttempts - attempts;

    message =
    'Incorrect email or password. '
        '$remainingAttempts attempts remaining.';
  }

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
  return;
}
if (e.code == 'user-not-found' ||
e.code == 'invalid-credential') {
message = 'No matching account was found. Check your email and password.';
} else if (e.code == 'wrong-password') {
message = 'Incorrect password. Please try again.';
} else if (e.code == 'invalid-email') {
message = 'Please enter a valid email address.';
} else if (e.code == 'too-many-requests') {
message = 'Too many attempts. Please try again later.';
} else {
message = e.message ?? 'Sign in failed. Please try again.';
}

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text(message)),
);
} catch (_) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Something went wrong. Please try again.'),
),
);
} finally {
if (mounted) {
setState(() {
_isLoading = false;
});
}
}
}

Future<void> _resetPassword() async {
  final email = _emailController.text.trim();

  if (email.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter your email address first.'),
      ),
    );
    return;
  }

  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    );
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'If an account exists for this email, a password-reset email will be sent.',
        ),
      ),
    );
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.code == 'invalid-email'
              ? 'Please enter a valid email address.'
              : 'Could not send the reset email. Please try again.',
        ),
      ),
    );
  } catch (_) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Something went wrong. Please try again.'),
      ),
    );
  }
}
@override
void dispose() {
_emailController.dispose();
_passwordController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Sign In'),
),
body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.all(24),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
const SizedBox(height: 24),

const Text(
'Welcome Back',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 26,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 8),

const Text(
'Sign in to your WhosWho account.',
textAlign: TextAlign.center,
style: TextStyle(fontSize: 16),
),

const SizedBox(height: 32),

TextField(
controller: _emailController,
keyboardType: TextInputType.emailAddress,
autocorrect: false,
decoration: const InputDecoration(
labelText: 'Email Address',
prefixIcon: Icon(Icons.email_outlined),
border: OutlineInputBorder(),
),
),

const SizedBox(height: 16),

TextField(
controller: _passwordController,
obscureText: _obscurePassword,
decoration: InputDecoration(
labelText: 'Password',
prefixIcon: const Icon(Icons.lock_outline),
border: const OutlineInputBorder(),
suffixIcon: IconButton(
icon: Icon(
_obscurePassword
? Icons.visibility_outlined
    : Icons.visibility_off_outlined,
),
onPressed: () {
setState(() {
_obscurePassword = !_obscurePassword;
});
},
),
),
onSubmitted: (_) {
if (!_isLoading) {
_signIn();
}
},
),

  Align(
    alignment: Alignment.centerRight,
    child: TextButton(
      onPressed: _isLoading ? null : _resetPassword,
      child: const Text('Forgot Password?'),
    ),
  ),

  const SizedBox(height: 8),

ElevatedButton(
onPressed: _isLoading ? null : _signIn,
style: ElevatedButton.styleFrom(
minimumSize: const Size(double.infinity, 50),
),
child: _isLoading
? const SizedBox(
height: 24,
width: 24,
child: CircularProgressIndicator(
strokeWidth: 2,
),
)
    : const Text(
'Sign In',
style: TextStyle(fontSize: 16),
),
),
],
),
),
),
);
}
}