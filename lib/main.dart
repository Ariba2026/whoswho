import 'package:flutter/material.dart';
import 'professional_profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'business_profile_screen.dart';
import 'social_media_wall.dart';
import 'sign_in_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: const AuthGate(),
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

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                  );
                },
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateAccountScreen(),
                ),
              );
            },
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BusinessesDirectoryScreen(),
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
  final String address;
  final String availability;
  final String phone;
  final String whatsApp;

  final List<String> positions;
  final String yearsOfExperience;
  final String aboutMe;
  final String education;
  final String certifications;
  final String website;

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
    this.address = '',
    required this.availability,
    required this.phone,
    this.whatsApp = '',
    this.positions = const [],
    this.yearsOfExperience = '',
    this.aboutMe = '',
    this.education = '',
    this.certifications = '',
    this.website = '',
  });
}

class Business {
  final String id;
  final String email;
  final String name;
  final String category;
  final String industry;
  final String businessType;
  final List<String> services;
  final String country;
  final String region;
  final String city;
  final String address;
  final String availability;
  final String phone;
  final String whatsApp;
  final String languages;
  final String departments;
  final String aboutUs;
  final String website;
  final String socialMedia;
  final String otherDetails;

  const Business({
    required this.id,
    required this.email,
    required this.name,
    required this.category,
    this.industry = '',
    this.businessType = '',
    required this.services,
    required this.country,
    required this.region,
    required this.city,
    this.address = '',
    required this.availability,
    required this.phone,
    this.whatsApp = '',
    this.languages = '',
    this.departments = '',
    this.aboutUs = '',
    this.website = '',
    this.socialMedia = '',
    this.otherDetails = '',
  });
}

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
  bool _isLoading = false;
  String? _loadError;
  List<Professional> _allProfessionals = [];

  bool hasSearched = false;
  @override
  void initState() {
    super.initState();
    _loadProfessionals();
  }

  Future<void> _loadProfessionals() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('publicProfiles')
          .where('accountType', isEqualTo: 'Professional')
          .get();

      final professionals = snapshot.docs.map((doc) {
        final data = doc.data();
        final rawProfile = data['professionalProfile'];

        final Map<String, dynamic> profile =
        rawProfile is Map<String, dynamic>
            ? rawProfile
            : <String, dynamic>{};

        String readText(dynamic value) {
          return value == null ? '' : value.toString().trim();
        }

        List<String> readList(dynamic value) {
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

        final professions = readList(profile['professions']);
        final profileName = readText(profile['fullName']);

        return Professional(
          id: doc.id,
          email: readText(profile['email']),
          name: profileName.isNotEmpty
              ? profileName
              : readText(data['fullName']),
          profession: professions.isNotEmpty
              ? professions.first
              : 'Professional',
          skills: readList(profile['skills']),
          services: readList(profile['services']),
          country: readText(profile['country']),
          region: readText(profile['region']),
          city: readText(profile['city']),
          availability: readText(profile['availability']),
          phone: readText(profile['telephone']),
          whatsApp: readText(profile['whatsApp']),
          positions: (profile['positions'] as List?)
              ?.map((item) {
            if (item is Map) {
              final title = (item['position'] ?? '').toString().trim();
              final organization =
              (item['organization'] ?? '').toString().trim();

              if (title.isEmpty) return '';
              return organization.isEmpty
                  ? title
                  : '$title\n$organization';
            }
            return item.toString().trim();
          })
              .where((item) => item.isNotEmpty)
              .toList() ??
              [],
          yearsOfExperience: readText(profile['yearsOfExperience']),
          aboutMe: readText(profile['aboutMe']),
          education: readText(profile['education']),
          certifications: readText(profile['certifications']),
          website: readText(profile['website']),
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        _allProfessionals = professionals;
        searchResults = professionals;
        hasSearched = true;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loadError = 'Could not load professionals: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  void _searchProfessionals() {
    final searchText = searchController.text.trim().toLowerCase();
    final locationText = locationController.text.trim().toLowerCase();

    final results = _allProfessionals.where((professional) {
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


          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (_loadError != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _loadError!,
                style: const TextStyle(color: Colors.red),
              ),
            )
          else if (!hasSearched)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.people_outline, size: 48),
                    SizedBox(height: 10),
                    Text(
                      'Search for a professional, skill or service.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )
            else if (searchResults.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.search_off, size: 48),
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

class BusinessesDirectoryScreen extends StatefulWidget {
  const BusinessesDirectoryScreen({super.key});

  @override
  State<BusinessesDirectoryScreen> createState() =>
      _BusinessesDirectoryScreenState();
}

class _BusinessesDirectoryScreenState
    extends State<BusinessesDirectoryScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  List<Business> searchResults = [];

  bool hasSearched = false;
  bool _isLoading = false;
  String? _loadError;

  Future<void> _searchBusinesses() async {
    final searchText = searchController.text.trim().toLowerCase();
    final locationText = locationController.text.trim().toLowerCase();

    setState(() {
      _isLoading = true;
      _loadError = null;
      hasSearched = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('publicProfiles')
          .where('accountType', isEqualTo: 'Business')
          .get();

      final results = snapshot.docs
          .map((doc) {
        final data = doc.data();
        final profile = Map<String, dynamic>.from(
          data['businessProfile'] ?? {},
        );

        return Business(
          id: doc.id,
          email: profile['email']?.toString() ?? '',
          name: profile['businessName']?.toString() ??
              data['fullName']?.toString() ??
              '',
          category: profile['businessCategory']?.toString() ??
              profile['category']?.toString() ??
              '',
          services: (profile['services'] ?? '')
              .toString()
              .split(RegExp(r'[,;\n]'))
              .map((service) => service.trim())
              .where((service) => service.isNotEmpty)
              .toList(),
          country: profile['country']?.toString() ?? '',
          region: profile['region']?.toString() ?? '',
          city: profile['city']?.toString() ?? '',
          address: profile['physicalAddress']?.toString() ?? '',
          availability: profile['availability']?.toString() ?? '',
          phone: profile['telephone']?.toString() ?? '',
          industry: profile['industry']?.toString() ?? '',
          businessType: profile['businessType']?.toString() ?? '',
          whatsApp: profile['whatsApp']?.toString() ?? '',
          languages: profile['languages']?.toString() ?? '',
          departments: profile['departments']?.toString() ?? '',
          aboutUs: profile['aboutUs']?.toString() ?? '',
          website: profile['website']?.toString() ?? '',
        );
      })
          .where((business) {
        final businessMatches = searchText.isEmpty ||
            business.name.toLowerCase().contains(searchText) ||
            business.category.toLowerCase().contains(searchText) ||
            business.services.any(
                  (service) => service.toLowerCase().contains(searchText),
            );

        final locationMatches = locationText.isEmpty ||
            business.country.toLowerCase().contains(locationText) ||
            business.region.toLowerCase().contains(locationText) ||
            business.city.toLowerCase().contains(locationText);

        return businessMatches && locationMatches;
      })
          .toList();

      if (!mounted) return;

      setState(() {
        searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _loadError = 'Unable to load businesses. Please try again.';
      });
    }
  }

  Widget _buildBusinessCard(Business business) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BusinessProfileScreen(
                    business: business,
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
                business.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                business.category,
                style: const TextStyle(
                  fontSize: 16,
                ),
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
                      '${business.country} · '
                          '${business.region} · '
                          '${business.city}',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                'Services: ${business.services.join(', ')}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Icon(
                    business.availability == 'Remote'
                        ? Icons.public
                        : Icons.location_on,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Availability: ${business.availability}',
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'View Business',
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
        title: const Text('Businesses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search businesses, category or services',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _searchBusinesses(),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Country, region or city',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _searchBusinesses(),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _searchBusinesses,
                icon: const Icon(Icons.search),
                label: const Text('Search Businesses'),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: hasSearched
                  ? searchResults.isEmpty
                  ? const Center(
                child: Text(
                  'No businesses found.',
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return _buildBusinessCard(
                    searchResults[index],
                  );
                },
              )
                  : const Center(
                child: Text(
                  'Search for a business, category or service.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BusinessProfileScreen extends StatefulWidget {
  final Business business;

  const BusinessProfileScreen({
    super.key,
    required this.business,
  });

  @override
  State<BusinessProfileScreen> createState() =>
      _BusinessProfileScreenState();
}

class _BusinessProfileScreenState
    extends State<BusinessProfileScreen> {
  bool isFavourite = false;

  void _toggleFavourite() {
    setState(() {
      isFavourite = !isFavourite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavourite
              ? 'Business added to favourites.'
              : 'Business removed from favourites.',
        ),
      ),
    );
  }


  void _contactBusiness() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Call Business'),
                onTap: () async {
                  Navigator.pop(context);

                  final Uri phoneUri = Uri(
                    scheme: 'tel',
                    path: widget.business.phone,
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
                leading: const Icon(Icons.chat, color: Colors.green),
                title: const Text('WhatsApp'),
                onTap: () async {
                  Navigator.pop(context);

                  final whatsappNumber = widget.business.whatsApp
                      .replaceAll(RegExp(r'[^0-9]'), '');

                  if (whatsappNumber.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'WhatsApp number is not available.',
                        ),
                      ),
                    );
                    return;
                  }

                  final Uri whatsappUri = Uri.parse(
                    'https://wa.me/$whatsappNumber',
                  );

                  try {
                    await launchUrl(
                      whatsappUri,
                      mode: LaunchMode.externalApplication,
                    );
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Unable to open WhatsApp.'),
                      ),
                    );
                  }
                },
              ),

              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email Business'),
                onTap: () async {
                  Navigator.pop(context);

                  final Uri emailUri = Uri(
                    scheme: 'mailto',
                    path: widget.business.email,
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


  void _reportBusiness() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Report Business'),
          content: const Text(
            'Are you sure you want to report this business?',
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
                      'Business reported. Thank you.',
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
    final business = widget.business;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Profile'),
        actions: [
          IconButton(
            onPressed: _toggleFavourite,
            icon: Icon(
              isFavourite
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
            tooltip: 'Favourite',
          ),
          IconButton(
            onPressed: _reportBusiness,
            icon: const Icon(Icons.flag_outlined),
            tooltip: 'Report',
          ),
        ],
      ),
        body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    business.name,
    style: const TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    ),
    ),

    const SizedBox(height: 6),

    Text(
    business.category,
    style: const TextStyle(
    fontSize: 18,
    ),
    ),

    if (business.industry.isNotEmpty) ...[
    const SizedBox(height: 6),
    Text(
    business.industry,
    style: const TextStyle(
    fontSize: 16,
    ),
    ),
    ],

    if (business.businessType.isNotEmpty) ...[
    const SizedBox(height: 16),
    const Text(
    'Business Type',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 6),
    Text(
    business.businessType,
    style: const TextStyle(fontSize: 16),
    ),
    ],

    const SizedBox(height: 20),

    const Text(
    'Location',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),

    const SizedBox(height: 6),

    Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Icon(Icons.location_on_outlined),
    const SizedBox(width: 6),
    Expanded(
    child: Text(
    '${business.country} · '
    '${business.region} · '
    '${business.city}',
    style: const TextStyle(fontSize: 16),
    ),
    ),
    ],
    ),

    if (business.address.isNotEmpty) ...[
    const SizedBox(height: 8),
    Text(
    business.address,
    style: const TextStyle(fontSize: 16),
    ),
    ],

    const SizedBox(height: 20),

    const Text(
    'Services',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),

    const SizedBox(height: 8),

    Wrap(
    spacing: 8,
    runSpacing: 8,
    children: business.services.map((service) {
    return Chip(
    label: Text(service),
    );
    }).toList(),
    ),

    if (business.availability.isNotEmpty) ...[
    const SizedBox(height: 20),

    const Text(
    'Availability',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),

    const SizedBox(height: 8),

    Row(
    children: [
    Icon(
    business.availability == 'Remote'
    ? Icons.public
        : Icons.location_on,
    ),
    const SizedBox(width: 6),
    Expanded(
    child: Text(
    business.availability,
    style: const TextStyle(fontSize: 16),
    ),
    ),
    ],
    ),
    ],

    if (business.languages.isNotEmpty) ...[
    const SizedBox(height: 20),

    const Text(
    'Languages',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),

    const SizedBox(height: 8),

    Text(
    business.languages,
    style: const TextStyle(fontSize: 16),
    ),
    ],

    if (business.departments.isNotEmpty) ...[
    const SizedBox(height: 20),

    const Text(
    'Departments',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),

    const SizedBox(height: 8),

    Text(
    business.departments,
    style: const TextStyle(fontSize: 16),
    ),
    ],

    if (business.aboutUs.isNotEmpty) ...[
    const SizedBox(height: 20),

    const Text(
    'About Us',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),

    const SizedBox(height: 8),

    Text(
    business.aboutUs,
    style: const TextStyle(fontSize: 16),
    ),
    ],

    if (business.website.isNotEmpty) ...[
    const SizedBox(height: 20),

    const Text(
    'Website',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),

    const SizedBox(height: 8),

    InkWell(
    onTap: () async {
    final website = business.website.trim();

    final uri = Uri.tryParse(
    website.startsWith('http://') ||
    website.startsWith('https://')
    ? website
        : 'https://$website',
    );

    if (uri != null && uri.hasAuthority) {
    await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
    );
    }
    },
    child: Text(
    business.website,
    style: const TextStyle(
    fontSize: 16,
    color: Colors.blue,
    decoration: TextDecoration.underline,
    ),
    ),
    ),
    ],

    const SizedBox(height: 24),

      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _contactBusiness,
          icon: const Icon(Icons.phone),
          label: const Text('Contact Business'),
        ),
      ),
    ],
    ),
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
                leading: const Icon(Icons.chat, color: Colors.green),
                title: const Text('WhatsApp'),
                onTap: () async {
                  Navigator.pop(context);

                  final whatsappNumber = widget.professional.whatsApp
                      .replaceAll(RegExp(r'[^0-9]'), '');

                  if (whatsappNumber.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('WhatsApp number is not available.'),
                      ),
                    );
                    return;
                  }

                  final Uri whatsappUri = Uri.parse(
                    'https://wa.me/$whatsappNumber',
                  );

                  try {
                    await launchUrl(
                      whatsappUri,
                      mode: LaunchMode.externalApplication,
                    );
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Unable to open WhatsApp.'),
                      ),
                    );
                  }
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


          if (professional.positions.isNotEmpty) ...[
            const Text(
              'Positions Held',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...professional.positions.map(
                  (position) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  '• $position',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          if (professional.yearsOfExperience.isNotEmpty) ...[
            const Text(
              'Years of Experience',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              professional.yearsOfExperience,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
          ],

          if (professional.aboutMe.isNotEmpty) ...[
            const Text(
              'About',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              professional.aboutMe,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
          ],

          if (professional.education.isNotEmpty) ...[
            const Text(
              'Education & Qualifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              professional.education,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
          ],

          if (professional.certifications.isNotEmpty) ...[
            const Text(
              'Certifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              professional.certifications,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
          ],

          if (professional.website.isNotEmpty) ...[
            const Text(
              'Website',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final website = professional.website.trim();
                final uri = Uri.tryParse(
                  website.startsWith('http://') ||
                      website.startsWith('https://')
                      ? website
                      : 'https://$website',
                );

                if (uri != null && uri.hasAuthority) {
                  await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              child: Text(
                professional.website,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _obscurePassword = true;
  String _accountType = 'professional';

  bool _isLoading = false;

  Future<void> _createAccount() async {
    final email = _emailController.text.trim();
    final fullName = _fullNameController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

if (fullName.isEmpty ||
email.isEmpty ||
password.isEmpty ||
confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your full name, email and password.'),
        ),
      );
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'email': user.email,
          'fullName': fullName,
          'accountType': _accountType,
          'createdAt': FieldValue.serverTimestamp(),
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('notifications')
            .add({
          'title': 'Welcome to WhosWho',
          'message':
          'Welcome to WhosWho! Your account has been created successfully. '
              'Discover professionals, find services, and connect with others.',
          'createdAt': FieldValue.serverTimestamp(),
          'isRead': false,
          'type': 'welcome',
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully.'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Unable to create account.';

      if (e.code == 'email-already-in-use') {
        message = 'An account already exists with this email.';
      } else if (e.code == 'weak-password') {
        message = 'The password is too weak.';
      } else if (e.code == 'invalid-email') {
        message = 'Please enter a valid email address.';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
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
        title: const Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Create your WhosWho account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Register as',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _accountType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_circle_outlined),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'professional',
                  child: Text('Professional'),
                ),
                DropdownMenuItem(
                  value: 'business',
                  child: Text('Business'),
                ),
              ],
              onChanged: _isLoading
                  ? null
                  : (value) {
                if (value != null) {
                  setState(() {
                    _accountType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _fullNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: _accountType == 'professional'
                    ? 'Full name'
                    : 'Business name',
                prefixIcon: Icon(
                  _accountType == 'professional'
                      ? Icons.person_outline
                      : Icons.business_outlined,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email address',
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
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createAccount,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          return const SocialMediaWall();
        }

        return const WelcomePage();
      },
    );
  }
}