import 'package:equatable/equatable.dart';
import 'package:mobile/profile/models/user_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state when profile hasn't been loaded yet
class ProfileInitial extends ProfileState {}

/// State when profile is being loaded
class ProfileLoading extends ProfileState {}

/// State when profile is successfully loaded
class ProfileLoaded extends ProfileState {
  final User user;

  const ProfileLoaded({required this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'ProfileLoaded { user: ${user.displayName} }';
}

/// State when profile update is in progress
class ProfileUpdating extends ProfileState {
  final User currentUser;

  const ProfileUpdating({required this.currentUser});

  @override
  List<Object> get props => [currentUser];
}

/// State when profile update is successful
class ProfileUpdateSuccess extends ProfileState {
  final User updatedUser;
  final String message;

  const ProfileUpdateSuccess({
    required this.updatedUser,
    this.message = 'Profile updated successfully',
  });

  @override
  List<Object> get props => [updatedUser, message];

  @override
  String toString() => 'ProfileUpdateSuccess { message: $message }';
}

/// State when account deletion is successful
class AccountDeleteSuccess extends ProfileState {
  final String message;

  const AccountDeleteSuccess({this.message = 'Account deleted successfully'});

  @override
  List<Object> get props => [message];
}

/// State when there's an error with profile operations
class ProfileError extends ProfileState {
  final String message;
  final User? currentUser;

  const ProfileError({required this.message, this.currentUser});

  @override
  List<Object?> get props => [message, currentUser];

  @override
  String toString() => 'ProfileError { message: $message }';
}
