import 'package:do_an_app/controllers/device_controller/device_bloc.dart';
import 'package:do_an_app/screens/cow_list_screen/cow_list_screen.dart';
import 'package:do_an_app/screens/cow_list_screen/widgets/loading_skeleton.dart';
import 'package:do_an_app/screens/cow_update_screen/widgets/device_dropdown.dart';
import 'package:do_an_app/screens/custom_dashboard_screen/custom_dashboard_screen.dart';

import 'utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'package:do_an_app/controllers/user_controller/user_bloc.dart';
import 'package:do_an_app/models/cow_model.dart';
import 'widgets/input_field.dart';
import 'widgets/checkbox_field.dart';
import 'widgets/save_zone_dropdown.dart';

class CowUpdateScreen extends StatefulWidget {
  final CowModel cow;

  CowUpdateScreen({required this.cow});

  @override
  _CowUpdateScreenState createState() => _CowUpdateScreenState();
}

class _CowUpdateScreenState extends State<CowUpdateScreen> {
  String? _selectedgroupId;
  String? _selecteddeviceId;
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late bool _isMale;
  late bool _isSick;
  late bool _isPregnant;
  late bool _isMedicated;
  @override
  void initState() {
    super.initState();
    context.read<DeviceBloc>().add(GetAllDeviceEvent());
    _selectedgroupId = widget.cow.groupId.toString();
    _selecteddeviceId = "";
    _nameController = TextEditingController(text: widget.cow.name.toString());
    _ageController = TextEditingController(text: widget.cow.age.toString());
    _weightController =
        TextEditingController(text: widget.cow.weight.toString());
    _isMale = widget.cow.sex!;
    _isSick = widget.cow.sick!;
    _isMedicated = widget.cow.medicated!;
    _isPregnant = widget.cow.pregnant!;
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
    return BlocBuilder<DeviceBloc, DeviceState>(builder: (context, state) {
      if (state is DeviceLoading) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Loading ...'),
          ),
          body: ListView.builder(
            itemCount: 5, // Show skeletons for 5 cows
            itemBuilder: (context, index) {
              return LoadingSkeleton();
            },
          ),
        );
      } else {
        return BlocListener<CowBloc, CowState>(
          listener: (context, state) {
            if (state is CowUpdated) {
              context.read<DeviceBloc>().add(GetAllDeviceEvent());
              Navigator.pop(context);
              // Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => CowListScreen()));
            }
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green[300],
              title: const Text(
                "Update Cow Info",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
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
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            InputField(
                                label: "Name", controller: _nameController),
                            InputField(
                                label: "Age", controller: _ageController),
                            InputField(
                                label: "Weight", controller: _weightController),
                            CheckboxField(
                                label: "Male",
                                value: _isMale,
                                onChanged: (value) {
                                  setState(() => _isMale = value!);
                                }),
                            CheckboxField(
                                label: "Sick",
                                value: _isSick,
                                onChanged: (value) {
                                  setState(() => _isSick = value!);
                                }),
                            CheckboxField(
                                label: "Pregnant",
                                value: _isPregnant,
                                onChanged: (value) {
                                  setState(() => _isPregnant = value!);
                                }),
                            CheckboxField(
                                label: "Medicated",
                                value: _isMedicated,
                                onChanged: (value) {
                                  setState(() => _isMedicated = value!);
                                }),
                            const SizedBox(height: 10),
                            SaveZoneDropdown(
                              selectedSafeZoneId: _selectedgroupId,
                              onChanged: (value) =>
                                  setState(() => _selectedgroupId = value),
                            ),
                            const SizedBox(height: 20),
                            DeviceDropdown(
                              selectedDeviceId: null,
                              onChanged: (value) =>
                                  setState(() => _selecteddeviceId = value),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                if (!ValidationUtils.validateInputs(
                                    context,
                                    _nameController,
                                    _ageController,
                                    _weightController,
                                    _selectedgroupId)) return;
                                String username = (context
                                            .read<UserBloc>()
                                            .state as UserLoaded)
                                        .user
                                        .username ??
                                    "";
                                context.read<CowBloc>().add(
                                      UpdateCowFieldsEvent(
                                          username: username,
                                          cowId: widget.cow.id!,
                                          name: _nameController.text,
                                          age:
                                              int.tryParse(_ageController.text),
                                          weight: double.tryParse(
                                              _weightController.text),
                                          isMale: _isMale,
                                          isSick: _isSick,
                                          isPregnant: _isPregnant,
                                          isMedicated: _isMedicated,
                                          groupId: _selectedgroupId,
                                          cowAddress: _selecteddeviceId != ""
                                              ? (context
                                                      .read<DeviceBloc>()
                                                      .state as DeviceLoaded)
                                                  .devices
                                                  .firstWhere((device) =>
                                                      device.device_name ==
                                                      _selecteddeviceId)
                                                  .address
                                              : widget.cow.cowAddr),
                                    );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[300],
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                              child: const Text(
                                "Save Changes",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
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
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomDashboardScreen()),
                );
              },
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
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}
