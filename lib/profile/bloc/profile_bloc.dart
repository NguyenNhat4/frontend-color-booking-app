import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/profile/bloc/profile_event.dart';
import 'package:mobile/profile/bloc/profile_state.dart';
import 'package:mobile/profile/repositories/user_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;

  ProfileBloc({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<DeleteAccount>(_onDeleteAccount);
    on<RefreshProfile>(_onRefreshProfile);
  }

  /// Handle loading user profile
  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final user = await _userRepository.getCurrentUser();
      if (user != null) {
        emit(ProfileLoaded(user: user));
      } else {
        emit(const ProfileError(message: 'Failed to load user profile'));
      }
    } catch (e) {
      emit(ProfileError(message: 'Error loading profile: ${e.toString()}'));
    }
  }

  /// Handle updating user profile
  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileUpdating(currentUser: currentState.user));

      try {
        final updatedUser = await _userRepository.updateProfile(
          firstName: event.firstName,
          lastName: event.lastName,
          phoneNumber: event.phoneNumber,
          streetAddress: event.streetAddress,
          city: event.city,
          state: event.state,
          zipCode: event.zipCode,
          country: event.country,
        );

        if (updatedUser != null) {
          emit(ProfileUpdateSuccess(updatedUser: updatedUser));
          // Transition back to loaded state with updated user
          emit(ProfileLoaded(user: updatedUser));
        } else {
          emit(
            ProfileError(
              message: 'Failed to update profile',
              currentUser: currentState.user,
            ),
          );
          emit(ProfileLoaded(user: currentState.user));
        }
      } catch (e) {
        emit(
          ProfileError(
            message: 'Error updating profile: ${e.toString()}',
            currentUser: currentState.user,
          ),
        );
        emit(ProfileLoaded(user: currentState.user));
      }
    }
  }

  /// Handle deleting user account
  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileUpdating(currentUser: currentState.user));

      try {
        final success = await _userRepository.deleteAccount();

        if (success) {
          emit(const AccountDeleteSuccess());
        } else {
          emit(
            ProfileError(
              message: 'Failed to delete account',
              currentUser: currentState.user,
            ),
          );
          emit(ProfileLoaded(user: currentState.user));
        }
      } catch (e) {
        emit(
          ProfileError(
            message: 'Error deleting account: ${e.toString()}',
            currentUser: currentState.user,
          ),
        );
        emit(ProfileLoaded(user: currentState.user));
      }
    }
  }

  /// Handle refreshing profile data
  Future<void> _onRefreshProfile(
    RefreshProfile event,
    Emitter<ProfileState> emit,
  ) async {
    // Simply trigger a reload
    add(LoadProfile());
  }
}
