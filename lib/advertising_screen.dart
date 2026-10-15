import 'package:flutter/material.dart';
import 'advertising_payment_screen.dart';

class AdvertisingScreen extends StatefulWidget {
  const AdvertisingScreen({super.key});

  @override
  State<AdvertisingScreen> createState() =>
      _AdvertisingScreenState();
}

class _AdvertisingScreenState
    extends State<AdvertisingScreen> {
  static const Color darkBrown = Color(0xFF493022);
  static const Color blue = Color(0xFF1769AA);

  String selectedPackage = 'Standard Advert';
  String selectedDuration = '30 days';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advertise with WhosWho'),
        backgroundColor: darkBrown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Promote Your Business',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkBrown,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose an advertising package and duration '
                  'to get started.',
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            _packageCard(
              title: 'Standard Advert',
              description:
              'Promote your business using an advert '
                  'with your business name, description, '
                  'and one image when image uploads are enabled.',
              icon: Icons.campaign,
            ),

            const SizedBox(height: 12),

            _packageCard(
              title: 'Featured Advert',
              description:
              'Give your business more prominent '
                  'placement in the Sponsored Advertisements '
                  'section.',
              icon: Icons.star,
            ),

            const SizedBox(height: 24),

            const Text(
              'Advertising Duration',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            ...['7 days', '30 days', '90 days'].map(
                  (duration) => RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                title: Text(duration),
                value: duration,
                groupValue: selectedDuration,
                activeColor: darkBrown,
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedDuration = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5EEE8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Selection',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkBrown,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Package: $selectedPackage'),
                  const SizedBox(height: 6),
                  Text('Duration: $selectedDuration'),
                  const SizedBox(height: 10),
                  const Text(
                    'Advertising rates will be confirmed '
                        'before payment is enabled.',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),
    onPressed: () {
    Navigator.of(context).push(
    MaterialPageRoute(
    builder: (context) => AdvertisingPaymentScreen(
    packageName: selectedPackage,
    duration: selectedDuration,
    ),
    ),
    );
    },

                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _packageCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    final isSelected = selectedPackage == title;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() {
          selectedPackage = title;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF5EEE8)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? darkBrown
                : Colors.black12,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: darkBrown),
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
                      color: darkBrown,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isSelected ? 'Selected' : 'Tap to select',
                    style: const TextStyle(
                      color: blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}