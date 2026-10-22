
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'business_profile_screen.dart';
import 'professional_profile_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';
import 'advertising_screen.dart';
import 'directory_models.dart';

class SocialMediaWall extends StatelessWidget {
  final void Function(Professional professional)? onProfessionalTap;
  final void Function(Business business)? onBusinessTap;

  const SocialMediaWall({
    super.key,
    this.onProfessionalTap,
    this.onBusinessTap,
  });

  static const Color navy = Color(0xFF17365D);
  static const Color pageBackground = Color(0xFFF3F5F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBanner(),
                    _buildProfileReminder(context),
                    _buildMainArea(context)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TOP NAVIGATION BAR
  Widget _buildTopBar(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      width: double.infinity,
      color: navy,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _topNavItem(
                    Icons.home_outlined,
                    'Home',
                    onTap: () {},
                  ),
                  const SizedBox(width: 16),

                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: user == null
                        ? null
                        : FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final data = snapshot.data?.data() ?? {};

                      final accountType = data['accountType']
                          ?.toString()
                          .trim()
                          .toLowerCase();

                      final profileTitle = accountType == 'business'
                          ? 'Our Profile'
                          : 'My Profile';

                      return _topNavItem(
                        Icons.person_outline,
                        profileTitle,
                        onTap: () async {
                          final currentUser =
                              FirebaseAuth.instance.currentUser;

                          if (currentUser == null) return;

                          final userDoc = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(currentUser.uid)
                              .get();

                          if (!context.mounted) return;

                          final type = userDoc.data()?['accountType']
                              ?.toString()
                              .trim()
                              .toLowerCase();

                          if (type == 'business') {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const BusinessProfileFormScreen(),
                              ),
                            );
                          } else {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const ProfessionalProfileFormScreen(),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(width: 16),

                  _topNavItem(
                    Icons.notifications_outlined,
                    'Notifications',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          PopupMenuButton<String>(
            tooltip: 'Settings and Sign Out',
            onSelected: (value) async {
              if (value == 'settings') {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              } else if (value == 'signout') {
                await FirebaseAuth.instance.signOut();

                if (!context.mounted) return;

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                      (route) => false,
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 10),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'signout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 10),
                    Text('Sign Out'),
                  ],
                ),
              ),
            ],
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _topNavItem(IconData icon,
      String label, {
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // BANNER — NO PROFILE PHOTO
  Widget _buildBanner() {
    return Container(
      height: 230,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF493022),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circle containing two heads and the question mark.
          Container(
            width: 174,
            height: 174,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.75),
              border: Border.all(
                color: const Color(0xFFCBD5E1),
                width: 2,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: _humanHead(
                        const Color(0xFF2878C8),
                      ),
                    ),
                    Flexible(
                      child: _humanHead(
                        const Color(0xFFDE4B83),
                      ),
                    ),
                  ],
                ),

                // Question mark between the two heads.
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '?',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF6C3CC5),
                    ),
                  ),
                ),
              ],
            ),
          ),


          // WhosWho title sits in front of the heads.
          Positioned(
            bottom: 48,
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                  shadows: [
                    Shadow(
                      color: Colors.white,
                      blurRadius: 5,
                    ),
                  ],
                ),
                children: [
                  TextSpan(
                    text: 'Whos',
                    style: TextStyle(
                      color: Color(0xFF1769AA),
                    ),
                  ),
                  TextSpan(
                    text: 'Who',
                    style: TextStyle(
                      color: Color(0xFFD93678),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // White italic headline below WhosWho.
          Positioned(
            bottom: 5,
            left: 8,
            right: 8,
            child: const Text(
              'Find Professionals, Find Services',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Simple illustrative human-head icon.
  Widget _humanHead(Color color) {
    return Icon(
      Icons.person,
      size: 100,
      color: color,
    );
  }


  // PROFILE COMPLETION REMINDER

  Widget _buildProfileReminder(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() ?? {};
        final accountType = data['accountType'];

        final isBusiness =
            accountType == 'business' || accountType == 'Business';

        final profile = isBusiness
            ? data['businessProfile']
            : data['professionalProfile'];

        if (profile != null || !snapshot.hasData) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          color: const Color(0xFFF5F7FA),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: 18,
                color: Color(0xFF2878C8),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBusiness
                          ? 'Complete your profile so people can discover you and learn about your services.'
                          : 'Complete your profile so people can discover you, your skills and your services.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () async {
                        if (isBusiness) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const BusinessProfileFormScreen(),
                            ),
                          );
                        } else {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const ProfessionalProfileFormScreen(),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Complete your profile →',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2878C8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _suggestionText(Map<String, dynamic> data, String key,
      [String fallback = '']) {
    final value = data[key];
    if (value == null) return fallback;
    return value.toString().trim().isEmpty ? fallback : value.toString().trim();
  }

  List<String> _suggestionList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    if (value is String && value.trim().isNotEmpty) {
      return value
          .split(RegExp(r'[,;\n]'))
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return [];
  }

  Widget _buildSuggestedPeople() {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('publicProfiles')
          .where('accountType', isEqualTo: 'Professional')
          .limit(5)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Text('Unable to load suggested people.');
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Text('No professionals to suggest yet.');
        }

        return Column(
          children: docs.map((doc) {
            final data = doc.data();
            final profile = Map<String, dynamic>.from(
              data['professionalProfile'] as Map? ?? {},
            );
            final professions = _suggestionList(profile['professions']);
            final professional = Professional(
              id: doc.id,
              email: _suggestionText(profile, 'email',
                  _suggestionText(data, 'email')),
              name: _suggestionText(profile, 'fullName',
                  _suggestionText(data, 'fullName', 'Professional')),
              profession: professions.isNotEmpty
                  ? professions.first
                  : _suggestionText(profile, 'profession'),
              skills: _suggestionList(profile['skills']),
              services: _suggestionList(profile['services']),
              country: _suggestionText(profile, 'country'),
              region: _suggestionText(profile, 'region'),
              city: _suggestionText(profile, 'city'),
              address: _suggestionText(profile, 'physicalAddress',
                  _suggestionText(profile, 'address')),
              availability: _suggestionText(profile, 'availability'),
              phone: _suggestionText(profile, 'phone'),
              whatsApp: _suggestionText(profile, 'whatsapp'),
            );

            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(professional.name),
              subtitle: Text(
                professional.profession.isNotEmpty
                    ? professional.profession
                    : 'Professional',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => onProfessionalTap?.call(professional),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSuggestedBusinesses() {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('publicProfiles')
          .where('accountType', isEqualTo: 'Business')
          .limit(5)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Text('Unable to load suggested businesses.');
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Text('No businesses to suggest yet.');
        }

        return Column(
          children: docs.map((doc) {
            final data = doc.data();
            final profile = Map<String, dynamic>.from(
              data['businessProfile'] as Map? ?? {},
            );
            final business = Business(
              id: doc.id,
              email: _suggestionText(profile, 'email',
                  _suggestionText(data, 'email')),
              name: _suggestionText(profile, 'businessName',
                  _suggestionText(data, 'fullName', 'Business')),
              category: _suggestionText(profile, 'businessCategory',
                  _suggestionText(profile, 'category')),
              industry: _suggestionText(profile, 'industry'),
              businessType: _suggestionText(profile, 'businessType'),
              services: _suggestionList(profile['services']),
              country: _suggestionText(profile, 'country'),
              region: _suggestionText(profile, 'region'),
              city: _suggestionText(profile, 'city'),
              address: _suggestionText(profile, 'physicalAddress',
                  _suggestionText(profile, 'address')),
              availability: _suggestionText(profile, 'availability'),
              phone: _suggestionText(profile, 'phone'),
              whatsApp: _suggestionText(profile, 'whatsapp'),
              languages: _suggestionText(profile, 'languages'),
              departments: _suggestionText(profile, 'departments'),
              aboutUs: _suggestionText(profile, 'aboutUs'),
              website: _suggestionText(profile, 'website'),
              otherDetails: _suggestionText(profile, 'otherDetails'),
            );

            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.business),
              ),
              title: Text(business.name),
              subtitle: Text(
                business.category.isNotEmpty
                    ? business.category
                    : 'Business',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => onBusinessTap?.call(business),
            );
          }).toList(),
        );
      },
    );
  }

  // MAIN SOCIAL AREA
  Widget _buildMainArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          _panel(
            title: 'Sponsored Advertisements',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // FEATURED SPONSORED ADVERT
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5EEE8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF493022),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.campaign,
                            color: Color(0xFF493022),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'FEATURED SPONSORED ADVERT',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF493022),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3D5C9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.apartment,
                          size: 64,
                          color: Color(0xFF493022),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Domajents Consultancy',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('Building & Construction'),
                      const SizedBox(height: 8),
                      const Text(
                        'Explore building and construction services '
                            'for your next project.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // SCROLLING SPONSORED ADVERTS
                const Text(
                  'More Sponsored Adverts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildPlaceholderAdvert(
                        context,
                        company: 'GreenNest Home Solutions',
                        category: 'Home & Cleaning Services',
                        description:
                        'Home care and cleaning services for '
                            'homes and businesses.',
                        icon: Icons.cleaning_services,
                      ),
                      _buildPlaceholderAdvert(
                        context,
                        company: 'BrightPath Digital Hub',
                        category: 'Digital & Technology Services',
                        description:
                        'Discover digital solutions for your '
                            'business and professional needs.',
                        icon: Icons.devices,
                      ),
                      _buildPlaceholderAdvert(
                        context,
                        company: 'Celebration Point Events',
                        category: 'Events & Hospitality',
                        description:
                        'Services to help make your special '
                            'events memorable.',
                        icon: Icons.celebration,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AdvertisingScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.campaign),
                    label: const Text('Advertise with us'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF493022),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          _panel(
            title: 'Suggested People',
            child: _buildSuggestedPeople(),
          ),
          const SizedBox(height: 16),
          _panel(
            title: 'Suggested Businesses',
            child: _buildSuggestedBusinesses(),
          ),
        ],
      ),
    );
  }


  Widget _buildPlaceholderAdvert(BuildContext context, {
    required String company,
    required String category,
    required String description,
    required IconData icon,
  }) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SPONSORED',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF493022),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 45,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF5EEE8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 38,
              color: const Color(0xFF493022),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            company,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }


  // REUSABLE WHITE PANEL
  Widget _panel({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE3E7ED),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: navy,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
