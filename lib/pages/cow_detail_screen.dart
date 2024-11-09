import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/models/cow_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:do_an_app/pages/map_libre_page.dart';

class CowDetailScreen extends StatelessWidget {
  final CowModel cow;
  CowDetailScreen({required this.cow});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        title: Text("Cow Details", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold ),),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_image1.jpg'),
                fit: BoxFit.cover,
              )
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
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
                Text(
                  "Cow ID: ${cow.id}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Column(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children: [    
                    InfoRow(label: "Status", value: cow.sick == true ? 'Sick' : cow.medicated == true ? 'Medicated' : 'Healthy', icon: Icons.health_and_safety),
                    InfoRow(label: "Age", value: "${cow.age}", icon: Icons.calendar_today),
                    InfoRow(label: "Sex", value: cow.sex! ? "Male" : "Female", icon: Icons.male),
                    InfoRow(label: "Weight", value: "${cow.weight}", icon: Icons.line_weight),
                    InfoRow(label: "Heart Rate", value: "65", icon: Icons.favorite),
                    InfoRow(label: "Temperature", value: "38", icon: Icons.thermostat),
                    InfoRow(label: "Current action", value: "Grazing", icon: Icons.medical_information),
                    InfoRow(
                      label: "Location",
                      value: "(10.879712795929079, 106.80615327789357)",
                      icon: Icons.location_on,
                    ),
                  ],
                ),
                SizedBox(height: 60), 
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapLibrePage(cowId: cow.id!,),),
                    
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[300],
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  ),
                  child: Text("Open location", style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ],
      )
    );
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