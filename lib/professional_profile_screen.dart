
import 'package:flutter/material.dart';
import 'departments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'countries.dart';

class ProfessionalProfileFormScreen extends StatefulWidget {
  const ProfessionalProfileFormScreen({super.key});

  @override
  State<ProfessionalProfileFormScreen> createState() =>
      _ProfessionalProfileFormScreenState();
}

class _ProfessionalProfileFormScreenState
    extends State<ProfessionalProfileFormScreen> {
  final TextEditingController _salutationController =
  TextEditingController();
  final TextEditingController _fullNameController =
  TextEditingController();
  final TextEditingController _streetNameController =
  TextEditingController();
  final TextEditingController _telephoneController =
  TextEditingController();
  final TextEditingController _whatsAppController =
  TextEditingController();
  final TextEditingController _cityController =
  TextEditingController();
  final TextEditingController _countryCodeController =
  TextEditingController();
  final TextEditingController _emailController =
  TextEditingController();
  final TextEditingController _locationController =
  TextEditingController();
  final TextEditingController _aboutMeController =
  TextEditingController();
  final TextEditingController _skillsController =
  TextEditingController();
  final TextEditingController _servicesController =
  TextEditingController();
  final TextEditingController _educationController =
  TextEditingController();
  final TextEditingController _certificationsController =
  TextEditingController();
  final TextEditingController _websiteController =
  TextEditingController();
  final TextEditingController _languagesController =
  TextEditingController();

  final List<Map<String, String>> _positions = [];
  final List<String> _professions = [''];
  final List<String> _departments = [''];
  final List<String> _otherDepartments = [''];
  final List<Map<String, String>> _additionalCountries = [];

  String? _yearsOfExperience;
  String? _availability;
  String _countryTelephoneCode = '';
  bool _showSocialMedia = false;
  bool _isLoadingProfile = true;

  final Map<String, String> _socialMedia = {
    'LinkedIn': '',
    'Facebook': '',
    'Instagram': '',
    'X / Twitter': '',
    'YouTube': '',
    'TikTok': '',
  };

  final List<Map<String, String>> _additionalSocialMedia = [];

  @override
  void dispose() {
    _fullNameController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _aboutMeController.dispose();
    _skillsController.dispose();
    _servicesController.dispose();
    _cityController.dispose();
    _countryCodeController.dispose();
    _educationController.dispose();
    _certificationsController.dispose();
    _websiteController.dispose();
    _languagesController.dispose();
    super.dispose();
  }

  void _addProfession() {
    setState(() {
      _professions.add('');
      _departments.add('');
      _otherDepartments.add('');
    });
  }

  void _addPosition() {
    setState(() {
      _positions.add({
        'title': '',
        'company': '',
      });
    });
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        _isLoadingProfile = false;
      });
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = doc.data();
      final profile = data?['professionalProfile'];

      if (profile is Map<String, dynamic>) {
        _salutationController.text = profile['salutation'] ?? '';
        _fullNameController.text = profile['fullName'] ?? '';
        _streetNameController.text = profile['streetName'] ?? '';
        _telephoneController.text = profile['telephone'] ?? '';
        _whatsAppController.text = profile['whatsApp']?.toString() ?? '';
        _cityController.text = profile['city'] ?? '';
        _emailController.text = profile['email'] ?? '';
        _locationController.text = profile['country'] ?? '';

        _countryTelephoneCode =
            countryTelephoneCodes[_locationController.text] ?? '';
        _countryCodeController.text = _countryTelephoneCode;

        _aboutMeController.text = profile['aboutMe'] ?? '';
        _skillsController.text = profile['skills'] ?? '';
        _servicesController.text = profile['services'] ?? '';
        _educationController.text = profile['education'] ?? '';
        _certificationsController.text =
            profile['certifications'] ?? '';
        _websiteController.text = profile['website'] ?? '';
        _languagesController.text = profile['languages'] ?? '';

        _yearsOfExperience = profile['yearsOfExperience'];
        _availability = profile['availability'];

        final professions = profile['professions'];
        if (professions is List) {
          _professions
            ..clear()
            ..addAll(
              professions.map((item) => item.toString()),
            );

          if (_professions.isEmpty) {
            _professions.add('');
          }
        }

        final departments = profile['departments'];
        if (departments is List) {
          _departments
            ..clear()
            ..addAll(
              departments.map((item) => item.toString()),
            );

          if (_departments.isEmpty) {
            _departments.add('');
          }
        }

        final otherDepartments = profile['otherDepartments'];
        if (otherDepartments is List) {
          _otherDepartments
            ..clear()
            ..addAll(
              otherDepartments.map((item) => item.toString()),
            );
        }

        while (_departments.length < _professions.length) {
          _departments.add('');
        }
        while (_otherDepartments.length < _professions.length) {
          _otherDepartments.add('');
        }

        final positions = profile['positions'];
        if (positions is List) {
          _positions
            ..clear()
            ..addAll(
              positions.map(
                    (item) => Map<String, String>.from(item),
              ),
            );
        }

        final additionalCountries = profile['additionalCountries'];
        if (additionalCountries is List) {
          _additionalCountries
            ..clear()
            ..addAll(
              additionalCountries.map(
                    (item) => Map<String, String>.from(item),
              ),
            );
        }

        debugPrint(
          'LOADED ADDITIONAL COUNTRIES: $_additionalCountries',
        );

        final socialMedia = profile['socialMedia'];
        debugPrint('LOADED SOCIAL MEDIA: $socialMedia');

        if (socialMedia is Map) {
          _socialMedia.forEach((platform, _) {
            _socialMedia[platform] =
                socialMedia[platform]?.toString() ?? '';
          });
        }

        final additionalSocialMedia =
        profile['additionalSocialMedia'];

        if (additionalSocialMedia is List) {
          _additionalSocialMedia
            ..clear()
            ..addAll(
              additionalSocialMedia.map(
                    (item) => Map<String, String>.from(item),
              ),
            );
        }

        final hasSocialMedia = _socialMedia.values.any(
              (value) => value.trim().isNotEmpty,
        );

        _showSocialMedia =
            hasSocialMedia || _additionalSocialMedia.isNotEmpty;
      }
    } catch (e) {
      debugPrint('Failed to load professional profile: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingProfile = false;

          final hasSocialMedia = _socialMedia.values.any(
                (value) => value.trim().isNotEmpty,
          );

          _showSocialMedia =
              hasSocialMedia || _additionalSocialMedia.isNotEmpty;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please sign in before saving your profile.',
          ),
        ),
      );
      return;
    }

    if (_fullNameController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty ||
        _professions.every(
              (profession) => profession.trim().isEmpty,
        ) ||
        _servicesController.text.trim().isEmpty ||
        _availability == null ||
        _languagesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in all required fields marked with *.',
          ),
        ),
      );
      return;
    }

    final profileData = {
      'salutation': _salutationController.text.trim(),
      'fullName': _fullNameController.text.trim(),
      'streetName': _streetNameController.text.trim(),
      'telephone': _telephoneController.text.trim(),
      'whatsApp': _whatsAppController.text.trim(),
      'city': _cityController.text.trim(),
      'email': _emailController.text.trim(),
      'socialMedia': _socialMedia,
      'additionalSocialMedia': _additionalSocialMedia,
      'professions': _professions,
      'departments': _departments,
      'otherDepartments': _otherDepartments,
      'services': _servicesController.text.trim(),
      'country': _locationController.text.trim(),
      'additionalCountries': _additionalCountries,
      'positions': _positions,
      'aboutMe': _aboutMeController.text.trim(),
      'yearsOfExperience': _yearsOfExperience,
      'skills': _skillsController.text.trim(),
      'availability': _availability,
      'education': _educationController.text.trim(),
      'certifications': _certificationsController.text.trim(),
      'website': _websiteController.text.trim(),
      'languages': _languagesController.text.trim(),
    };


    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'professionalProfile': profileData,
      }, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection('publicProfiles')
          .doc(user.uid)
          .set({
        'accountType': 'Professional',
        'fullName': profileData['fullName'],
        'professionalProfile': profileData,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));


      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Professional profile saved successfully.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save profile: $e'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProfile) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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

// Salutation: optional, maximum 50 characters.
            TextField(
              controller: _salutationController,
              maxLength: 50,
              decoration: const InputDecoration(
                labelText: 'Salutation',
                hintText: 'e.g. Engineer, Reverend, Mr, Miss',
                prefixIcon: Icon(Icons.badge_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

// Full Name: maximum 100 characters.
            // Full Name: maximum 100 characters.
            TextField(
              controller: _fullNameController,
              maxLength: 100,
              decoration: InputDecoration(
                label: RichText(
                  text: const TextSpan(
                    text: 'Full Name ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                prefixIcon: const Icon(Icons.person_outline),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Street Name: optional, maximum 100 characters.
            TextField(
              controller: _streetNameController,
              maxLength: 100,
              decoration: const InputDecoration(
                labelText: 'Street Name',
                hintText: 'nick name e.g. Ojay, Coblo',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Country autocomplete: unchanged.
            Autocomplete<String>(
              initialValue: TextEditingValue(
                text: _locationController.text,
              ),
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
                setState(() {
                  _locationController.text = selection;
                  _countryTelephoneCode =
                      countryTelephoneCodes[selection] ?? '';
                  _countryCodeController.text =
                      _countryTelephoneCode;
                });
              },
              fieldViewBuilder: (
                  BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted,
                  ) {
                return Focus(
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      textEditingController.selection =
                          TextSelection.collapsed(
                            offset: textEditingController.text.length,
                          );
                    }
                  },
                  child: TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    onChanged: (value) {
                      _locationController.text = value;
                    },
                    decoration: InputDecoration(
                      label: RichText(
                        text: const TextSpan(
                          text: 'Country ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: '*',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      hintText: 'Type to search country',
                      prefixIcon: const Icon(Icons.public),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 85,
                  child: TextFormField(
                    controller: _countryCodeController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _telephoneController,
                    maxLength: 25,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Telephone (optional)',
                      hintText: 'e.g. 712 345 678',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),


            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 85,
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: _countryTelephoneCode,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _whatsAppController,
                    maxLength: 25,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'WhatsApp Number (optional)',
                      hintText: 'e.g. 712 345 678',
                      prefixIcon: Icon(Icons.chat),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),


            const SizedBox(height: 16),

            // Physical Address: maximum 300 characters.
            TextFormField(
              controller: _cityController,
              maxLines: 2,
              maxLength: 300,
              decoration: const InputDecoration(
                labelText: 'Physical Address (optional)',
                hintText:
                'City, town, street, estate, building, village, etc.',
                prefixIcon: Icon(Icons.location_city),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 16),

            // Email: maximum 254 characters.
            TextFormField(
              controller: _emailController,
              maxLength: 254,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email (optional)',
                hintText: 'e.g. professional@example.com',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Professions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            ..._professions.asMap().entries.map((entry) {
              final index = entry.key;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    // Each profession: maximum 100 characters.
                    TextField(
                      controller: TextEditingController(
                        text: _professions[index],
                      ),
                      maxLength: 100,
                      decoration: InputDecoration(
                        label: RichText(
                          text: TextSpan(
                            text: index == 0
                                ? 'Profession 1 '
                                : 'Profession ${index + 1} (Optional) ',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            children: index == 0
                                ? const [
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ]
                                : const [],
                          ),
                        ),
                        prefixIcon: const Icon(Icons.work_outline),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _professions[index] = value;
                      },
                    ),

                    const SizedBox(height: 12),

                    // Department autocomplete: unchanged.
                    Autocomplete<String>(
                      initialValue: TextEditingValue(
                        text: _departments[index],
                      ),
                      optionsBuilder:
                          (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return departments;
                        }

                        return departments.where(
                              (department) =>
                              department.toLowerCase().contains(
                                textEditingValue.text.toLowerCase(),
                              ),
                        );
                      },
                      onSelected: (String selection) {
                        setState(() {
                          _departments[index] = selection;

                          if (selection != 'Other') {
                            _otherDepartments[index] = '';
                          }
                        });
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
                            labelText: 'Department (optional)',
                            hintText: 'Type to search department',
                            prefixIcon:
                            Icon(Icons.account_tree_outlined),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _departments[index] = value;
                            });
                          },
                        );
                      },
                    ),

                    if (_departments[index] == 'Other') ...[
                      const SizedBox(height: 12),

                      // Other Department: maximum 100 characters.
                      TextField(
                        maxLength: 100,
                        decoration: const InputDecoration(
                          labelText: 'Other Department (optional)',
                          prefixIcon: Icon(Icons.edit_outlined),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _otherDepartments[index] = value;
                        },
                      ),
                    ],
                  ],
                ),
              );
            }),

            OutlinedButton.icon(
              onPressed: _addProfession,
              icon: const Icon(Icons.add),
              label: const Text('Add Profession'),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _additionalCountries.add({
                      'country': '',
                      'telephone': '',
                      'city': '',
                    });
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Dual citizen? Add country'),
              ),
            ),

            ..._additionalCountries.asMap().entries.map((entry) {
              final index = entry.key;

              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  children: [
                    // Additional country autocomplete: unchanged.
                    Autocomplete<String>(
                      initialValue: TextEditingValue(
                        text:
                        _additionalCountries[index]['country'] ?? '',
                      ),
                      optionsBuilder:
                          (TextEditingValue textEditingValue) {
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
                        setState(() {
                          _additionalCountries[index]['country'] =
                              selection;
                        });
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
                          onChanged: (value) {
                            _additionalCountries[index]['country'] =
                                value;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Additional Country',
                            hintText: 'Type to search country',
                            prefixIcon: Icon(Icons.public),
                            border: OutlineInputBorder(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 85,
                          child: TextFormField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: countryTelephoneCodes[
                              _additionalCountries[index]
                              ['country']] ??
                                  '',
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Code',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            initialValue:
                            _additionalCountries[index]
                            ['telephone'] ??
                                '',
                            maxLength: 25,
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              _additionalCountries[index]['telephone'] =
                                  value;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Telephone (optional)',
                              hintText: 'e.g. 712 345 678',
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Preserved from your original code.
                    TextFormField(
                      controller: _cityController,
                      maxLines: 2,
                      maxLength: 300,
                      decoration: const InputDecoration(
                        labelText: 'Physical Address (optional)',
                        hintText:
                        'City, town, street, estate, building, village, etc.',
                        prefixIcon: Icon(Icons.location_city),
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              );
            }),

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
                      // Position title: maximum 100 characters.
                      TextField(
                        controller: TextEditingController(
                          text: _positions[index]['position'] ?? '',
                        ),
                        maxLength: 100,
                        decoration: InputDecoration(
                          labelText:
                          'Position ${index + 1} (optional)',
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _positions[index]['position'] = value;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Organization: maximum 150 characters.
                      TextField(
                        controller: TextEditingController(
                          text:
                          _positions[index]['organization'] ?? '',
                        ),
                        maxLength: 150,
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

            const SizedBox(height: 24),

            // About Me: existing limit retained.
            TextFormField(
              controller: _aboutMeController,
              maxLines: 5,
              maxLength: 1000,
              decoration: const InputDecoration(
                labelText: 'About Me (optional)',
                hintText:
                'Tell us about yourself, professional background, experience and expertise',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Years of Experience dropdown: unchanged.
            DropdownButtonFormField<String>(
              value: _yearsOfExperience,
              decoration: const InputDecoration(
                labelText: 'Years of Experience (optional)',
                prefixIcon: Icon(Icons.work_history_outlined),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Less than 1 year',
                  child: Text('Less than 1 year'),
                ),
                DropdownMenuItem(
                  value: '1–3 years',
                  child: Text('1–3 years'),
                ),
                DropdownMenuItem(
                  value: '4–7 years',
                  child: Text('4–7 years'),
                ),
                DropdownMenuItem(
                  value: '8–15 years',
                  child: Text('8–15 years'),
                ),
                DropdownMenuItem(
                  value: '15+ years',
                  child: Text('15+ years'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _yearsOfExperience = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // Skills & Expertise: maximum 500 characters.
            TextFormField(
              controller: _skillsController,
              maxLines: 3,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: 'Skills & Expertise (optional)',
                hintText: 'e.g. Graphic Design, Branding, Photoshop',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.star_outline),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // My Services: maximum 1,000 characters.
            TextFormField(
              controller: _servicesController,
              maxLines: 4,
              maxLength: 1000,
              decoration: InputDecoration(
                label: RichText(
                  text: const TextSpan(
                    text: 'My Services ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                hintText:
                'e.g. Logo Design, Video Editing, Website Development',
                alignLabelWithHint: true,
                prefixIcon:
                const Icon(Icons.design_services_outlined),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Availability dropdown: unchanged.
            DropdownButtonFormField<String>(
              value: _availability,
              decoration: InputDecoration(
                label: RichText(
                  text: const TextSpan(
                    text: 'Availability ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                prefixIcon: const Icon(Icons.public),
                border: const OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Remote',
                  child: Text('Remote'),
                ),
                DropdownMenuItem(
                  value: 'On-site',
                  child: Text('On-site'),
                ),
                DropdownMenuItem(
                  value: 'Remote and On-site',
                  child: Text('Remote and On-site'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _availability = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // Education & Qualifications: maximum 1,000 characters.
            TextFormField(
              controller: _educationController,
              maxLines: 4,
              maxLength: 1000,
              decoration: const InputDecoration(
                labelText: 'Education & Qualifications (optional)',
                hintText:
                'e.g. BSc Computer Science, Diploma in Graphic Design',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.school_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Certifications & Licences: maximum 1,000 characters.
            TextFormField(
              controller: _certificationsController,
              maxLines: 3,
              maxLength: 1000,
              decoration: const InputDecoration(
                labelText: 'Certifications & Licences (optional)',
                hintText:
                'e.g. AWS Certified, Driving Licence, CPA',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.verified_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Website / Portfolio: maximum 500 characters.
            TextFormField(
              controller: _websiteController,
              maxLength: 500,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Website / Portfolio (optional)',
                hintText: 'e.g. https://example.com',
                prefixIcon: Icon(Icons.language),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _showSocialMedia = !_showSocialMedia;
                });
              },
              icon: Icon(
                _showSocialMedia ? Icons.remove : Icons.add,
              ),
              label: Text(
                _showSocialMedia
                    ? 'Hide Social Media Links'
                    : 'Add Social Media Links (Optional)',
              ),
            ),

            if (_showSocialMedia) ...[
              const SizedBox(height: 12),

              ..._socialMedia.keys.map((platform) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextFormField(
                    keyboardType: TextInputType.url,
                    initialValue: _socialMedia[platform] ?? '',
                    maxLength: 500,
                    decoration: InputDecoration(
                      labelText: '$platform (Optional)',
                      hintText: 'Enter your $platform profile link',
                      prefixIcon: const Icon(Icons.link),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _socialMedia[platform] = value;
                    },
                  ),
                );
              }),
            ],

            const SizedBox(height: 4),

            ..._additionalSocialMedia.asMap().entries.map((entry) {
              final index = entry.key;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // Additional platform name: maximum 50 characters.
                      TextField(
                        maxLength: 50,
                        decoration: const InputDecoration(
                          labelText: 'Platform',
                          hintText:
                          'e.g. Threads, Pinterest, Telegram',
                          prefixIcon: Icon(Icons.public),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _additionalSocialMedia[index]['platform'] =
                              value;
                        },
                      ),

                      const SizedBox(height: 12),

                      // Additional profile link: maximum 500 characters.
                      TextField(
                        keyboardType: TextInputType.url,
                        maxLength: 500,
                        decoration: const InputDecoration(
                          labelText: 'Profile Link',
                          hintText: 'Enter your profile link',
                          prefixIcon: Icon(Icons.link),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _additionalSocialMedia[index]['link'] =
                              value;
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),

            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _additionalSocialMedia.add({
                    'platform': '',
                    'link': '',
                  });
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Social Media'),
            ),

            const SizedBox(height: 16),

            // Languages: maximum 200 characters.
            TextFormField(
              controller: _languagesController,
              maxLines: 2,
              maxLength: 200,
              decoration: InputDecoration(
                label: RichText(
                  text: const TextSpan(
                    text: 'Languages ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                hintText: 'e.g. English, Swahili, French',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.translate),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
