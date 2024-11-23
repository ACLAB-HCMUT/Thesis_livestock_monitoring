// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last
import 'dart:io';

import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'package:do_an_app/models/cow_model.dart';
import 'package:do_an_app/pages/custom_dashboard.dart';
import 'package:do_an_app/pages/bluetooth_scan_screen.dart';
import 'package:do_an_app/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:do_an_app/pages/map_libre_page.dart';

class CowDetailScreen extends StatelessWidget {
  CowDetailScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[300],
          title: Text(
            "Cow Details",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/background_image1.jpg'),
                  fit: BoxFit.cover,
                )),
              ),
              Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
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
                      SizedBox(height: 16),
                      BlocBuilder<CowBloc, CowState>(
                        builder: (context, state) {
                          if (state is CowLoading) {
                            return CircularProgressIndicator();
                          } else if (state is CowLoaded) {
                            CowModel cow = state.cow;
                            return Text(
                              "Cow ID: ${cow.id}",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            );
                          }
                          return Text("Error cow loading ...");
                        },
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<CowBloc, CowState>(
                            builder: (context, state) {
                              if (state is CowLoading || state is CowsLoaded) {
                                return CircularProgressIndicator();
                              } else {
                                CowModel cow = (state as CowLoaded).cow;
                                return InfoRow(
                                    label: "Status",
                                    value: cow.sick == true
                                        ? 'Sick'
                                        : cow.medicated == true
                                            ? 'Medicated'
                                            : 'Healthy',
                                    icon: Icons.health_and_safety);
                              }
                            },
                          ),
                          BlocBuilder<CowBloc, CowState>(
                            builder: (context, state) {
                              if (state is CowLoading || state is CowsLoaded) {
                                return CircularProgressIndicator();
                              } else {
                                CowModel cow = (state as CowLoaded).cow;
                                return InfoRow(
                                    label: "Age",
                                    value: "${cow.age}",
                                    icon: Icons.calendar_today);
                              }
                            },
                          ),
                          BlocBuilder<CowBloc, CowState>(
                            builder: (context, state) {
                              if (state is CowLoading || state is CowsLoaded) {
                                return CircularProgressIndicator();
                              } else {
                                CowModel cow = (state as CowLoaded).cow;
                                return InfoRow(
                                    label: "Sex",
                                    value: cow.sex! ? "Male" : "Female",
                                    icon: Icons.male);
                              }
                            },
                          ),
                          BlocBuilder<CowBloc, CowState>(
                            builder: (context, state) {
                              if (state is CowLoading || state is CowsLoaded) {
                                return CircularProgressIndicator();
                              } else {
                                CowModel cow = (state as CowLoaded).cow;
                                return InfoRow(
                                    label: "Weight",
                                    value: "${cow.weight}",
                                    icon: Icons.line_weight);
                              }
                            },
                          ),
                          InfoRow(
                              label: "Heart Rate",
                              value: "65",
                              icon: Icons.favorite),
                          InfoRow(
                              label: "Temperature",
                              value: "38",
                              icon: Icons.thermostat),
                          BlocBuilder<CowBloc, CowState>(
                            builder: (context, state) {
                              if (state is CowLoading || state is CowsLoaded) {
                                return CircularProgressIndicator();
                              } else {
                                CowModel cow = (state as CowLoaded).cow;
                                return InfoRow(
                                    label: "Current action",
                                    value: "${cow.status}",
                                    icon: Icons.medical_information);
                              }
                            },
                          ),
                          BlocBuilder<CowBloc, CowState>(
                            builder: (context, state) {
                              if (state is CowLoading || state is CowsLoaded) {
                                return CircularProgressIndicator();
                              } else {
                                CowModel cow = (state as CowLoaded).cow;
                                return InfoRow(
                                  label: "Location",
                                  value:
                                      "(${cow.latestLatitude}, ${cow.latestLongitude})",
                                  icon: Icons.location_on,
                                );
                              }
                            },
                          ),
                          BlocBuilder<CowBloc, CowState>(
                            builder: (context, state) {
                              if (state is CowLoading || state is CowsLoaded) {
                                return CircularProgressIndicator();
                              } else {
                                CowModel cow = (state as CowLoaded).cow;
                                return InfoRow(
                                  label: "Save zone",
                                  value: "${cow.safeZoneId}",
                                  icon: Icons.location_city,
                                );
                              }
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 60),
                      ElevatedButton(
                        onPressed: () {
                          final cowState = context.read<CowBloc>().state;
                          if (cowState is CowLoaded) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapLibrePage(
                                  
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[300],
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                        ),
                        child: Text(
                          "Open location",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
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
                    onPressed: () {
                      if(FlutterBluePlus.adapterStateNow == BluetoothAdapterState.on){
                        Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BluetoothScanScreen()
                              ),
                            );
                      }else{
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  'Bạn có muốn bật Bluetooth',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "IndieFlower",
                                    fontWeight: FontWeight.bold,
                                  )),
                              actions: [
                                TextButton(
                                  child: Text("Xác nhận"),
                                  onPressed: () async {
                                    //call event to turn on Bluetooth
                                    try {
                                      if (Platform.isAndroid) {
                                        await FlutterBluePlus.turnOn();
                                        Navigator.of(context).pop();
                                      }
                                    } catch (e) {
                                      Snackbar.show(ABC.a, prettyException("Error Turning On:", e), success: false);
                                    }
                                  },
                                ),
                                TextButton(
                                  child: Text("Hủy"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          },
                        );
                      }
                      
                    }),
              ],
            ),
          ),
        ));
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  InfoRow({required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: Colors.green, size: 20),
          if (icon != null) SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
