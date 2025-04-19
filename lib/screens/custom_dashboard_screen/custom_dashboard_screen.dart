import 'package:do_an_app/controllers/device_controller/device_bloc.dart';
import 'package:do_an_app/screens/cow_add_new_screen/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/controllers/save_zone_controller/bloc/save_zone_bloc.dart';
import 'widgets/app_bar.dart';
import 'widgets/account_section.dart';
import 'widgets/safe_zone_section.dart';
import 'widgets/notification_section.dart';

class CustomDashboardScreen extends StatefulWidget {
  @override
  _CustomDashboardScreenState createState() => _CustomDashboardScreenState();
}

class _CustomDashboardScreenState extends State<CustomDashboardScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<SaveZoneBloc>().add(GetAllSaveZoneEvent());
    context.read<CowBloc>().add(GetAllCowEvent());
    context.read<DeviceBloc>().add(GetAllDeviceEvent());

    // Delay UI rendering slightly for smoother animation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: LoadingOverlay()) // Loading indicator
          : CustomScrollView(
              slivers: [
                CustomAppBar(),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final sections = [
                        AccountSection(),
                        SafeZoneSection(),
                        const SizedBox(height: 15),
                        NotificationSection(),
                        const SizedBox(height: 15),
                      ];
                      return sections[index];
                    },
                    childCount: 5,
                  ),
                ),
              ],
            ),
    );
  }
}
