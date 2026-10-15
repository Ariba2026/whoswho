
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdvertisingPaymentScreen extends StatefulWidget {
  final String packageName;
  final String duration;

  const AdvertisingPaymentScreen({
    super.key,
    required this.packageName,
    required this.duration,
  });

  @override
  State<AdvertisingPaymentScreen> createState() =>
      _AdvertisingPaymentScreenState();
}

class _AdvertisingPaymentScreenState
    extends State<AdvertisingPaymentScreen> {
  static const Color darkBrown = Color(0xFF493022);
  static const Color blue = Color(0xFF1769AA);
  static const Map<String, Map<String, int>> advertisingRates = {
    'Standard Advert': {
      '7 days': 150,
      '30 days': 500,
      '90 days': 1200,
    },
    'Featured Advert': {
      '7 days': 300,
      '30 days': 1000,
      '90 days': 2400,
    },
  };

  int get price =>
      advertisingRates[widget.packageName]?[widget.duration] ?? 0;

  static const String adminUid =
      'sqKY8Xlq6hQyDhabfPnRi6dBdpw1';

  String? _selectedPaymentMethod;
  bool _isSubmitting = false;

  Future<void> _submitOrder() async {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose M-Pesa or PayPal.'),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in with an email account first.'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    var orderSaved = false;

    try {
      final orderRef = FirebaseFirestore.instance
          .collection('advertisingOrders')
          .doc();

      await orderRef.set({
        'customerId': user.uid,
        'customerEmail': user.email,
        'packageName': widget.packageName,
        'duration': widget.duration,
        'price': price,
        'paymentMethod': _selectedPaymentMethod,
        'status': 'awaiting_payment',
        'createdAt': FieldValue.serverTimestamp(),
      });

      orderSaved = true;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(adminUid)
          .collection('notifications')
          .add({
        'title': 'New Advertising Order',
        'message':
        'Order ID: ${orderRef.id}\n'
            'Customer: ${user.email}\n'
            'Package: ${widget.packageName}\n'
            'Duration: ${widget.duration}\n'
            'Price: Kshs $price\n'
            'Payment method: $_selectedPaymentMethod\n'
            'Status: Awaiting payment.',
        'type': 'advertising_order',
        'orderId': orderRef.id,
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Order Submitted'),
          content: Text(
            'Your advertising order has been recorded.\n\n'
                'Selected payment method: $_selectedPaymentMethod\n\n'
                'Please wait for payment instructions by email. '
                'Your order is awaiting payment confirmation.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            orderSaved
                ? 'Your order was saved, but the administrator '
                'notification failed. Please contact support.'
                : 'Order submission failed. Please try again.',
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Widget _paymentOption({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedPaymentMethod == title;

    return Card(
      color: isSelected ? const Color(0xFFF5EEE8) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? blue : Colors.black12,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _isSubmitting
            ? null
            : () {
          setState(() {
            _selectedPaymentMethod = title;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected ? blue : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advertising Payment'),
        backgroundColor: darkBrown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review Your Order',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkBrown,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Advertising Package',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.packageName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Duration',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.duration,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 28),
                    const Text(
                      'Advertising Price',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kshs $price',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1769AA),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Choose a Payment Method',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _paymentOption(
              title: 'M-Pesa',
              description:
              'Choose M-Pesa to receive payment instructions.',
              icon: Icons.phone_android,
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            _paymentOption(
              title: 'PayPal',
              description:
              'Choose PayPal to receive payment instructions.',
              icon: Icons.account_balance_wallet,
              color: blue,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text('Submit Order'),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Submitting an order does not constitute payment. '
                  'Payment instructions will be sent manually after '
                  'the order is received.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
