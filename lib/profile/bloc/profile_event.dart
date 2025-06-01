import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the current user profile
class LoadProfile extends ProfileEvent {}

/// Event to update user profile information
class UpdateProfile extends ProfileEvent {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? streetAddress;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;

  const UpdateProfile({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.streetAddress,
    this.city,
    this.state,
    this.zipCode,
    this.country,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    phoneNumber,
    streetAddress,
    city,
    state,
    zipCode,
    country,
  ];
}

/// Event to delete user account (soft delete)
class DeleteAccount extends ProfileEvent {
  const DeleteAccount();

  @override
  List<Object> get props => [];
}

/// Event to refresh profile data
class RefreshProfile extends ProfileEvent {}
