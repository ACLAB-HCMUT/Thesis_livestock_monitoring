import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'package:do_an_app/models/cow_model.dart';
import 'package:do_an_app/pages/cow_add_new_screen.dart';
import 'package:do_an_app/pages/custom_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:do_an_app/pages/cow_detail_screen.dart';
import 'package:do_an_app/pages/cow_update_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class CowListScreen extends StatefulWidget {
  const CowListScreen({super.key});

  @override
  State<CowListScreen> createState() => _CowListScreenState();
}

class _CowListScreenState extends State<CowListScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<CowBloc>().add(GetAllCowEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CowBloc, CowState>(
      listener: (context, state) {
        if (state is CowDeleted) {
          context.read<CowBloc>().add(GetAllCowEvent());
        }
      },
      child: BlocBuilder<CowBloc, CowState>(
        builder: (context, state) {
          if (state is CowLoading ||
              state is CowDeleting ||
              state is CowLoaded) {
            if (ModalRoute.of(context)?.isCurrent == true) {
              if (state is CowLoaded) {
                context.read<CowBloc>().add(GetAllCowEvent());
              }
            }
            return Scaffold(
              appBar: AppBar(
                title: Text('Loading Cows...'),
              ),
              body: ListView.builder(
                itemCount: 5, // Show skeletons for 5 cows
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Container(
                              height: 20, // Placeholder for cow name
                              width: double.infinity,
                              color: Colors.grey[300],
                            ),
                            SizedBox(height: 8),
                            Container(
                              height: 15, // Placeholder for additional info
                              width: double.infinity,
                              color: Colors.grey[300],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is CowsLoaded) {
            final cows = state.cows;

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Cow List",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.green[300],
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
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
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/background_image1.jpg'),
                      fit: BoxFit.cover,
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 1.7, // Adjust aspect ratio
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: cows.length,
                        itemBuilder: (context, index) {
                          final cow = cows[index];
                          return CowCard(
                            cow: cow,
                            parentContext: context,
                          );
                        },
                      ),
                    ),
                  ),
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
                        onPressed: () {}),
                  ],
                ),
              ),
            );
          } else if (state is CowError) {
            return Center(child: Text("Error: ${state.message}"));
          } else {
            return Center(child: Text("No data found"));
          }
        },
      ),
    );
  }
}

class CowCard extends StatelessWidget {
  final CowModel cow;
  final BuildContext parentContext;

  CowCard({required this.cow, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    color: Colors.grey[400]!, // Light grey for the divider
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
                        decoration: BoxDecoration(
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
                            )
                          ],
                        )),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        cow.cowAddr.toString() + ", " + cow.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert, size: 30),
                    onPressed: () {
                      // Show the modal bottom sheet
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.info,
                                    color: Colors.green[200],
                                  ),
                                  title: Text('Details'),
                                  onTap: () {
                                    context
                                        .read<CowBloc>()
                                        .add(GetCowByIdEvent(cow.id ?? ""));
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CowDetailScreen()),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.edit,
                                      color: Colors.green[200]),
                                  title: Text('Edit'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CowUpdateScreen(
                                                cow: cow,
                                              )),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.delete,
                                      color: Colors.green[200]),
                                  title: Text('Delete'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    context
                                        .read<CowBloc>()
                                        .add(DeleteCowByIdEvent(cow.id!, 'hoangs369'));
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cow.sick == true
                      ? 'Sick'
                      : cow.medicated == true
                          ? 'Medicated'
                          : 'Healthy',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                if (cow.missing == true) ...{
                  Text(
                    'Missing',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  )
                },
                if (cow.pregnant == true) ...{
                  Text(
                    'Pregnant',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  )
                },
                SizedBox(height: 4),
                Text("Age: ${cow.age}",
                    style: TextStyle(fontSize: 12, color: Colors.black)),
                Text("Sex: ${cow.sex! ? "Male" : "Female"}",
                    style: TextStyle(fontSize: 12, color: Colors.black)),
                Text("Weight: ${cow.weight}",
                    style: TextStyle(fontSize: 12, color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
