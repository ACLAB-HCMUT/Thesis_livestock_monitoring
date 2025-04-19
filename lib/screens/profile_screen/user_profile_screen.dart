import 'package:do_an_app/controllers/user_controller/user_bloc.dart';
import 'package:do_an_app/screens/cow_list_screen/widgets/bottom_navigation.dart';
import 'package:do_an_app/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:do_an_app/screens/custom_dashboard_screen/custom_dashboard_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Adjust import as needed

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        title: const Text(
          "User Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/background_image1.jpg'), // Replace with your image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // User Profile Content
            Center(
              child: Container(
                  margin: EdgeInsets.all(40),
                  padding: EdgeInsets.all(60),
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Profile Picture
                        const CircleAvatar(
                          radius: 60,
                          backgroundColor:
                              Colors.blueGrey, // Replace with user's image URL
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.green,
                          ), // Fallback icon
                        ),
                        const SizedBox(height: 20),
                        // User Name
                        BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            if (state is UserLoading) {
                              return CircularProgressIndicator();
                            } else {
                              return Text(
                                (state as UserLoaded)
                                    .user
                                    .fullname!, // Replace with user's name
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        // User Email
                        const Text(
                          "john.doe@example.com", // Replace with user's email
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Additional Information (e.g., Bio)
                        const Text(
                          "Hello! I'm a Cow lover.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 90),
                        ElevatedButton(
                          onPressed: () {
                            context.read<UserBloc>().add(LogoutUserEvent());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[300],
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                          ),
                          child: Text(
                            "Log out",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CustomDashboardScreen()),
            );
          },
          backgroundColor: Colors.green.shade300,
          child: const Icon(Icons.home, size: 28, color: Colors.white),
          shape: const CircleBorder(),
        ),
        bottomNavigationBar: BottomNavigation(),
      ),
    );
  }
}
