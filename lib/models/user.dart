class User {
  final String id;
  final String? username;
  final String? email;
  final String? lifelineId;
  final String firstName;
  final String lastName;
  final String role; // ADMIN, LGU, VOLUNTEER, RESPONDER, COMMUNITY
  final String? adminTier; // SUPER, CDRRMO
  final String? barangay;
  final String? municipality;
  final String? contactNo;
  final String? gender;
  final String? avatarUrl;
  final String volunteerStatus; // NONE, PENDING, APPROVED
  final bool onDuty;

  User({
    required this.id,
    this.username,
    this.email,
    this.lifelineId,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.adminTier,
    this.barangay,
    this.municipality,
    this.contactNo,
    this.gender,
    this.avatarUrl,
    required this.volunteerStatus,
    this.onDuty = true,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      username: json['username'],
      email: json['email'],
      lifelineId: json['lifelineId'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      role: json['role'] ?? 'COMMUNITY',
      adminTier: json['adminTier'],
      barangay: json['barangay'],
      municipality: json['municipality'],
      contactNo: json['contactNo'],
      gender: json['gender'],
      avatarUrl: json['avatarUrl'],
      volunteerStatus: json['volunteerStatus'] ?? 'NONE',
      onDuty: json['onDuty'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'lifelineId': lifelineId,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'adminTier': adminTier,
      'barangay': barangay,
      'municipality': municipality,
      'contactNo': contactNo,
      'gender': gender,
      'avatarUrl': avatarUrl,
      'volunteerStatus': volunteerStatus,
      'onDuty': onDuty,
    };
  }
}
