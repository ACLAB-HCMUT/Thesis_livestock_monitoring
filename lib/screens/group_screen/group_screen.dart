import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'package:do_an_app/controllers/save_zone_controller/bloc/save_zone_bloc.dart';
import 'package:do_an_app/models/cow_model.dart';
import 'package:do_an_app/screens/cow_add_new_screen/widgets/top_snackbar.dart';
import 'package:do_an_app/screens/cow_list_screen/widgets/cow_card.dart';
import 'package:do_an_app/screens/cow_list_screen/widgets/loading_skeleton.dart';
import 'package:do_an_app/screens/custom_dashboard_screen/custom_dashboard_screen.dart';
import 'package:do_an_app/screens/safe_zone_screen/safe_zone_screen.dart';
import 'package:do_an_app/screens/update_map_sceen/update_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupScreen extends StatefulWidget {
  final String groupId;
  const GroupScreen({super.key, required this.groupId});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<CowBloc, CowState>(
            listener: (context, state) {
        if (state is CowDeleting) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
          if (state is CowDeleted) {
            context.read<CowBloc>().add(GetAllCowEvent());
            showTopSnackBar(
                context, "Cow deleted successfully!", Colors.green.shade300);
          } else if (state is CowError) {
            showTopSnackBar(context, "Failed to delete cow: ${state.message}",
                Colors.red.shade500);
          }
        }

      },
      child: BlocBuilder<CowBloc, CowState>(
        builder: (context, state) {
          if (state is CowLoading ||
              state is CowDeleting ||
              state is CowLoaded ||
              state is CowUpdated ||
              state is CowUpdating) {
            if (ModalRoute.of(context)?.isCurrent == true) {
              if (state is CowLoaded || state is CowUpdated) {
                context.read<CowBloc>().add(GetAllCowEvent());
              }
            }
            return Scaffold(
              appBar: AppBar(
                title: const Text('Loading Cows...'),
              ),
              body: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return LoadingSkeleton();
                },
              ),
            );
          } else {
            final cows = (state as CowsLoaded).cows;
            List<CowModel> cowsGroup = [];
            for (var cow in cows) {
              if (cow.groupId == widget.groupId) {
                cowsGroup.add(cow);
              }
            }
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green[300],
                title: Text(
                  widget.groupId,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
              ),
              body: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/background_image1.jpg'),
                            fit: BoxFit.cover)),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 1.7,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: cowsGroup.length,
                          itemBuilder: (context, index) {
                            final cow = cowsGroup[index];
                            return CowCard(cow: cow);
                          },
                        ),
                      ))
                ],
              ),
              resizeToAvoidBottomInset: false,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomDashboardScreen())),
                backgroundColor: Colors.green.shade300,
                child: Icon(Icons.home, size: 28, color: Colors.white),
                shape: const CircleBorder(),
              ),
              bottomNavigationBar: BottomAppBar(
                color: Colors.green.shade300,
                shape: const CircularNotchedRectangle(),
                notchMargin: 6.0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.map, color: Colors.white),
                        onPressed: () {
                          final saveZoneState =
                              context.read<SaveZoneBloc>().state;
                          if (saveZoneState is SaveZoneLoaded) {
                            final saveZones = saveZoneState.safeZones;
                            for (var saveZone in saveZones) {
                              if (saveZone.groupId == widget.groupId) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SafeZoneScreen(
                                            safeZones: saveZone.safeZone!,
                                            name: saveZone.groupId!)));
                                break;
                              }
                            }
                          }
                        }),
                    IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          final saveZoneState =
                              context.read<SaveZoneBloc>().state;
                          if (saveZoneState is SaveZoneLoaded) {
                            final saveZones = saveZoneState.safeZones;
                            for (var saveZone in saveZones) {
                              if (saveZone.groupId == widget.groupId) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UpdateMapScreen(
                                            safeZones: saveZone.safeZone!,
                                            name: saveZone.groupId!)));
                                break;
                              }
                            }
                          }
                        }),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
