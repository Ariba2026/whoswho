
import 'package:flutter/material.dart';

class SocialMediaWall extends StatelessWidget {
  const SocialMediaWall({super.key});

  static const Color navy = Color(0xFF17365D);
  static const Color pageBackground = Color(0xFFF3F5F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBanner(),
                    _buildFeatureBar(),
                    _buildMainArea(),
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

  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      color: navy,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 14,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _topNavItem(Icons.home_outlined, 'Home'),
                      const SizedBox(width: 16),
                      _topNavItem(Icons.work_outline, 'Jobs'),
                      const SizedBox(width: 16),
                      _topNavItem(
                        Icons.storefront_outlined,
                        'Buy & Sell',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: () {},
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  Widget _topNavItem(IconData icon, String label) {
    return InkWell(
      onTap: () {},
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

  // HORIZONTAL, SCROLLABLE FEATURE BAR
  Widget _buildFeatureBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Row(
          children: [
            _featureItem(
              Icons.handshake_outlined,
              'Ask for Partnership',
            ),
            _featureItem(
              Icons.groups_outlined,
              'Partners',
            ),
            _featureItem(
              Icons.notifications_outlined,
              'Notifications',
            ),
            _featureItem(
              Icons.person_outline,
              'My Profile',
            ),
            _featureItem(
              Icons.business_outlined,
              'Our Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 19),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: navy,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          side: const BorderSide(
            color: Color(0xFFD5DDE8),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // MAIN SOCIAL AREA
  Widget _buildMainArea() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _panel(
            title: 'Create a Post',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'What would you like to share?',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.send),
                    label: const Text('Post'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _panel(
            title: 'Social Feed',
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Posts from people and businesses '
                      'will appear here.',
                ),
                SizedBox(height: 12),
                Divider(),
                Text(
                  'Your feed is ready for future posts.',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _panel(
            title: 'Suggested People',
            child: const Text(
              'Suggested professionals will appear here.',
            ),
          ),
          const SizedBox(height: 16),
          _panel(
            title: 'Suggested Businesses',
            child: const Text(
              'Suggested businesses will appear here.',
            ),
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