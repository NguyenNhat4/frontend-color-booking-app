import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mobile/auth/repositories/auth_repository.dart';

class RegistrationScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final AuthRepository authRepository = AuthRepository();
  final String accountType;

  RegistrationScreen({super.key, required this.accountType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Display selected account type
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getAccountTypeIcon(),
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Account Type: ${_getAccountTypeLabel()}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'email',
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'username',
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'password',
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(8),
                    // Add more password strength validators if needed
                  ]),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'confirm_password',
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                  obscureText: true,
                  validator: (val) {
                    if (val !=
                        _formKey.currentState?.fields['password']?.value) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'first_name',
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'last_name',
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'phone_number',
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      final formData = _formKey.currentState?.value;
                      if (formData != null) {
                        final result = await authRepository.register(
                          email: formData['email'],
                          username: formData['username'],
                          password: formData['password'],
                          firstName: formData['first_name'],
                          lastName: formData['last_name'],
                          phoneNumber: formData['phone_number'],
                        );
                        if (result != null && context.mounted) {
                          // After successful registration, set account type
                          final accountTypeResult = await authRepository
                              .setAccountType(accountType);

                          if (accountTypeResult != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Registration Successful! Please login.',
                                ),
                              ),
                            );
                            Navigator.pop(context); // Go back to login screen
                            Navigator.pop(
                              context,
                            ); // Go back to account type selection screen
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Registration successful but failed to set account type. Please try logging in.',
                                ),
                              ),
                            );
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Registration Failed'),
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getAccountTypeIcon() {
    switch (accountType) {
      case 'homeowner':
        return Icons.home;
      case 'professional':
        return Icons.business_center;
      case 'business':
        return Icons.store;
      default:
        return Icons.person;
    }
  }

  String _getAccountTypeLabel() {
    switch (accountType) {
      case 'homeowner':
        return 'Homeowner';
      case 'professional':
        return 'Professional';
      case 'business':
        return 'Business';
      default:
        return accountType;
    }
  }
}
