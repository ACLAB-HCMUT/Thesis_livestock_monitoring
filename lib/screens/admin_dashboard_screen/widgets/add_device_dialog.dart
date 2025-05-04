// Create this dialog that will appear on top of the admin dashboard
import 'package:do_an_app/controllers/device_controller/device_bloc.dart';
import 'package:do_an_app/controllers/user_controller/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddDeviceDialog extends StatefulWidget {
  const AddDeviceDialog({Key? key}) : super(key: key);

  @override
  State<AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<AddDeviceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _deviceNameController = TextEditingController();
  String? _selectedUsername;
  List<String> _usernames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsernames();
  }

  void _loadUsernames() {
    setState(() {
      _isLoading = true;
    });

    // Fetch usernames from your UserBloc
    final userState = context.read<UserBloc>().state;
    if (userState is UsersLoaded) {
      setState(() {
        // Filter to only include users with role 'user'
        _usernames = userState.users
            .where((user) => user.role == 'user')
            .map((user) => user.username)
            .where((username) => username != null)
            .map((username) => username!)
            .toList();
        _isLoading = false;
      });
    } else {
      // Listen for when users are loaded
      context.read<UserBloc>().stream.listen((state) {
        if (state is UsersLoaded && mounted) {
          setState(() {
            // Filter to only include users with role 'user'
            _usernames = state.users
                .where((user) => user.role == 'user')
                .map((user) => user.username)
                .where((username) => username != null)
                .map((username) => username!)
                .toList();
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<DeviceBloc>().add(CreateDeviceEvent(_selectedUsername!));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Device'),
      content: _isLoading
          ? const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            )
          : Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedUsername,
                    decoration: InputDecoration(
                      labelText: 'User Owner',
                      prefixIcon: const Icon(Icons.person, color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    items: _usernames.map((username) {
                      return DropdownMenuItem<String>(
                        value: username,
                        child: Text(
                          username,
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedUsername = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a user';
                      }
                      return null;
                    },
                    isExpanded: true,
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.green),
                    dropdownColor: Colors.white,
                    menuMaxHeight: 300,
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text('Add Device'),
        ),
      ],
    );
  }
}
