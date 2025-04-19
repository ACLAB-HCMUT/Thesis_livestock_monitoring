import 'package:do_an_app/controllers/user_controller/user_bloc.dart';
import 'package:do_an_app/screens/cow_detail_screen/cow_detail_screen.dart';
import 'package:do_an_app/screens/cow_update_screen/cow_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/models/cow_model.dart';

class CowCard extends StatelessWidget {
  final CowModel cow;

  const CowCard({required this.cow});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<CowBloc>().add(GetCowByIdEvent(cow.id ?? ""));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CowDetailScreen()),
        );
      },
      child: Card(
        color: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[400]!,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/cow_card_icon.jpg',
                                  width: 30,
                                  height: 30,
                                  color: Colors.green[300],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          cow.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          cow.cowAddr == -1 ? "( No Device )" : "(Device address: ${cow.cowAddr})",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.brown.shade300,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon:const Icon(Icons.more_vert, size: 30),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          shape:const  RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  cow.cowAddr != -1 ?
                                  ListTile(
                                    leading: Icon(Icons.info, color: Colors.green[200]),
                                    title: const Text('Remove Device'),
                                    onTap: () {
                                      String username = (context.read<UserBloc>().state as UserLoaded).user.username ?? "";
                                      context.read<CowBloc>().add(
                                        UpdateCowFieldsEvent(
                                          username: username,
                                          cowId: cow.id!,
                                          name: cow.name,
                                          age: cow.age,
                                          weight: cow.weight!.toDouble(),
                                          isMale: cow.sex,
                                          isSick: cow.sick,
                                          isPregnant: cow.pregnant,
                                          isMedicated: cow.medicated,
                                          groupId: cow.groupId,
                                          cowAddress: -1
                                        ),
                                      );
                                      Navigator.pop(context);
                                    },
                                  ): const SizedBox(),
                                  ListTile(
                                    leading: Icon(Icons.edit, color: Colors.green[200]),
                                    title: const Text('Edit'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => CowUpdateScreen(cow: cow)),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.delete, color: Colors.green[200]),
                                    title: const Text('Delete'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      context.read<CowBloc>().add(DeleteCowByIdEvent(cow.id!, (context.read<UserBloc>().state as UserLoaded).user.username ?? ""));
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Status",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green.shade300,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            cow.sick == true
                                ? 'Sick'
                                : cow.medicated == true
                                    ? 'Medicated'
                                    : 'Healthy',
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                          if (cow.missing == true)
                            Text(
                              'Missing',
                              style: TextStyle(fontSize: 13, color: Colors.black),
                            ),
                          if (cow.pregnant == true)
                            Text(
                              'Pregnant',
                              style: TextStyle(fontSize: 13, color: Colors.black),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Information",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green.shade300,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Age: ${cow.age}",
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                          Text(
                            "Sex: ${cow.sex! ? "Male" : "Female"}",
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                          Text(
                            "Weight: ${cow.weight}",
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}