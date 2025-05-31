import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mobile/profile/bloc/profile_bloc.dart';
import 'package:mobile/profile/bloc/profile_event.dart';
import 'package:mobile/profile/bloc/profile_state.dart';
import 'package:mobile/profile/models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                return TextButton(
                  onPressed: _isLoading ? null : () => _saveProfile(state.user),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdating) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }

          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoaded) {
            return _buildEditForm(context, state.user);
          } else if (state is ProfileUpdating) {
            return _buildEditForm(context, state.currentUser);
          } else if (state is ProfileError && state.currentUser != null) {
            return _buildEditForm(context, state.currentUser!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildEditForm(BuildContext context, User user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
        key: _formKey,
        initialValue: {
          'first_name': user.firstName ?? '',
          'last_name': user.lastName ?? '',
          'email': user.email,
          'phone_number': user.phoneNumber ?? '',
          'street_address': user.streetAddress ?? '',
          'city': user.city ?? '',
          'state': user.state ?? '',
          'zip_code': user.zipCode ?? '',
          'country': user.country ?? '',
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard(
              context,
              title: 'Personal Information',
              icon: Icons.person,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'first_name',
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.maxLength(50),
                        ]),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'last_name',
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.maxLength(50),
                        ]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'email',
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                    FormBuilderValidators.maxLength(100),
                  ]),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'phone_number',
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.maxLength(20),
                  ]),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionCard(
              context,
              title: 'Address Information',
              icon: Icons.location_on,
              children: [
                FormBuilderTextField(
                  name: 'street_address',
                  decoration: const InputDecoration(
                    labelText: 'Street Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.home),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.maxLength(200),
                  ]),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: FormBuilderTextField(
                        name: 'city',
                        decoration: const InputDecoration(
                          labelText: 'City',
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.maxLength(100),
                        ]),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'state',
                        decoration: const InputDecoration(
                          labelText: 'State',
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.maxLength(50),
                        ]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'zip_code',
                        decoration: const InputDecoration(
                          labelText: 'ZIP Code',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.text,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.maxLength(20),
                        ]),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'country',
                        decoration: const InputDecoration(
                          labelText: 'Country',
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.maxLength(100),
                        ]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : () => _saveProfile(user),
                icon:
                    _isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Icon(Icons.save),
                label: Text(_isLoading ? 'Saving...' : 'Save Changes'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed:
                    _isLoading ? null : () => Navigator.of(context).pop(),
                icon: const Icon(Icons.cancel),
                label: const Text('Cancel'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
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
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  void _saveProfile(User user) {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;
      final profileBloc = context.read<ProfileBloc>();

      // Check if email has changed
      final newEmail = formData['email']?.toString().trim();
      if (newEmail != null && newEmail != user.email) {
        // Update email first
        profileBloc.add(UpdateEmail(newEmail: newEmail));
      }

      // Update other profile fields
      profileBloc.add(
        UpdateProfile(
          firstName:
              formData['first_name']?.toString().trim().isEmpty == true
                  ? null
                  : formData['first_name']?.toString().trim(),
          lastName:
              formData['last_name']?.toString().trim().isEmpty == true
                  ? null
                  : formData['last_name']?.toString().trim(),
          phoneNumber:
              formData['phone_number']?.toString().trim().isEmpty == true
                  ? null
                  : formData['phone_number']?.toString().trim(),
          streetAddress:
              formData['street_address']?.toString().trim().isEmpty == true
                  ? null
                  : formData['street_address']?.toString().trim(),
          city:
              formData['city']?.toString().trim().isEmpty == true
                  ? null
                  : formData['city']?.toString().trim(),
          state:
              formData['state']?.toString().trim().isEmpty == true
                  ? null
                  : formData['state']?.toString().trim(),
          zipCode:
              formData['zip_code']?.toString().trim().isEmpty == true
                  ? null
                  : formData['zip_code']?.toString().trim(),
          country:
              formData['country']?.toString().trim().isEmpty == true
                  ? null
                  : formData['country']?.toString().trim(),
        ),
      );
    }
  }
}
