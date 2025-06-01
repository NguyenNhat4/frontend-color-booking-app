import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? accountType;
  final bool isActive;
  final bool isVerified;
  final bool hasCompletedAccountSelection;
  final String? streetAddress;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLogin;

  const User({
    required this.id,
    required this.email,
    required this.username,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.accountType,
    required this.isActive,
    required this.isVerified,
    required this.hasCompletedAccountSelection,
    this.streetAddress,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    required this.createdAt,
    this.updatedAt,
    this.lastLogin,
  });

  /// Get the user's full name or fallback to username
  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    }
    return username;
  }

  /// Get the user's initials for avatar display
  String get initials {
    if (firstName != null &&
        firstName!.isNotEmpty &&
        lastName != null &&
        lastName!.isNotEmpty) {
      return '${firstName![0].toUpperCase()}${lastName![0].toUpperCase()}';
    } else if (firstName != null && firstName!.isNotEmpty) {
      return firstName![0].toUpperCase();
    } else if (lastName != null && lastName!.isNotEmpty) {
      return lastName![0].toUpperCase();
    } else if (username.isNotEmpty) {
      return username[0].toUpperCase();
    }
    return '?'; // Fallback for completely empty data
  }

  /// Check if user has a business account type
  bool get isBusinessAccount {
    return accountType == 'contractor' || accountType == 'company';
  }

  /// Get formatted address
  String? get formattedAddress {
    final addressParts = <String>[];

    if (streetAddress != null && streetAddress!.isNotEmpty) {
      addressParts.add(streetAddress!);
    }
    if (city != null && city!.isNotEmpty) {
      addressParts.add(city!);
    }
    if (state != null && state!.isNotEmpty) {
      addressParts.add(state!);
    }
    if (zipCode != null && zipCode!.isNotEmpty) {
      addressParts.add(zipCode!);
    }
    if (country != null && country!.isNotEmpty) {
      addressParts.add(country!);
    }

    return addressParts.isNotEmpty ? addressParts.join(', ') : null;
  }

  /// Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      accountType: json['account_type'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isVerified: json['is_verified'] as bool? ?? false,
      hasCompletedAccountSelection:
          json['has_completed_account_selection'] as bool? ?? false,
      streetAddress: json['street_address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zip_code'] as String?,
      country: json['country'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : null,
      lastLogin:
          json['last_login'] != null
              ? DateTime.parse(json['last_login'] as String)
              : null,
    );
  }

  /// Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'account_type': accountType,
      'is_active': isActive,
      'is_verified': isVerified,
      'has_completed_account_selection': hasCompletedAccountSelection,
      'street_address': streetAddress,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'country': country,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }

  /// Create a copy of User with updated fields
  User copyWith({
    int? id,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? accountType,
    bool? isActive,
    bool? isVerified,
    bool? hasCompletedAccountSelection,
    String? streetAddress,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      accountType: accountType ?? this.accountType,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      hasCompletedAccountSelection:
          hasCompletedAccountSelection ?? this.hasCompletedAccountSelection,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    username,
    firstName,
    lastName,
    phoneNumber,
    accountType,
    isActive,
    isVerified,
    hasCompletedAccountSelection,
    streetAddress,
    city,
    state,
    zipCode,
    country,
    createdAt,
    updatedAt,
    lastLogin,
  ];

  @override
  String toString() {
    return 'User(id: $id, email: $email, username: $username, displayName: $displayName)';
  }
}
