import 'package:do_an_app/screens/cow_list_screen/cow_list_screen.dart';
import 'package:do_an_app/screens/custom_dashboard_screen/custom_dashboard_screen.dart';
import 'package:do_an_app/screens/login_screen/login_screen.dart';
import 'package:do_an_app/screens/profile_screen/user_profile_screen.dart';
import 'package:do_an_app/screens/slide_transition/slide_right_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'icon_with_text.dart';

class AccountSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                const Text(
                  'Số lượng gia súc',
                  style: TextStyle(
                    color:  Color.fromARGB(255, 123, 162, 125),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigator.of(context).pushReplacement(
                    //   SlideRightRoute(page: const UserProfileScreen()),
                      
                    // );
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileScreen(),
                    ),
                  );
                  },
                  icon: const Icon(Icons.account_circle, color: Colors.green),
                  label: const Text("Hồ sơ"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                  ),
                ),
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
                          fontWeight: FontWeight.bold,
                        ),
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
                        ? state.cows.where((cow) => cow.sick == true).length
                        : 0;
                    return IconWithText(
                      icon: Icons.thermostat,
                      label: 'Đau ốm',
                      quantity: sickCount,
                    );
                  },
                ),
                BlocBuilder<CowBloc, CowState>(
                  builder: (context, state) {
                    final medicatedCount = state is CowsLoaded
                        ? state.cows
                            .where((cow) => cow.medicated == true)
                            .length
                        : 0;
                    return IconWithText(
                      icon: Icons.medication,
                      label: 'Được dùng thuốc',
                      quantity: medicatedCount,
                    );
                  },
                ),
                BlocBuilder<CowBloc, CowState>(
                  builder: (context, state) {
                    final missingCount = state is CowsLoaded
                        ? state.cows.where((cow) => cow.missing == true).length
                        : 0;
                    return IconWithText(
                      icon: Icons.help_outline,
                      label: 'Mất tích',
                      quantity: missingCount,
                    );
                  },
                ),
                BlocBuilder<CowBloc, CowState>(
                  builder: (context, state) {
                    final pregnantCount = state is CowsLoaded
                        ? state.cows.where((cow) => cow.pregnant == true).length
                        : 0;
                    return IconWithText(
                      icon: Icons.pregnant_woman,
                      label: 'Có thai',
                      quantity: pregnantCount,
                    );
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
                icon: const Icon(Icons.list, color: Colors.green),
                label: const Text(
                  'Xem danh sách',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
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
