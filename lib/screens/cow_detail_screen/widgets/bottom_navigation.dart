import 'package:do_an_app/screens/cow_analytic_screen/cow_analytic_screen.dart';
import 'package:do_an_app/screens/cow_detail_screen/utils/bluetooth_utils.dart';
import 'package:do_an_app/screens/cow_statistic_screen/cow_statistic_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';

class BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.green.shade300,
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.analytics, color: Colors.white),
            onPressed: () {
              final cowState = context.read<CowBloc>().state;
              if (cowState is CowLoaded) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CowAnalyticsScreen(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please wait for cow data to load'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.white),
            onPressed: () async {
              // final cowState = context.read<CowBloc>().state;
              // if (cowState is CowLoaded) {
              //   await handleBluetooth(context);
              // }
              final cowState = context.read<CowBloc>().state;
              if (cowState is CowLoaded) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CowStatisticsScreen(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please wait for cow data to load'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
