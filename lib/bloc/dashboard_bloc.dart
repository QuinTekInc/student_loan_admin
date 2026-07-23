import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/components/server_connector.dart';
import 'package:loan_admin/models/models.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardModel dashboardModel;
  DashboardLoaded(this.dashboardModel);
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}

class DashboardCubit extends Cubit<DashboardState> {
  final WebSocketService webSocketService = WebSocketService(
    endpoint: 'ws/dashboard/',
    streamValidator: (data) => true,
  );

  DashboardCubit() : super(DashboardInitial());

  void fetchDashboardData() async {
    emit(DashboardLoading());

    try {
      if (!webSocketService.isConnected) {
        webSocketService.connect();
      }
    } catch (ex, trace) {
      debugPrintStack(stackTrace: trace);
      emit(DashboardError(ex.toString()));
    }

    webSocketService.dataStream.listen(
      (data) {
        //NOTE THE DATA HAS ALREADY BEEN DECODED
        DashboardModel dashboardModel = DashboardModel.fromJson(data);
        emit(DashboardLoaded(dashboardModel));
      },
      onDone: reconnect, //recursive call to this same function
      cancelOnError: true,
      onError: (error) => emit(DashboardError(error.toString())),
    );
  }

  void reconnect() {
    webSocketService.connect();
    fetchDashboardData();
  }

  void dispose() {
    emit(DashboardInitial());
    webSocketService.dispose();
  }
}
