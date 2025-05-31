import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/profile/bloc/profile_bloc.dart';
import 'package:mobile/profile/bloc/profile_event.dart';
import 'package:mobile/profile/bloc/profile_state.dart';
import 'package:mobile/profile/models/user_model.dart';
import 'package:mobile/profile/screens/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            return _buildProfileContent(context, state.user);
          } else if (state is ProfileError && state.currentUser != null) {
            return _buildProfileContent(context, state.currentUser!);
          } else {
            return _buildErrorState(context);
          }
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, User user) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, user),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildProfileHeader(context, user),
                const SizedBox(height: 24),
                _buildPersonalInfoCard(context, user),
                const SizedBox(height: 16),
                _buildContactInfoCard(context, user),
                const SizedBox(height: 16),
                _buildAddressInfoCard(context, user),
                const SizedBox(height: 16),
                _buildAccountInfoCard(context, user),
                const SizedBox(height: 24),
                _buildActionButtons(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, User user) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: () => _navigateToEditProfile(context, user),
        ),
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
            context.read<ProfileBloc>().add(RefreshProfile());
          },
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context, User user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Text(
              user.initials,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.displayName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '@${user.username}',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          if (user.accountType != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getAccountTypeLabel(user.accountType!),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(BuildContext context, User user) {
    return _buildInfoCard(
      context,
      title: 'Personal Information',
      icon: Icons.person,
      children: [
        _buildInfoRow('First Name', user.firstName ?? 'Not provided'),
        _buildInfoRow('Last Name', user.lastName ?? 'Not provided'),
        _buildInfoRow('Email', user.email),
        _buildInfoRow('Username', user.username),
      ],
    );
  }

  Widget _buildContactInfoCard(BuildContext context, User user) {
    return _buildInfoCard(
      context,
      title: 'Contact Information',
      icon: Icons.contact_phone,
      children: [
        _buildInfoRow('Phone Number', user.phoneNumber ?? 'Not provided'),
      ],
    );
  }

  Widget _buildAddressInfoCard(BuildContext context, User user) {
    return _buildInfoCard(
      context,
      title: 'Address Information',
      icon: Icons.location_on,
      children: [
        _buildInfoRow('Street Address', user.streetAddress ?? 'Not provided'),
        _buildInfoRow('City', user.city ?? 'Not provided'),
        _buildInfoRow('State', user.state ?? 'Not provided'),
        _buildInfoRow('ZIP Code', user.zipCode ?? 'Not provided'),
        _buildInfoRow('Country', user.country ?? 'Not provided'),
      ],
    );
  }

  Widget _buildAccountInfoCard(BuildContext context, User user) {
    return _buildInfoCard(
      context,
      title: 'Account Information',
      icon: Icons.account_circle,
      children: [
        _buildInfoRow('Account Type', user.accountType ?? 'Not selected'),
        _buildInfoRow('Account Status', user.isActive ? 'Active' : 'Inactive'),
        _buildInfoRow('Email Verified', user.isVerified ? 'Yes' : 'No'),
        _buildInfoRow('Member Since', _formatDate(user.createdAt)),
        if (user.lastLogin != null)
          _buildInfoRow('Last Login', _formatDate(user.lastLogin!)),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _navigateToEditProfile(context, null),
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showChangePasswordDialog(context),
            icon: const Icon(Icons.lock),
            label: const Text('Change Password'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Failed to load profile',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ProfileBloc>().add(LoadProfile());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context, User? user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => BlocProvider.value(
              value: context.read<ProfileBloc>(),
              child: const EditProfileScreen(),
            ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    // TODO: Implement change password dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change password feature coming soon!')),
    );
  }

  String _getAccountTypeLabel(String accountType) {
    switch (accountType.toLowerCase()) {
      case 'homeowner':
        return 'Homeowner';
      case 'contractor':
        return 'Contractor';
      case 'company':
        return 'Company';
      case 'regular_customer':
        return 'Regular Customer';
      default:
        return accountType;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
