import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const WhosWhoApp());
}

class WhosWhoApp extends StatelessWidget {
  const WhosWhoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhosWho',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
        ),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 25),

              // App logo
              Center(
                child: Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.people_alt_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'WhosWho',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Discover People. Find Services. Connect.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 38),

              // Search box
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search people or services',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.clear,
                      size: 24,
                    ),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Browse Directory
              SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DirectoryScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.explore_outlined),
                  label: const Text(
                    'Browse Directory',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Divider(),

              const SizedBox(height: 20),

              const Text(
                'Are you already a member?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(
                    color: Color(0xFF1565C0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {},
                child: const Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Find professionals and service providers around you '
                'or anywhere in the world.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black45,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class DirectoryScreen extends StatelessWidget {
  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhosWho Directory'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Find People & Services',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Discover professionals, service providers and businesses.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            decoration: InputDecoration(
              hintText: 'Search the directory',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Browse Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _categoryCard(
            icon: Icons.work_outline,
            title: 'Professionals',
            subtitle: 'Find qualified professionals',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfessionalsDirectoryScreen(),
                ),
              );
            },
          ),

          _categoryCard(
            icon: Icons.business_outlined,
            title: 'Businesses',
            subtitle: 'Discover businesses and organizations',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Businesses selected'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _categoryCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE3F2FD),
          child: Icon(
            icon,
            color: const Color(0xFF1565C0),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

class Professional {
  final String id;
  final String email;
  final String name;
  final String profession;
  final List<String> skills;
  final List<String> services;
  final String country;
  final String region;
  final String city;
  final String availability;
  final String phone;
  final double rating;
  final int reviewCount;

  const Professional({
    required this.id,
    required this.email,
    required this.name,
    required this.profession,
    required this.skills,
    required this.services,
    required this.country,
    required this.region,
    required this.city,
    required this.availability,
    required this.phone,
    required this.rating,
    required this.reviewCount,
  });
}

const List<Professional> sampleProfessionals = [
  Professional(
    id: 'john_otieno',
    email: 'john@example.com',
    name: 'John Otieno',
    profession: 'Writer',
    skills: [
      'Writing',
      'Editing',
      'Content Creation',
    ],
    services: [
      'Article Writing',
      'Book Writing',
      'Editing Services',
      'Website Content',
    ],
    country: 'Kenya',
    region: 'Siaya',
    city: 'Siaya',
    availability: 'Remote',
    phone: '+254700000001',
    rating: 4.8,
    reviewCount: 0,
  ),

  Professional(
    id: 'mary_achieng',
    email: 'mary@example.com',
    name: 'Mary Achieng',
    profession: 'Graphic Designer',
    skills: [
      'Graphic Design',
      'Branding',
      'Illustration',
    ],
    services: [
      'Article Writing',
      'Book Writing',
      'Editing Services',
      'Website Content',
    ],
    country: 'Kenya',
    region: 'Nairobi',
    city: 'Nairobi',
    availability: 'On-site',
    phone: '+254700000002',
    rating: 4.6,
    reviewCount: 0,
  ),

  Professional(
    id: 'david_okello',
    email: 'david@example.com',
    name: 'David Okello',
    profession: 'Web Developer',
    skills: [
      'Flutter',
      'Web Development',
      'Mobile Apps',
    ],
    services: [
      'Article Writing',
      'Book Writing',
      'Editing Services',
      'Website Content',
    ],
    country: 'Uganda',
    region: 'Kampala',
    city: 'Kampala',
    availability: 'Remote',
    phone: '+256700000003',
    rating: 4.9,
    reviewCount: 0,
  ),
];

class ProfessionalsDirectoryScreen extends StatefulWidget {
  const ProfessionalsDirectoryScreen({super.key});

  @override
  State<ProfessionalsDirectoryScreen> createState() =>
      _ProfessionalsDirectoryScreenState();
}

class _ProfessionalsDirectoryScreenState
    extends State<ProfessionalsDirectoryScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  List<Professional> searchResults = [];

  bool hasSearched = false;

  void _searchProfessionals() {
    final searchText = searchController.text.trim().toLowerCase();
    final locationText = locationController.text.trim().toLowerCase();

    final results = sampleProfessionals.where((professional) {
      final professionalMatches = searchText.isEmpty ||
          professional.name.toLowerCase().contains(searchText) ||
          professional.profession.toLowerCase().contains(searchText) ||
          professional.skills.any(
                (skill) => skill.toLowerCase().contains(searchText),
          ) ||
      professional.services.any(
      (service) => service.toLowerCase().contains(searchText),
      );

      final locationMatches = locationText.isEmpty ||
          professional.country.toLowerCase().contains(locationText) ||
          professional.region.toLowerCase().contains(locationText) ||
          professional.city.toLowerCase().contains(locationText);

      return professionalMatches && locationMatches;
    }).toList();

    setState(() {
      searchResults = results;
      hasSearched = true;
    });
  }

  Widget _buildProfessionalCard(Professional professional) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProfessionalProfileScreen(
                    professional: professional,
                  ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                professional.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                professional.profession,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 8),

              if (professional.reviewCount == 0)
                const Text(
                  'No reviews yet',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star,
                      size: 22,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${professional.rating.toStringAsFixed(1)} '
                          '(${professional.reviewCount} reviews)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${professional.country} · '
                          '${professional.region} · '
                          '${professional.city}',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                'Skills: ${professional.skills.join(', ')}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),

              if (professional.availability == 'Remote') ...[
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(
                      Icons.public,
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text('Availability: Remote'),
                  ],
                ),
              ] else if (professional.availability == 'On-site') ...[
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text('Availability: On-site'),
                  ],
                ),
              ],

              const SizedBox(height: 12),

              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'View Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professionals'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Find Qualified Professionals',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Browse professionals and discover people with the skills and expertise you need.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 20),

          // Professional / Service Search
          TextField(
            controller: searchController,
            onChanged: (value) {
              _searchProfessionals();
            },
            decoration: InputDecoration(
              hintText: 'Search professionals, skills or services',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Location Search
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: locationController,
            decoration: InputDecoration(
              hintText: 'Search country, county, city or town',
              prefixIcon: const Icon(Icons.location_on_outlined),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  locationController.clear();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Search Button
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _searchProfessionals,
              icon: const Icon(Icons.search),
              label: const Text(
                'Find Professionals',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Results area
          const Text(
            'Professionals',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          if (!hasSearched)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 48,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Search for a professional, skill or service.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          else
            if (searchResults.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 48,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No professionals found.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Try changing your search or location.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...searchResults.map(
                    (professional) => _buildProfessionalCard(professional),
              ),
        ],
      ),
    );
  }
}

class ProfessionalProfileScreen extends StatefulWidget {
  final Professional professional;

  const ProfessionalProfileScreen({
    super.key,
    required this.professional,
  });

  @override
  State<ProfessionalProfileScreen> createState() =>
      _ProfessionalProfileScreenState();
}

class _ProfessionalProfileScreenState
    extends State<ProfessionalProfileScreen> {
  bool isFavourite = false;

  void _toggleFavourite() {
    setState(() {
      isFavourite = !isFavourite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavourite
              ? 'Professional added to favourites.'
              : 'Professional removed from favourites.',
        ),
      ),
    );
  }

  void _contactProfessional() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Call Professional'),
                onTap: () async {
                  Navigator.pop(context);

                  final Uri phoneUri = Uri(
                    scheme: 'tel',
                    path: widget.professional.phone,
                  );

                  try {
                    await launchUrl(phoneUri);
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Unable to open the phone dialer.',
                        ),
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.message),
                title: const Text('Send Message'),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessageProfessionalScreen(
                        professional: widget.professional,
                      ),
                    ),
                  );
                },
              ),
ListTile(
leading: const Icon(Icons.email),
title: const Text('Send Email'),
onTap: () async {
Navigator.pop(context);

final Uri emailUri = Uri(
scheme: 'mailto',
path: widget.professional.email,
);

try {
await launchUrl(emailUri);
} catch (e) {
if (!context.mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
'Unable to open the email app.',
),
),
);
}
},
),
            ],
          ),
        );
      },
    );
  }

  void _reportProfessional() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Report Professional'),
          content: Text(
            'Are you sure you want to report ${widget.professional.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Report submitted. Thank you for helping keep WhosWho safe.',
                    ),
                  ),
                );
              },
              child: const Text('Report'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final professional = widget.professional;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Professional Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 45,
            child: Icon(
              Icons.person,
              size: 50,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            professional.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            professional.profession,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 20),

          // Favourite button
          SizedBox(
            height: 50,
            child: OutlinedButton.icon(
              onPressed: _toggleFavourite,
              icon: Icon(
                isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              label: Text(
                isFavourite
                    ? 'Favourited'
                    : 'Add to Favourites',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Contact button
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _contactProfessional,
              icon: const Icon(Icons.contact_phone),
              label: const Text(
                'Contact Professional',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          // Send Email button

          const SizedBox(height: 12),


          // Report button
          SizedBox(
            height: 50,
            child: OutlinedButton.icon(
              onPressed: _reportProfessional,
              icon: const Icon(Icons.flag_outlined),
              label: const Text(
                'Report Professional',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Divider(),

          const SizedBox(height: 16),

          const Text(
            'Location',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.location_on_outlined),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${professional.country} · '
                      '${professional.region} · '
                      '${professional.city}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            'Skills',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: professional.skills
                .map(
                  (skill) => Chip(
                label: Text(skill),
              ),
            )
                .toList(),
          ),

          const SizedBox(height: 24),

          const Text(
            'Services',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: professional.services
                .map(
                  (service) => Chip(
                label: Text(service),
              ),
            )
                .toList(),
          ),

          const SizedBox(height: 24),

          if (professional.availability == 'Remote') ...[
            const Text(
              'Availability',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Row(
              children: [
                Icon(Icons.public),
                SizedBox(width: 8),
                Text(
                  'Available for remote work',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],

          const Text(
            'About',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '${professional.name} is a ${professional.profession.toLowerCase()} '
                'with skills in ${professional.skills.join(', ')}.',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Reviews',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'No written reviews yet.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 28),
        ],
      ),
    );
  }
}


class MessageProfessionalScreen extends StatefulWidget {
  final Professional professional;

  const MessageProfessionalScreen({
    super.key,
    required this.professional,
  });

  @override
  State<MessageProfessionalScreen> createState() =>
      _MessageProfessionalScreenState();
}

class _MessageProfessionalScreenState
    extends State<MessageProfessionalScreen> {
  final TextEditingController _messageController =
  TextEditingController();

  void _sendMessage() {
    final message = _messageController.text.trim();

    if (message.isEmpty) {
      return;
    }

    _messageController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message sent.'),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message ${widget.professional.name}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Start a conversation with ${widget.professional.name}.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Write a message...',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                  tooltip: 'Send',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}