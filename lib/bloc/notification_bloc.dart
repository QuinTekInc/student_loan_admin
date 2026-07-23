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
      if(!socketService.isConnected) socketService.connect();
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

          emit(NotificationLoaded(newNotifications));

          return;
        }

        if (decoded is Map<String, dynamic>) {
          final newNotification = AppNotification.fromJson(decoded);

          if (currentState is! NotificationLoaded) {
            emit(NotificationLoaded([newNotification]));
            return;
          }

          emit(
            NotificationLoaded([
              ...currentState.notifications,
              newNotification,
            ]),
          );
        }
      },
      cancelOnError: true,
      onError: (error) {
        emit(NotificationError(error.toString()));
        print('There was an error: ${error.toString()}');
      },
      onDone: () => restartConnection(),
    );
  }

  void restartConnection() {
    socketService.connect();
    listenForNotifications();
  }

  void markAllAsRead() {
    try {
      socketService.send({'type': 'mark_all_as_read'});

      if (state is! NotificationLoaded) return;

      final updated = (state as NotificationLoaded).notifications
          .map((notification) => notification.copyWith(isRead: true))
          .toList();

      emit(NotificationLoaded(updated));
    } catch (_) {
      rethrow;
    }
  }

  void markAsRead({required String notificationId}) async {
    try {
      Map<String, dynamic> body = {
        'type':'mark_as_read',
        'id': notificationId
      };

      socketService.send(body);

      if (state is! NotificationLoaded) return;

      final updated = (state as NotificationLoaded).notifications.map((
        notification,
      ) {
        if (notification.id != notificationId) return notification;

        return notification.copyWith(isRead: true);
      }).toList();

      emit(NotificationLoaded(updated));
    } catch (_) {
      print('Coulld not mark notification "$notificationId" as read');
    }
  }
}
