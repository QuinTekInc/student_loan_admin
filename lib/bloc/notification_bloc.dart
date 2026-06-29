import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/components/server_connector.dart';
import 'package:loan_admin/models/models.dart';

abstract class NotificationState {}

class NotificationsInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  List<AppNotification> notifications;

  NotificationLoaded(this.notifications);

  List<AppNotification> filter({String filter = 'all'}) {
    if (filter == 'all') return notifications;

    if (filter == 'read') {
      return notifications
          .where((notification) => notification.isRead = true)
          .toList();
    } else {
      return notifications
          .where((notification) => notification.isRead = false)
          .toList();
    }
  }
}

class NotificationError extends NotificationState {
  String message;

  NotificationError(this.message);
}

class NotificationCubit extends Cubit<NotificationState> {
  
  final WebSocketService socketService = WebSocketService(
    endpoint: 'ws/notifications/',
    streamValidator: (item) => true,
  );

  NotificationCubit() : super(NotificationsInitial());

  void listenForNotifications() {
    try {
      socketService.connect();
    } catch (e) {
      emit(NotificationError(e.toString()));
    }

    emit(NotificationLoading());

    socketService.dataStream.listen(
      (data) {
        dynamic decoded = data;

        final currentState = state;

        List<AppNotification> newNotifications = [];

        if (decoded is List) {
          newNotifications = decoded
              .map((jsonMap) => AppNotification.fromJson(jsonMap))
              .toList();
        } else if (decoded is Map<String, dynamic>) {
          newNotifications = [AppNotification.fromJson(decoded)];
        }

        if (currentState is! NotificationLoaded) {
          emit(NotificationLoaded(newNotifications));
          return;
        }

        emit(
          NotificationLoaded([
            ...currentState.notifications,
            ...newNotifications,
          ]),
        );
      },
      onError: (error) {
        emit(NotificationError(error.toString()));
        print('There was an error: ${error.toString()}');
      },
      cancelOnError: true,
    );
  }

  void restartConnection() {
    socketService.connect();

    listenForNotifications();
  }

  void setFilter(String filter) {
    if (state is! NotificationLoaded) return;
  }
}
