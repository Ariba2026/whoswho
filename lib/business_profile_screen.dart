import 'package:flutter/material.dart';
import 'departments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'countries.dart';
import 'business_type.dart';

class BusinessProfileFormScreen extends StatefulWidget {
  const BusinessProfileFormScreen({super.key});

  @override
  State<BusinessProfileFormScreen> createState() =>
      _BusinessProfileFormScreenState();
}

class _BusinessProfileFormScreenState
    extends State<BusinessProfileFormScreen> {
  final TextEditingController _businessNameController =
  TextEditingController();
  final TextEditingController _telephoneController =
  TextEditingController();
  final TextEditingController _whatsAppController =
  TextEditingController();
  final TextEditingController _physicalAddressController =
  TextEditingController();
  final TextEditingController _countryCodeController =
  TextEditingController();
  final TextEditingController _emailController =
  TextEditingController();
  final TextEditingController _industryController =
  TextEditingController();
  final TextEditingController _aboutUsController =
  TextEditingController();
  final TextEditingController _servicesController =
  TextEditingController();
  final TextEditingController _websiteController =
  TextEditingController();
  final TextEditingController _languagesController =
  TextEditingController();

  String? _businessCategory;
  String? _availability;
  String _countryTelephoneCode = '';
  String _country = '';

  final List<Map<String, String>> _additionalCountries = [];

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
    _businessNameController.dispose();
    _telephoneController.dispose();
    _physicalAddressController.dispose();
    _countryCodeController.dispose();
    _emailController.dispose();
    _industryController.dispose();
    _aboutUsController.dispose();
    _servicesController.dispose();
    _websiteController.dispose();
    _languagesController.dispose();
    super.dispose();
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
      final profile = data?['businessProfile'];

      if (profile is Map<String, dynamic>) {
        _businessCategory = profile['businessCategory'];
        _businessNameController.text = profile['businessName'] ?? '';
        _industryController.text = profile['industry'] ?? '';
        _telephoneController.text = profile['telephone'] ?? '';
        _whatsAppController.text = profile['whatsApp']?.toString() ?? '';
        _physicalAddressController.text =
            profile['physicalAddress'] ?? '';
        _emailController.text = profile['email'] ?? '';

        _country = profile['country'] ?? '';

        _countryTelephoneCode = countryTelephoneCodes[_country] ?? '';
        _countryCodeController.text = _countryTelephoneCode;

        _servicesController.text = profile['services'] ?? '';
        _availability = profile['availability'];
        _languagesController.text = profile['languages'] ?? '';
        _aboutUsController.text = profile['aboutUs'] ?? '';
        _websiteController.text = profile['website'] ?? '';

        final additionalCountries =
        profile['additionalCountries'];

        if (additionalCountries is List) {
          _additionalCountries
            ..clear()
            ..addAll(
              additionalCountries.map(
                    (item) => Map<String, String>.from(item),
              ),
            );
        }

        final socialMedia = profile['socialMedia'];

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
      debugPrint('Failed to load business profile: $e');
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
          content: Text('Please sign in before saving your profile.'),
        ),
      );
      return;
    }

    if (_businessCategory == null ||
        _businessCategory!.trim().isEmpty ||
        _industryController.text.trim().isEmpty ||
        _businessNameController.text.trim().isEmpty ||
        _country.trim().isEmpty ||
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
      'businessCategory': _businessCategory,
      'industry': _industryController.text.trim(),
      'businessName': _businessNameController.text.trim(),
      'country': _country,
      'telephone': _telephoneController.text.trim(),
      'whatsApp': _whatsAppController.text.trim(),
      'physicalAddress': _physicalAddressController.text.trim(),
      'email': _emailController.text.trim(),
      'services': _servicesController.text.trim(),
      'availability': _availability,
      'languages': _languagesController.text.trim(),
      'aboutUs': _aboutUsController.text.trim(),
      'website': _websiteController.text.trim(),
      'additionalCountries': _additionalCountries,
      'socialMedia': _socialMedia,
      'additionalSocialMedia': _additionalSocialMedia,
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'businessProfile': profileData,
      }, SetOptions(merge: true));
      await FirebaseFirestore.instance
          .collection('publicProfiles')
          .doc(user.uid)
          .set({
        'accountType': 'Business',
        'fullName': profileData['businessName'],
        'businessProfile': profileData,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Business profile saved successfully.'),
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
        title: const Text('Business Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Business Information',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Complete your business profile so people can discover your business and services.',
            ),

            const SizedBox(height: 24),

            // BUSINESS CATEGORY
            DropdownButtonFormField<String>(
              value: _businessCategory,
              decoration: InputDecoration(
                label: RichText(
                  text: const TextSpan(
                    text: 'Business Category ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                prefixIcon: const Icon(Icons.business_outlined),
                border: const OutlineInputBorder(),
              ),
              items: businessTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _businessCategory = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // INDUSTRY
            Autocomplete<String>(
              initialValue: TextEditingValue(
                text: _industryController.text,
              ),
              optionsBuilder:
                  (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return departments;
                }

                return departments.where(
                      (industry) =>
                      industry.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      ),
                );
              },
              onSelected: (String selection) {
                _industryController.text = selection;
              },
              fieldViewBuilder: (
                  BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted,
                  ) {
                if (textEditingController.text !=
                    _industryController.text) {
                  textEditingController.text =
                      _industryController.text;
                }

                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onChanged: (value) {
                    _industryController.text = value;
                  },
                  decoration: InputDecoration(
                    label: RichText(
                      text: const TextSpan(
                        text: 'Industry ',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    hintText: 'Type to search industry',
                    prefixIcon:
                    const Icon(Icons.account_tree_outlined),
                    border: const OutlineInputBorder(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // BUSINESS NAME
            TextFormField(
              controller: _businessNameController,
              maxLength: 150,
              decoration: InputDecoration(
                label: RichText(
                  text: const TextSpan(
                    text: 'Business Name ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                hintText: 'Enter your business name',
                prefixIcon: const Icon(Icons.business),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // COUNTRY
            Autocomplete<String>(
              initialValue: TextEditingValue(
                text: _country,
              ),
              optionsBuilder:
                  (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return countries;
                }

                return countries.where(
                      (country) =>
                      country.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      ),
                );
              },
              onSelected: (String selection) {
                setState(() {
                  _country = selection;

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
                if (textEditingController.text != _country) {
                  textEditingController.text = _country;
                }

                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onChanged: (value) {
                    _country = value;
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
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    hintText: 'Type to search country',
                    prefixIcon: const Icon(Icons.public),
                    border: const OutlineInputBorder(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // TELEPHONE
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
                    maxLength: 20,
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

            // PHYSICAL ADDRESS
            TextFormField(
              controller: _physicalAddressController,
              maxLength: 300,
              maxLines: 3,
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

            // EMAIL
            TextFormField(
              controller: _emailController,
              maxLength: 254,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email (optional)',
                hintText: 'e.g. business@example.com',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // OUR SERVICES
            TextFormField(
              controller: _servicesController,
              maxLength: 1000,
              maxLines: 5,
              decoration: InputDecoration(
                label: RichText(
                  text: const TextSpan(
                    text: 'Our Services ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                hintText:
                'Describe the services your business provides',
                alignLabelWithHint: true,
                prefixIcon:
                const Icon(Icons.design_services_outlined),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // AVAILABILITY
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
                        style: TextStyle(
                          color: Colors.red,
                        ),
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

            // LANGUAGES
            TextFormField(
              controller: _languagesController,
              maxLength: 50,
              maxLines: 2,
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
                        style: TextStyle(
                          color: Colors.red,
                        ),
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

            const SizedBox(height: 16),

            // ABOUT US
            TextFormField(
              controller: _aboutUsController,
              maxLength: 1000,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'About Us (optional)',
                hintText:
                'Tell us about your business, background, experience, and what your business offers.',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.business_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // WEBSITE
            TextFormField(
              controller: _websiteController,
              maxLength: 300,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Website (optional)',
                hintText: 'e.g. https://example.com',
                prefixIcon: Icon(Icons.language),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // ADDITIONAL COUNTRIES / BRANCHES
            const Text(
              'Branches in Other Countries',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Add countries where your business has branches or operates.',
            ),

            const SizedBox(height: 12),

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
                label: const Text('Add Country / Branch'),
              ),
            ),

            ..._additionalCountries.asMap().entries.map((entry) {
              final index = entry.key;

              return Card(
                margin: const EdgeInsets.only(top: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Autocomplete<String>(
                        initialValue: TextEditingValue(
                          text: _additionalCountries[index]
                          ['country'] ??
                              '',
                        ),
                        optionsBuilder:
                            (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return countries;
                          }

                          return countries.where(
                                (country) =>
                                country.toLowerCase().contains(
                                  textEditingValue.text
                                      .toLowerCase(),
                                ),
                          );
                        },
                        onSelected: (String selection) {
                          setState(() {
                            _additionalCountries[index]
                            ['country'] = selection;
                          });
                        },
                        fieldViewBuilder: (
                            BuildContext context,
                            TextEditingController
                            textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted,
                            ) {
                          return TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            onChanged: (value) {
                              _additionalCountries[index]
                              ['country'] = value;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Country',
                              hintText:
                              'Type to search country',
                              prefixIcon:
                              Icon(Icons.public),
                              border: OutlineInputBorder(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 85,
                            child: TextFormField(
                              readOnly: true,
                              controller:
                              TextEditingController(
                                text: countryTelephoneCodes[
                                _additionalCountries[index]
                                ['country']] ??
                                    '',
                              ),
                              decoration:
                              const InputDecoration(
                                labelText: 'Code',
                                border:
                                OutlineInputBorder(),
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
                              maxLength: 20,
                              keyboardType:
                              TextInputType.phone,
                              onChanged: (value) {
                                _additionalCountries[index]
                                ['telephone'] = value;
                              },
                              decoration:
                              const InputDecoration(
                                labelText:
                                'Telephone (optional)',
                                hintText:
                                'e.g. 712 345 678',
                                prefixIcon:
                                Icon(Icons.phone),
                                border:
                                OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      TextFormField(
                        initialValue:
                        _additionalCountries[index]['city'] ??
                            '',
                        maxLength: 300,
                        maxLines: 2,
                        onChanged: (value) {
                          _additionalCountries[index]['city'] =
                              value;
                        },
                        decoration: const InputDecoration(
                          labelText:
                          'Physical Address (optional)',
                          hintText:
                          'City, town, street, estate, building, village, etc.',
                          prefixIcon:
                          Icon(Icons.location_city),
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 28),

            // SOCIAL MEDIA
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _showSocialMedia = !_showSocialMedia;
                });
              },
              icon: Icon(
                _showSocialMedia
                    ? Icons.remove
                    : Icons.add,
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
                  padding:
                  const EdgeInsets.only(bottom: 12),
                  child: TextFormField(
                    initialValue:
                    _socialMedia[platform] ?? '',
                    maxLength: 300,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      labelText: '$platform (Optional)',
                      hintText:
                      'Enter your $platform business link',
                      prefixIcon:
                      const Icon(Icons.link),
                      border:
                      const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _socialMedia[platform] = value;
                    },
                  ),
                );
              }),

              const SizedBox(height: 4),

              ..._additionalSocialMedia
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key;

                return Card(
                  margin:
                  const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding:
                    const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        TextField(
                          maxLength: 50,
                          decoration:
                          const InputDecoration(
                            labelText: 'Platform',
                            hintText:
                            'e.g. Threads, Pinterest, Telegram',
                            prefixIcon:
                            Icon(Icons.public),
                            border:
                            OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            _additionalSocialMedia[
                            index]['platform'] =
                                value;
                          },
                        ),

                        const SizedBox(height: 12),

                        TextField(
                          maxLength: 300,
                          keyboardType:
                          TextInputType.url,
                          decoration:
                          const InputDecoration(
                            labelText:
                            'Profile Link',
                            hintText:
                            'Enter your business profile link',
                            prefixIcon:
                            Icon(Icons.link),
                            border:
                            OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            _additionalSocialMedia[
                            index]['link'] =
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
                label:
                const Text('Add Social Media'),
              ),
            ],

            const SizedBox(height: 32),

            // SAVE
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