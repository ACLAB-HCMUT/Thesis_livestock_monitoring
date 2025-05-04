import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'package:do_an_app/screens/cow_list_screen/cow_list_screen.dart';
import 'package:do_an_app/screens/custom_dashboard_screen/custom_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/controllers/save_zone_controller/bloc/save_zone_bloc.dart';
import 'package:do_an_app/controllers/user_controller/user_bloc.dart';
import 'widgets/input_field.dart';
import 'widgets/checkbox_field.dart';
import 'widgets/loading_overlay.dart';
import 'utils/validation_utils.dart';
import 'widgets/top_snackbar.dart';

class CowAddNewScreen extends StatefulWidget {
  CowAddNewScreen();

  @override
  _CowAddNewScreenState createState() => _CowAddNewScreenState();
}

class _CowAddNewScreenState extends State<CowAddNewScreen> {
  bool _isLoading = false;
  String? _selectedgroupId;
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late bool _isMale;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "");
    _ageController = TextEditingController(text: "");
    _weightController = TextEditingController(text: "");
    _isMale = false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.read<UserBloc>().state as UserLoaded;
    return BlocListener<CowBloc, CowState>(
      listener: (context, state) {
        if (state is CowLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
          if (state is CowLoaded) {
            showTopSnackBar(
                context, "Cow created successfully!", Colors.green.shade300);
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CowListScreen()));
            Navigator.pop(context);
          } else if (state is CowError) {
            showTopSnackBar(context, "Failed to create cow: ${state.message}",
                Colors.red.shade500);
          }
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green[300],
              title: const Text("Add New Cow",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/background_image1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IntrinsicHeight(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 4))
                            ]),
                        child: Column(
                          children: [
                            InputField(
                                label: "Cow name", controller: _nameController),
                            SizedBox(height: 10),
                            InputField(
                                label: "Age", controller: _ageController),
                            SizedBox(height: 10),
                            InputField(
                                label: "Weight", controller: _weightController),
                            SizedBox(height: 10),
                            CheckboxField(
                                label: "Male",
                                value: _isMale,
                                onChanged: (value) {
                                  setState(() => _isMale = value!);
                                }),
                            SizedBox(height: 10),
                            _buildgroupDropdown(userState),
                            SizedBox(height: 20),
                            _buildAddCowButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            resizeToAvoidBottomInset: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomDashboardScreen())),
              backgroundColor: Colors.green.shade300,
              child: Icon(Icons.home, size: 28, color: Colors.white),
              shape: const CircleBorder(),
            ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.green.shade300,
              shape: const CircularNotchedRectangle(),
              notchMargin: 6.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      icon: const Icon(Icons.map, color: Colors.white),
                      onPressed: () {}),
                  IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {}),
                ],
              ),
            ),
          ),
          if (_isLoading) LoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildgroupDropdown(UserLoaded userState) {
    return BlocBuilder<SaveZoneBloc, SaveZoneState>(
      builder: (context, state) {
        if (state is SaveZoneLoading) {
          return const Text("Loading save zones ... ");
        } else if (state is SaveZoneLoaded) {
          final saveZones = state.safeZones.where(
              (safeZone) => safeZone.username == userState.user.username);

          // Check if there are no safe zones for this user
          if (saveZones.isEmpty) {
            return GestureDetector(
              onTap: () {
                // Show a snackbar or dialog when tapped
                showTopSnackBar(
                context, "You need to define a new group first !", Colors.green.shade300);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("No safe zones available",
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey[600])),
                    Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                  ],
                ),
              ),
            );
          }

          // Original dropdown for when there are safe zones
          return DropdownButtonFormField<String>(
            value: _selectedgroupId,
            onChanged: (value) => setState(() => _selectedgroupId = value),
            items: saveZones.map<DropdownMenuItem<String>>((zone) {
              return DropdownMenuItem<String>(
                value: zone.groupId,
                child: Container(
                  width: 300,
                  alignment: Alignment.center,
                  child: Text(zone.groupId ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16)),
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: "Select Safe Zone",
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.green.shade300, width: 2.0)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey, width: 1.5)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      BorderSide(color: Colors.green.shade300, width: 2.0)),
            ),
            dropdownColor: Colors.green.shade100,
            icon: Icon(Icons.arrow_drop_down, color: Colors.green.shade300),
            style: const TextStyle(color: Colors.black, fontSize: 16),
          );
        }
        return const Text("Error loading save zones ... ");
      },
    );
  }

  Widget _buildAddCowButton() {
    return ElevatedButton(
      onPressed: () {
        if (!ValidationUtils.validateInputs(context, _nameController,
            _ageController, _weightController, _selectedgroupId)) return;
        context.read<CowBloc>().add(CreateCowEvent(
              cow_addr: -1,
              name: _nameController.text,
              username:
                  (context.read<UserBloc>().state as UserLoaded).user.username,
              age: int.tryParse(_ageController.text),
              weight: int.tryParse(_weightController.text),
              isMale: _isMale,
              groupId: _selectedgroupId,
            ));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[300],
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Text("Add cow", style: TextStyle(color: Colors.white)),
    );
  }
}
