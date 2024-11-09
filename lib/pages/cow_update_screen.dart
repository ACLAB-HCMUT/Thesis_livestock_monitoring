import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'package:do_an_app/models/cow_model.dart';
import 'package:do_an_app/pages/cow_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CowUpdateScreen extends StatefulWidget {
  final CowModel cow;

  CowUpdateScreen({required this.cow});

  @override
  _CowUpdateScreenState createState() => _CowUpdateScreenState();
}

class _CowUpdateScreenState extends State<CowUpdateScreen> {
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
    _nameController = TextEditingController(text: widget.cow.name.toString());
    _ageController = TextEditingController(text: widget.cow.age.toString());
    _weightController = TextEditingController(text: widget.cow.weight.toString());
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
        if(state is CowUpdated){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CowListScreen()),
          );
        }
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green[300],
            title: Text(
              "Update Cow Info",
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
              SingleChildScrollView (
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
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              context.read<CowBloc>().add(
                                    UpdateCowFieldsEvent(
                                      cowId: widget.cow.id!,
                                      name: _nameController.text,
                                      age: int.tryParse(_ageController.text),
                                      weight:
                                          double.tryParse(_weightController.text),
                                      isMale: _isMale,
                                      isSick: _isSick,
                                      isPregnant: _isPregnant,
                                      isMedicated: _isMedicated,
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
          )),
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
