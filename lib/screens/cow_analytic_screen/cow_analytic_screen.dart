import 'dart:async';
import 'package:do_an_app/screens/cow_analytic_screen/utils/format_helpers.dart';
import 'package:do_an_app/screens/cow_analytic_screen/utils/status_duration.dart';
import 'package:do_an_app/screens/cow_analytic_screen/widgets/status_card.dart';
import 'package:do_an_app/screens/cow_analytic_screen/widgets/status_distribution_card.dart';
import 'package:do_an_app/screens/cow_analytic_screen/widgets/status_history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'package:do_an_app/models/cow_model.dart';

class CowAnalyticsScreen extends StatefulWidget {
  @override
  _CowAnalyticsScreenState createState() => _CowAnalyticsScreenState();
}

class _CowAnalyticsScreenState extends State<CowAnalyticsScreen>
    with WidgetsBindingObserver {
  List<StatusDuration> statusHistory = [];
  Map<String, Duration> statusDurations = {
    'eating': Duration.zero,
    'walking': Duration.zero,
    'idle': Duration.zero,
  };
  String? currentStatus;
  DateTime? statusStartTime;
  Timer? _durationTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize with current status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<CowBloc>().state;
      if (state is CowLoaded) {
        _startTrackingStatus(state.cow.status);
      }
    });
    // Start a timer to update durations in real-time on screen
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && currentStatus != null && statusStartTime != null) {
        setState(() {
          statusDurations[currentStatus!] =
              statusDurations[currentStatus!]! + const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    // Record the final time for current status
    _endCurrentStatusTracking();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // App is going to background, update timers
      // _endCurrentStatusTracking();
    } else if (state == AppLifecycleState.resumed) {
      // App is coming back to foreground, restart timer
      final cowState = context.read<CowBloc>().state;
      if (cowState is CowLoaded) {
        _startTrackingStatus(cowState.cow.status);
      }
    }
  }

  void _startTrackingStatus(String? status) {
    if (status == null) return;

    // End tracking for previous status if exists
    _endCurrentStatusTracking();

    // Start tracking new status
    setState(() {
      currentStatus = status.toLowerCase();
      statusStartTime = DateTime.now();

      // Create new entry for status history
      statusHistory.add(
        StatusDuration(
          status: currentStatus!,
          startTime: statusStartTime!,
        ),
      );

      // Keep only last 20 status changes
      if (statusHistory.length > 20) {
        statusHistory.removeAt(0);
      }
    });
  }

  void _endCurrentStatusTracking() {
    if (currentStatus != null && statusStartTime != null) {
      final duration = DateTime.now().difference(statusStartTime!);

      // Update the last status entry with end time
      if (statusHistory.isNotEmpty) {
        setState(() {
          statusHistory.last.endTime = DateTime.now();
          statusHistory.last.duration = duration;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cow Analytics',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[300],
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocListener<CowBloc, CowState>(
        listener: (context, state) {
          if (state is CowLoaded) {
//            print("YYYYYYYYYYYYYYYYYYYYYYYYYY");
            // Only track if status actually changed
            if (currentStatus != state.cow.status?.toLowerCase()) {
              _startTrackingStatus(state.cow.status);
            }
          }
        },
        child: BlocBuilder<CowBloc, CowState>(
          buildWhen: (previous, current) {
            if (current is CowLoaded && previous is CowLoaded) {
              final prevStatus = previous.cow.status?.toLowerCase();
              final currStatus = current.cow.status?.toLowerCase();

              return prevStatus != currStatus;
            }

            // If state type changes (e.g., from loading to loaded)
            return previous.runtimeType != current.runtimeType;
          },
          builder: (context, state) {
            // Use a cached widget when possible to avoid rebuilding
            if (state is CowLoaded) {
              if (currentStatus != state.cow.status?.toLowerCase()) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _buildStateContent(state),
                );
              } else {
                return _buildStateContent(state);
              }
            }
            return const Center(
              key: ValueKey('loading_state'),
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStateContent(CowState state) {
    if (state is CowLoading) {
      return const Center(
        key: ValueKey('loading_state'),
        child: CircularProgressIndicator(),
      );
    } else if (state is CowLoaded) {
      // Add key based on cow id to preserve widget state
      return _buildAnalyticsBody(state.cow);
    } else {
      return const Center(
        key: ValueKey('error_state'),
        child: Text('Failed to load cow data'),
      );
    }
  }

  Widget _buildAnalyticsBody(CowModel cow) {
    return ListView(
      key: ValueKey('analytics_${cow.id}'),
      padding: const EdgeInsets.all(16),
      children: [
        // Pass currentDuration directly instead of calculating in build
        StatusCard(
          cow,
          currentStatus != null && statusStartTime != null
              ? DateTime.now().difference(statusStartTime!)
              : Duration.zero,
          key: ValueKey('status_card_${cow.id}'),
        ),
        const SizedBox(height: 16),
        StatusHistoryCard(statusHistory, key: const ValueKey('history_card')),
        const SizedBox(height: 16),
        StatusDistributionCard(statusDurations,
            key: const ValueKey('distribution_card')),
        const SizedBox(height: 16),
      ],
    );
  }
}
