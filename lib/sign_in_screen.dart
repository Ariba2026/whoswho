
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

Future<void> _signIn() async {
final email = _emailController.text.trim();
final password = _passwordController.text;

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

if (!mounted) return;

Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (context) => const SocialMediaWall(),
),
);
} on FirebaseAuthException catch (e) {
String message;

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

const SizedBox(height: 24),

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