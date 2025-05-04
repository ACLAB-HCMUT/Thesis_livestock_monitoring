import 'package:do_an_app/controllers/device_controller/device_bloc.dart';
import 'package:do_an_app/controllers/user_controller/user_bloc.dart';
import 'package:do_an_app/screens/cow_add_new_screen/cow_add_new_screen.dart';
import 'package:do_an_app/screens/custom_dashboard_screen/custom_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'widgets/cow_card.dart';
import 'widgets/loading_skeleton.dart';
import 'widgets/bottom_navigation.dart';
import 'utils/snackbar_utils.dart';

class CowListScreen extends StatefulWidget {
  const CowListScreen({super.key});

  @override
  State<CowListScreen> createState() => _CowListScreenState();
}

class _CowListScreenState extends State<CowListScreen> {
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<CowBloc>().add(GetAllCowEvent());
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.read<UserBloc>().state as UserLoaded;
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    // Check that widget is still in the tree
                    context.read<DeviceBloc>().add(GetAllDeviceEvent());
                    context.read<CowBloc>().add(GetAllCowEvent());
                  }
                });
              }
            }
            return Scaffold(
              appBar: AppBar(
                title: const Text('Loading Cows...'),
              ),
              body: ListView.builder(
                itemCount: 5, // Show skeletons for 5 cows
                itemBuilder: (context, index) {
                  return LoadingSkeleton();
                },
              ),
            );
          } else if (state is CowsLoaded) {
            final cows = state.cows
                .where((cow) => cow.username == userState.user.username)
                .toList();

            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Cow List",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                backgroundColor: Colors.green[300],
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CowAddNewScreen()),
                      );
                    },
                  ),
                ],
              ),
              body: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/background_image1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: cows.isEmpty
                        ? Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 39, vertical: 25),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                border:
                                    Border.all(color: Colors.green.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Không có con bò nào 🐄',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 1.7,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: cows.length,
                            itemBuilder: (context, index) {
                              final cow = cows[index];
                              return CowCard(cow: cow);
                            },
                          ),
                  )
                ],
              ),
              resizeToAvoidBottomInset: false,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomDashboardScreen()),
                  );
                },
                backgroundColor: Colors.green.shade300,
                child: Icon(Icons.home, size: 28, color: Colors.white),
                shape: const CircleBorder(),
              ),
              bottomNavigationBar: BottomNavigation(),
            );
          } else if (state is CowError) {
            return Center(child: Text("Error: ${state.message}"));
          } else {
            return const Center(child: Text("No data found"));
          }
        },
      ),
    );
  }
}
