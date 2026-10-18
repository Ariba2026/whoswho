
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _changeAccountType(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final userRef =
    FirebaseFirestore.instance.collection('users').doc(user.uid);

    final userDoc = await userRef.get();
    final currentType =
        userDoc.data()?['accountType']?.toString() ?? 'Professional';

    if (!context.mounted) return;

    final newType = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Change Account Type'),
        content: const Text(
          'Choose the account type you want to use.',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, 'Professional'),
            child: const Text('Professional'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, 'Business'),
            child: const Text('Business'),
          ),
        ],
      ),
    );

    if (newType == null || !context.mounted) return;

    if (newType.toLowerCase() == currentType.toLowerCase()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This is already your account type.'),
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Change'),
        content: Text(
          'Change your account type to $newType? '
              'Your existing profile information will be preserved.',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    try {
      await userRef.update({
        'accountType': newType,
      });

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Account type changed to $newType.',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not change account type: $e'),
        ),
      );
    }
  }

  Future<void> _changePassword(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please sign in with an email and password to continue.',
          ),
        ),
      );
      return;
    }

    final formKey = GlobalKey<FormState>();
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Change Password'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: currentController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Current Password',
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Enter your current password.'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: newController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Use at least 6 characters.';
                      }
                      if (value == currentController.text) {
                        return 'Choose a different password.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: confirmController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm New Password',
                    ),
                    validator: (value) =>
                    value != newController.text
                        ? 'Passwords do not match.'
                        : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext, true);
                }
              },
              child: const Text('Change Password'),
            ),
          ],
        ),
      );

      if (confirmed != true || !context.mounted) return;

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentController.text,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newController.text);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password changed successfully.'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      String message;

      if (e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        message = 'Your current password is incorrect.';
      } else if (e.code == 'weak-password') {
        message = 'Please choose a stronger password.';
      } else if (e.code == 'requires-recent-login') {
        message = 'Please sign out and sign in again, then retry.';
      } else {
        message = e.message ?? 'Could not change your password.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    } finally {
      currentController.dispose();
      newController.dispose();
      confirmController.dispose();
    }
  }

  Future<void> _changeEmail(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in again to continue.'),
        ),
      );
      return;
    }

    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    try {
      final submitted = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Change Email'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Current email: ${user.email}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'New Email Address',
                    ),
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (email.isEmpty ||
                          !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                              .hasMatch(email)) {
                        return 'Enter a valid email address.';
                      }
                      if (email.toLowerCase() ==
                          user.email!.toLowerCase()) {
                        return 'Enter a different email address.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Current Password',
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Enter your current password.'
                        : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext, true);
                }
              },
              child: const Text('Send Verification'),
            ),
          ],
        ),
      );

      if (submitted != true || !context.mounted) return;

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: passwordController.text,
      );

      await user.reauthenticateWithCredential(credential);

      await user.verifyBeforeUpdateEmail(
        emailController.text.trim(),
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Verification email requested. Open the verification '
                'link sent to your new email address to complete the change.',
          ),
          duration: Duration(seconds: 6),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      String message;

      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Your current password is incorrect.';
          break;
        case 'email-already-in-use':
          message = 'That email address is already in use.';
          break;
        case 'invalid-email':
          message = 'That email address is invalid.';
          break;
        case 'requires-recent-login':
          message = 'Please sign in again and retry.';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;
        default:
          message = e.message ?? 'Could not request the email change.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    } finally {
      emailController.dispose();
      passwordController.dispose();
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) return;

    final formKey = GlobalKey<FormState>();
    final passwordController = TextEditingController();
    final confirmationController = TextEditingController();

    try {
      final confirmed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Delete Account Permanently?'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'This action cannot be undone. Your WhosWho '
                        'account, saved profile document and notifications '
                        'will be deleted.',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Current Password',
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Enter your current password.'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: confirmationController,
                    decoration: const InputDecoration(
                      labelText: 'Type DELETE to confirm',
                    ),
                    validator: (value) =>
                    value?.trim() != 'DELETE'
                        ? 'Type DELETE exactly to continue.'
                        : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext, true);
                }
              },
              child: const Text('Delete Account'),
            ),
          ],
        ),
      );

      if (confirmed != true || !context.mounted) return;

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: passwordController.text,
      );

      await user.reauthenticateWithCredential(credential);

      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      // Delete the user's notification documents first.
      final notifications = await userRef
          .collection('notifications')
          .get();

      for (var i = 0; i < notifications.docs.length; i += 400) {
        final batch = FirebaseFirestore.instance.batch();
        final end = (i + 400 < notifications.docs.length)
            ? i + 400
            : notifications.docs.length;

        for (final doc in notifications.docs.sublist(i, end)) {
          batch.delete(doc.reference);
        }

        await batch.commit();
      }

      // Delete the user's profile document.
      await userRef.delete();

      // Finally, delete the Firebase Authentication account.
      await user.delete();

      if (!context.mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      String message;

      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Your current password is incorrect.';
          break;
        case 'requires-recent-login':
          message = 'Please sign in again and retry.';
          break;
        default:
          message = e.message ?? 'Could not delete the account.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } on FirebaseException catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not finish deleting account data: ${e.message ?? e.code}. '
                'Some data may already have been deleted. Please seek assistance '
                'before trying again.',
          ),
          duration: const Duration(seconds: 7),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account deletion could not be completed. '
                'Please contact support before retrying.',
          ),
          duration: Duration(seconds: 6),
        ),
      );
    } finally {
      passwordController.dispose();
      confirmationController.dispose();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF493022),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Change Account Type'),
            subtitle: const Text(
              'Switch between Professional and Business',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _changeAccountType(context),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change Password'),
            subtitle: const Text(
              'Update your account password',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _changePassword(context),
          ),

          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Change Email'),
            subtitle: const Text(
              'Update your login email address',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _changeEmail(context),
          ),

          ListTile(
            leading: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.red,
            ),
            title: const Text(
              'Delete Account',
              style: TextStyle(color: Colors.red),
            ),
            subtitle: const Text(
              'Permanently delete your WhosWho account',
            ),
            onTap: () => _deleteAccount(context),
          ),
        ],
      ),
    );
  }
}


