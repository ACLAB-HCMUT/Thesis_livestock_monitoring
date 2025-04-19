import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/user_controller/user_bloc.dart';
import 'package:do_an_app/screens/add_safe_zone_screen/add_safe_zone_screen.dart';
import 'package:do_an_app/screens/custom_dashboard_screen/utils/dialog.dart';
import 'package:do_an_app/screens/group_screen/group_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_an_app/controllers/save_zone_controller/bloc/save_zone_bloc.dart';

class SafeZoneSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
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
            const Text('Danh sách các chuồng',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color.fromARGB(255, 123, 162, 125),
                )),
            const SizedBox(height: 16),
            BlocBuilder<SaveZoneBloc, SaveZoneState>(
              builder: (context, state) {
                if (state is SaveZoneLoading) {
                  return const Text("Đang tải .... Vui lòng đợi ! ");
                } else if (state is SaveZoneLoaded) {
                  final saveZones = state.safeZones;
                  if (saveZones.isEmpty) {
                    return const Text("Không có chuồng nào ... ");
                  }
                  return Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: saveZones.length,
                      itemBuilder: (context, index) {
                        final saveZone = saveZones[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GroupScreen(
                                        groupId: saveZone.groupId!)));
                          },
                          child: Card(
                            color: Colors.blueGrey.shade200,
                            child: ListTile(
                              leading: IconButton(
                                onPressed: () {
                                },
                                icon:
                                    const Icon(Icons.map, color: Colors.white),
                              ),
                              title: Text(
                                saveZone.groupId ?? "",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              subtitle: Text(
                                "Points: ${saveZone.safeZone?.length ?? 0}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      ShowDialog.showConfirmationDialog(context, "Alert message", "Are you sure to delete this group ?", (){
                                        context.read<SaveZoneBloc>().add(
                                            DeleteSaveZoneIdEvent(
                                              saveZone.id ?? "",
                                              (context.read<UserBloc>().state
                                                          as UserLoaded)
                                                      .user
                                                      .username ??
                                                  "",
                                            ),
                                          );
                                      });
                                    },
                                    icon:  Icon(Icons.delete,
                                        color: Colors.red.shade300),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Text("No save zone found ... ");
              },
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddSafeZoneScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.green),
                label: const Text(
                  'Thêm Group',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
