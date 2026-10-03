import 'package:flutter/material.dart';
import 'countries.dart';

class ProfessionalProfileFormScreen extends StatefulWidget {
  const ProfessionalProfileFormScreen({super.key});

  @override
  State<ProfessionalProfileFormScreen> createState() =>
      _ProfessionalProfileFormScreenState();
}

class _ProfessionalProfileFormScreenState
    extends State<ProfessionalProfileFormScreen> {
  final TextEditingController _fullNameController =
  TextEditingController();
  final TextEditingController _locationController =
  TextEditingController();
  final TextEditingController _professionController =
  TextEditingController();

  final List<Map<String, String>> _positions = [];

  @override
  void dispose() {
    _fullNameController.dispose();
    _locationController.dispose();
    _professionController.dispose();
    super.dispose();
  }

  void _addPosition() {
    setState(() {
      _positions.add({
        'position': '',
        'organization': '',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professional Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Professional Information',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Complete your professional profile so people can discover you.',
            ),

            const SizedBox(height: 24),

            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _professionController,
              decoration: const InputDecoration(
                labelText: 'Profession',
                prefixIcon: Icon(Icons.work_outline),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return countries;
                }

                return countries.where(
                      (country) => country.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  ),
                );
              },
              onSelected: (String selection) {
                _locationController.text = selection;
              },
              fieldViewBuilder: (
                  BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted,
                  ) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    hintText: 'Type to search country',
                    prefixIcon: Icon(Icons.public),
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),

            const SizedBox(height: 28),

            const Text(
              'Positions Held',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Add positions you currently hold or have held in organizations.',
            ),

            const SizedBox(height: 12),

            ..._positions.asMap().entries.map((entry) {
              final index = entry.key;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Position ${index + 1}',
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _positions[index]['position'] = value;
                        },
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Organization',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _positions[index]['organization'] = value;
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),

            OutlinedButton.icon(
              onPressed: _addPosition,
              icon: const Icon(Icons.add),
              label: const Text('Add Position'),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Save Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}