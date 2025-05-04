import 'package:do_an_app/screens/cow_statistic_screen/widgets/period_selector.dart';
import 'package:do_an_app/screens/cow_statistic_screen/widgets/status_history_card.dart';
import 'package:do_an_app/screens/cow_statistic_screen/widgets/total_duration_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'package:do_an_app/services/cow_service.dart';

import 'widgets/daily_status_chart.dart';

class CowStatisticsScreen extends StatefulWidget {
  @override
  _CowStatisticsScreenState createState() => _CowStatisticsScreenState();
}

class _CowStatisticsScreenState extends State<CowStatisticsScreen> {
  int _selectedPeriod = 7; // Default to 7 days
  Map<String, dynamic> _analyticsData = {};
  List<dynamic> _statusHistory = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String? currentStatus;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final cowState = context.read<CowBloc>().state;
      if (cowState is CowLoaded) {
        final cowId = cowState.cow.id;
        currentStatus = cowState.cow.status;

        // Load analytics data
        final analytics = await getCowStatusAnalytics(cowId!, _selectedPeriod);
        final history = await getCowStatusHistory(cowId);

        setState(() {
          _analyticsData = analytics;
          _statusHistory = history;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Cow data not loaded';
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load statistics: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cow Statistics',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[300],
        centerTitle: true,
      ),
      body: _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _buildStatisticsBody(),
    );
  }

  Widget _buildStatisticsBody() {
    return BlocListener<CowBloc, CowState>(
      listener: (context, state) {
        if(state is CowLoaded){
          if (currentStatus != state.cow.status?.toLowerCase()){
            _loadData();
          }
        }
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PeriodSelector(
              selectedPeriod: _selectedPeriod,
              onPeriodSelected: (int days) {
                setState(() {
                  _selectedPeriod = days;
                });
                _loadData();
              }),
          const SizedBox(height: 20),
          DailyStatusChart(analyticsData: _analyticsData),
          const SizedBox(height: 20),
          TotalDurationCard(analyticsData: _analyticsData),
          const SizedBox(height: 20),
          StatusHistoryCard(statusHistory: _statusHistory),
        ],
      ),
    );
  }
}
