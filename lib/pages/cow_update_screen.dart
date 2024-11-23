import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'package:do_an_app/controllers/save_zone_controller/bloc/save_zone_bloc.dart';
import 'package:do_an_app/global.dart';
import 'package:do_an_app/models/cow_model.dart';
import 'package:do_an_app/pages/cow_list_screen.dart';
import 'package:do_an_app/pages/custom_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CowUpdateScreen extends StatefulWidget {
  final CowModel cow;

  CowUpdateScreen({required this.cow});

  @override
  _CowUpdateScreenState createState() => _CowUpdateScreenState();
}

class _CowUpdateScreenState extends State<CowUpdateScreen> {
  String? _selectedSafeZoneId;
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late bool _isMale;
  late bool _isSick;
  late bool _isMedicated;
  late bool _isPregnant;

  @override
  void initState() {
    super.initState();
    _selectedSafeZoneId = widget.cow.safeZoneId.toString();
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
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<CowBloc, CowState>(
      listener: (context, state) {
        if (state is CowUpdated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CowListScreen()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[300],
          title: Text(
            "Update Cow Info",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/background_image1.jpg'),
                fit: BoxFit.cover,
              )),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IntrinsicHeight(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInputField("Name", _nameController),
                        _buildInputField("Age", _ageController),
                        _buildInputField("Weight", _weightController),
                        _buildCheckbox("Male", _isMale, (value) {
                          setState(() {
                            _isMale = value!;
                          });
                        }),
                        _buildCheckbox("Sick", _isSick, (value) {
                          setState(() {
                            _isSick = value!;
                          });
                        }),
                        _buildCheckbox("Pregnant", _isPregnant, (value) {
                          setState(() {
                            _isPregnant = value!;
                          });
                        }),
                        _buildCheckbox("Medicated", _isMedicated, (value) {
                          setState(() {
                            _isMedicated = value!;
                          });
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        BlocBuilder<SaveZoneBloc, SaveZoneState>(
                          builder: (context, state) {
                            if (state is SaveZoneLoading) {
                              return Text("Loading save zones ... ");
                            } else if (state is SaveZoneLoaded) {
                              final saveZones = state.safeZones;

                              return DropdownButtonFormField<String>(
                                value: _selectedSafeZoneId,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSafeZoneId = value;
                                  });
                                },
                                items: saveZones
                                    .map<DropdownMenuItem<String>>((zone) {
                                  return DropdownMenuItem<String>(
                                    value: zone.sequentialId,
                                    child: Container(
                                      width: 300, // Đặt chiều rộng phù hợp
                                      child: Container(
                                        decoration: BoxDecoration(
                                            // color: Colors.green
                                            ),
                                        width: 300,
                                        alignment: Alignment.center,
                                        child: Text(
                                          zone.sequentialId ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  labelText: "Select Safe Zone",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green.shade300,
                                        width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Colors.green.shade300,
                                        width: 2.0),
                                  ),
                                ),
                                dropdownColor: Colors.green.shade100,
                                icon: Icon(Icons.arrow_drop_down,
                                    color: Colors.green.shade300),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              );
                            }
                            return Text("Error loading save zones ... ");
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            context.read<CowBloc>().add(
                                  UpdateCowFieldsEvent(
                                    username: 'hoangs369',
                                    cowId: widget.cow.id!,
                                    name: _nameController.text,
                                    age: int.tryParse(_ageController.text),
                                    weight:
                                        double.tryParse(_weightController.text),
                                    isMale: _isMale,
                                    isSick: _isSick,
                                    isPregnant: _isPregnant,
                                    isMedicated: _isMedicated,
                                    safeZoneId: _selectedSafeZoneId
                                  ),
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[300],
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: Text(
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CustomDashboard()),
            );
          },
          backgroundColor: Colors.green.shade300,
          child: Icon(Icons.home, size: 28, color: Colors.white),
          shape: CircleBorder(),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.green.shade300,
          shape: CircularNotchedRectangle(),
          notchMargin: 6.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.map,
                    color: Colors.white,
                  ),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.settings, color: Colors.white),
                  onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            fillColor: Colors.white),
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
