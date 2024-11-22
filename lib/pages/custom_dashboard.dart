import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'package:do_an_app/controllers/save_zone_controller/bloc/save_zone_bloc.dart';
import 'package:do_an_app/pages/add_safe_zone_map.dart';
import 'package:do_an_app/pages/safe_zone_map.dart';
import 'package:flutter/material.dart';
import 'package:do_an_app/pages/cow_list_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<SaveZoneBloc>().add(GetAllSaveZoneEvent());
    context.read<CowBloc>().add(GetAllCowEvent());
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Background Image and Greeting
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Xin chào Vo Hoang',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/background_image.jpg',
                    fit: BoxFit.cover,
                  ),
                  // Overlay the search and notification icons
                  Positioned(
                    top: 100,
                    left: 50,
                    right: 50,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.search, color: Colors.black54),
                          Icon(Icons.notifications, color: Colors.black54),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Account Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Số lượng gia súc',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 123, 162, 125),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.account_circle,
                                  color: Colors.green,
                                ),
                                label: Text("Hồ sơ"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[200],
                                ))
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BlocBuilder<CowBloc, CowState>(
                              builder: (context, state) {
                                if (state is CowLoading) {
                                  return Text("");
                                } else if (state is CowsLoaded) {
                                  final cows = state.cows;
                                  final int totalCows = cows.length;
                                  return Text(
                                    '$totalCows con bò',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  );
                                }
                                return Text("");
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            BlocBuilder<CowBloc, CowState>(
                              builder: (context, state) {
                                final sickCount = state is CowsLoaded
                                    ? state.cows
                                        .where((cow) => cow.sick == true)
                                        .length
                                    : 0;
                                return _buildIconWithText(
                                    Icons.thermostat, 'Đau ốm', sickCount);
                              },
                            ),
                            BlocBuilder<CowBloc, CowState>(
                              builder: (context, state) {
                                final medicatedCount = state is CowsLoaded
                                    ? state.cows
                                        .where((cow) => cow.medicated == true)
                                        .length
                                    : 0;
                                return _buildIconWithText(Icons.medication,
                                    'Được dùng thuốc', medicatedCount);
                              },
                            ),
                            BlocBuilder<CowBloc, CowState>(
                              builder: (context, state) {
                                final missingCount = state is CowsLoaded
                                    ? state.cows
                                        .where((cow) => cow.missing == true)
                                        .length
                                    : 0;
                                return _buildIconWithText(Icons.help_outline,
                                    'Mất tích', missingCount);
                              },
                            ),
                            BlocBuilder<CowBloc, CowState>(
                              builder: (context, state) {
                                final pregnantCount = state is CowsLoaded
                                    ? state.cows
                                        .where((cow) => cow.pregnant == true)
                                        .length
                                    : 0;
                                return _buildIconWithText(Icons.pregnant_woman,
                                    'Có thai', pregnantCount);
                              },
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CowListScreen(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.list,
                                color: Colors.green,
                              ),
                              label: Text('Xem danh sách',
                                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vùng an toàn',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: const Color.fromARGB(255, 123, 162, 125)),
                        ),
                        SizedBox(height: 16),
                        // Each notification item styled individually
                        BlocBuilder<SaveZoneBloc, SaveZoneState>(
                          builder: (context, state) {
                            if (state is SaveZoneLoading) {
                              return Text("Loading save zones ... ");
                            } else if (state is SaveZoneLoaded) {
                              final saveZones = state.safeZones;
                              // Confirm saveZones is not empty
                              print("Number of safe zones: ${saveZones.length}");
                              if (saveZones.isEmpty) {
                                return Text("No save zone found ... ");
                              }
                              return Container(
                                height: 200,
                                child: ListView.builder(
                                  itemCount: saveZones.length,
                                  itemBuilder: (context, index) {
                                    final saveZone = saveZones[index];
                                    return Card(
                                      color: Colors.green.shade300,
                                      child: ListTile(
                                        title: Text(
                                          saveZone.sequentialId ?? "",
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                        subtitle: Text(
                                          "Points: ${saveZone.safeZone?.length ?? 0}",
                                          style: TextStyle(color: Colors.white),
                                        ), // Avoid null issue with length
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SafeZoneMap(
                                                      safeZones:
                                                          saveZone.safeZone ??
                                                              [],
                                                      name:
                                                          saveZone.sequentialId ?? "",
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.map,
                                                color: Colors.white,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                context.read<SaveZoneBloc>().add(DeleteSaveZoneyIdEvent(saveZone.id?? ""));
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            return Text("No save zone found ... ");
                          },
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddSafeZoneMap(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.green,
                              ),
                              label: Text('Thêm vùng an toàn',
                                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),

                // Favorite Transaction Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thông báo quan trọng',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: const Color.fromARGB(255, 123, 162, 125)),
                        ),
                        SizedBox(height: 16),
                        // Each notification item styled individually
                        _buildNotificationItem(
                          'Tag 16, 21, 65 đang bị bệnh.',
                        ),
                        _buildNotificationItem(
                          'Lịch khám bệnh hàng tháng vào ngày mai.',
                        ),
                        _buildNotificationItem(
                          'Tag 29,63 đang mất tích.',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Other Benefits Section
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //       horizontal: 16.0, vertical: 16.0),
                //   child: Container(
                //     padding: EdgeInsets.all(16),
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(16),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.black12,
                //           blurRadius: 10,
                //           offset: Offset(0, 4),
                //         ),
                //       ],
                //     ),
                //     child: Column(
                //       children: [
                //         Text("November '23",
                //             style: TextStyle(
                //               fontSize: 18,
                //               fontWeight: FontWeight.bold,
                //             )),
                //         SizedBox(height: 15),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                //           children: [
                //             _buildProductionInfo(
                //                 "Milk", "36 liters", "65 VND/liter"),
                //             _buildProductionInfo("Meat", "12 kg", "189 VND/kg"),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function for creating icons with labels
  Widget _buildIconWithText(IconData icon, String label, int quantity) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[200],
          child: Icon(
            icon,
            color: Colors.green,
            size: 40,
          ),
        ),
        Text(
          quantity.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(label,
            textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildNotificationItem(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!, // Light grey for the divider
            width: 1.0,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildProductionInfo(String label, String quantity, String price) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            quantity,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
