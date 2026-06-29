
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/components/server_connector.dart';


abstract class DashboardState{}

class DashboardInitial extends DashboardState{}

class DashboardLoading extends DashboardState{}

class DashboardLoaded extends DashboardState{
  final Map<String, dynamic> dashboardMap;
  DashboardLoaded(this.dashboardMap);
}

class DashboardError extends DashboardState{
  final String message;
  DashboardError(this.message);
}


class DashboardCubit extends Cubit<DashboardState>{

  final WebSocketService webSocketService;

  DashboardCubit(this.webSocketService) : super(DashboardInitial());

  void fetchDashboardData() async {


  }
}