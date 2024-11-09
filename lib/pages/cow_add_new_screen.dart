import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'package:do_an_app/models/cow_model.dart';
import 'package:do_an_app/pages/cow_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CowAddNewScreen extends StatefulWidget {
  CowAddNewScreen();

  @override
  _CowUpdateScreenState createState() => _CowUpdateScreenState();
}

class _CowUpdateScreenState extends State<CowAddNewScreen> {
  late TextEditingController _cowAddressController;
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late bool _isMale;
  @override
  void initState() {
    super.initState();
    _cowAddressController = TextEditingController(text: "");
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
        if (state is CowLoaded) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CowListScreen()),
          );
        }
      },
      child: Scaffold(
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
                          _buildInputField(
                              "Cow address", _cowAddressController),
                          SizedBox(height: 10),
                          _buildInputField("Name", _nameController),
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
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              context.read<CowBloc>().add(CreateCowEvent(
                                cow_addr: int.tryParse(_cowAddressController.text),
                                name: _nameController.text,
                                age: int.tryParse(_ageController.text),
                                weight: int.tryParse(_weightController.text),
                                isMale: _isMale
                              ));
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
