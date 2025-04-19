import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/screens/cow_location_screen/cow_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'package:do_an_app/models/cow_model.dart';
import 'info_row.dart';

class CowDetailsCard extends StatefulWidget {
  @override
  _CowDetailsCardState createState() => _CowDetailsCardState();
}

class _CowDetailsCardState extends State<CowDetailsCard> {
  TextEditingController? _noteController;
  bool _isEditing = false;
  CowModel? _currentCow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 40,
            child: Image.asset(
              'assets/cow_card_icon.jpg',
              width: 50,
              color: Colors.green[300],
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<CowBloc, CowState>(
            builder: (context, state) {
              if (state is CowLoading) {
                return const CircularProgressIndicator();
              } else if (state is CowLoaded) {
                CowModel cow = state.cow;
                return Text(
                  "Cow ID: ${cow.id}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                );
              }
              return const Text("Error cow loading ...");
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(context, "Age", "age", Icons.calendar_today),
              _buildInfoRow(context, "Sex", "sex", Icons.male),
              _buildInfoRow(context, "Weight", "weight", Icons.line_weight),
              _buildInfoRow(
                  context, "Group Id", "groupId", Icons.location_city),
              const SizedBox(height: 30),
              BlocBuilder<CowBloc, CowState>(builder: (context, state) {
                if (state is CowLoading) {
                  return const CircularProgressIndicator();
                } else if (state is CowLoaded) {
                  CowModel cow = state.cow;
                  if (_noteController == null || _currentCow?.id != cow.id) {
                    _noteController =
                        TextEditingController(text: cow.note ?? "");
                    _currentCow = cow;
                  }
                  return TextField(
                    controller: _noteController,
                    readOnly: !_isEditing,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Cow Note',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.note_alt),
                      filled: true,
                      fillColor:
                          _isEditing ? Colors.grey[100] : Colors.grey[200],
                    ),
                  );
                }
                return const CircularProgressIndicator();
              }),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            buttonPadding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_isEditing) {
                    // Save the note
                    final updatedNote = _noteController?.text ?? "";
                    context.read<CowBloc>().add(UpdateCowNoteEvent(
                          cowId: _currentCow!.id!,
                          updatedNode: updatedNote,
                        ));
                  }
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[300],
                ),
                child: Text(_isEditing ? "Save Note" : "Add Note"),
              ),
              ElevatedButton(
                onPressed: () {
                  final cowState = context.read<CowBloc>().state;
                  if (cowState is CowLoaded) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CowLocationScreen(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[300],
                ),
                child: const Text("Open Location"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, String label, String field, IconData icon) {
    return BlocBuilder<CowBloc, CowState>(
      builder: (context, state) {
        if (state is CowLoading || state is CowsLoaded) {
          return const CircularProgressIndicator();
        } else {
          CowModel cow = (state as CowLoaded).cow;
          String value;
          switch (field) {
            case "sick":
              value = cow.sick == true
                  ? 'Sick'
                  : cow.medicated == true
                      ? 'Medicated'
                      : 'Healthy';
              break;
            case "age":
              value = "${cow.age}";
              break;
            case "sex":
              value = cow.sex! ? "Male" : "Female";
              break;
            case "weight":
              value = "${cow.weight}";
              break;
            case "status":
              value = "${cow.status}";
              break;
            case "location":
              value = "(${cow.latestLatitude}, ${cow.latestLongitude})";
              break;
            case "groupId":
              value = "${cow.groupId}";
              break;
            default:
              value = "";
          }
          return InfoRow(label: label, value: value, icon: icon);
        }
      },
    );
  }
}
