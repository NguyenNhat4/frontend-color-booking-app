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

/// Event to update user email
class UpdateEmail extends ProfileEvent {
  final String newEmail;

  const UpdateEmail({required this.newEmail});

  @override
  List<Object> get props => [newEmail];
}

/// Event to change password
class ChangePassword extends ProfileEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword];
}

/// Event to upload profile picture
class UploadProfilePicture extends ProfileEvent {
  final String imagePath;

  const UploadProfilePicture({required this.imagePath});

  @override
  List<Object> get props => [imagePath];
}

/// Event to delete user account
class DeleteAccount extends ProfileEvent {
  final String password;

  const DeleteAccount({required this.password});

  @override
  List<Object> get props => [password];
}

/// Event to refresh profile data
class RefreshProfile extends ProfileEvent {}
