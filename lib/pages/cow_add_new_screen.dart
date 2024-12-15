import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'package:do_an_app/controllers/save_zone_controller/bloc/save_zone_bloc.dart';
import 'package:do_an_app/controllers/user_controller/user_bloc.dart';
import 'package:do_an_app/models/cow_model.dart';
import 'package:do_an_app/pages/cow_list_screen.dart';
import 'package:do_an_app/pages/custom_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CowAddNewScreen extends StatefulWidget {
  CowAddNewScreen();

  @override
  _CowUpdateScreenState createState() => _CowUpdateScreenState();
}

class _CowUpdateScreenState extends State<CowAddNewScreen> {
  bool _isLoading = false;
  String? _selectedSafeZoneId;
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
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CowBloc, CowState>(
      listener: (context, state) {
        if (state is CowLoading) {
          setState(() {
            _isLoading = true;
          });
        } else {
          setState(() {
            _isLoading = false; // Tắt overlay loading
          });
          if (state is CowLoaded) {
            showTopSnackBar(
                context, "Cow created successfully!", Colors.green.shade300);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CowListScreen()),
            );
          } else if (state is CowError) {
            showTopSnackBar(context, "'Failed to create cow: ${state.message}'",
                Colors.red.shade500);
          }
        }
      },
      child: Stack(children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green[300],
            title: Text(
              "Add New Cow",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                          _buildInputField("Cow name", _nameController),
                          SizedBox(height: 10),
                          _buildInputField("Age", _ageController),
                          SizedBox(height: 10),
                          _buildInputField("Weight", _weightController),
                          SizedBox(height: 10),
                          _buildCheckbox("Male", _isMale, (value) {
                            setState(() {
                              _isMale = value!;
                            });
                          }),
                          SizedBox(height: 10),
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
                              if (_nameController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Vui lòng nhập tên con bò.'),
                                    backgroundColor: Colors.red.shade300,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.fromLTRB(16, 0, 16, 10),
                                  ),
                                );
                                return;
                              }
                              if (_ageController.text.isEmpty ||
                                  int.tryParse(_ageController.text) == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Vui lòng nhập tuổi hợp lệ.'),
                                    backgroundColor: Colors.red.shade300,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.fromLTRB(16, 0, 16, 70),
                                  ),
                                );
                                return;
                              }
                              if (_weightController.text.isEmpty ||
                                  int.tryParse(_weightController.text) ==
                                      null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Vui lòng nhập cân nặng hợp lệ.'),
                                    backgroundColor: Colors.red.shade300,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.fromLTRB(16, 0, 16, 70),
                                  ),
                                );
                                return;
                              }
                              if (_selectedSafeZoneId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Vui lòng chọn vùng an toàn.'),
                                    backgroundColor: Colors.red.shade300,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.fromLTRB(16, 0, 16, 70),
                                  ),
                                );
                                return;
                              }
                              context.read<CowBloc>().add(CreateCowEvent(
                                  cow_addr: -1,
                                  name: _nameController.text,
                                  username: (context.read<UserBloc>().state
                                          as UserLoaded)
                                      .user
                                      .username,
                                  age: int.tryParse(_ageController.text),
                                  weight: int.tryParse(_weightController.text),
                                  isMale: _isMale,
                                  safeZoneId: _selectedSafeZoneId));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[300],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: Text(
                              "Add cow",
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
        if (_isLoading) _buildLoadingOverlay(),
      ]),
    );
  }

  Widget _buildLoadingOverlay() {
    return Stack(
      children: [
        ModalBarrier(
          color: Colors.black54,
          dismissible: false,
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Colors.green.shade300,
                strokeWidth: 5.0, // Độ dày của vòng xoay
              ),
              SizedBox(height: 16),
              Text(
                "Processing.  ..",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
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

  void showTopSnackBar(BuildContext context, String message, Color color) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100.0,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
    overlay?.insert(overlayEntry);
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
