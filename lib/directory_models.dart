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
  final Map<String, String> socialMedia;
  final List<Map<String, String>> additionalSocialMedia;
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
    this.socialMedia = const {},
    this.additionalSocialMedia = const [],
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
  final Map<String, String> socialMedia;
  final List<Map<String, String>> additionalSocialMedia;
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
    this.socialMedia = const {},
    this.additionalSocialMedia = const [],
    this.otherDetails = '',
  });
}