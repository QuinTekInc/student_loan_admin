import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/notification_bloc.dart';
import 'package:loan_admin/components/placeholders.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/models/models.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool readSelected = false;
  bool unreadSelected = false;

  String filter = 'all';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText('Notifications', fontSize: 24),

          CustomText('Manage applications personal and systems notifications'),

          const SizedBox(height: 24),

          Expanded(
            child: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (_, state) {
                if (state is NotificationLoading) {
                  return LoadingPlaceholder();
                }

                if (state is NotificationError) {
                  return MessagePlaceholder.error(
                    message: state.message,
                    onButtonPressed: () =>
                        context.read<NotificationCubit>().restartConnection(),
                  );
                }

                return _buildBody();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    NotificationLoaded loaded =
        context.read<NotificationCubit>().state as NotificationLoaded;

    List<AppNotification> notifications = loaded.filter(filter: filter);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        //row of button showing the notifications
        Row(
          spacing: 12,
          children: [
            ElevatedButton(
              onPressed: () => setState(() {
                readSelected = false;
                unreadSelected = false;
                filter = 'all';
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: (!readSelected && !unreadSelected)
                    ? Colors.green.shade700
                    : null,
              ),
              child: CustomText(
                'All',
                textColor: (!readSelected && !unreadSelected)
                    ? Colors.white
                    : Colors.black87,
              ),
            ),

            //
            ElevatedButton.icon(
              onPressed: () => setState(() {
                readSelected = true;
                unreadSelected = false;
                filter = 'read';
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: readSelected ? Colors.green.shade700 : null,
                iconColor: readSelected ? Colors.white : Colors.black87,
              ),
              label: CustomText(
                'Unread',
                textColor: readSelected ? Colors.white : Colors.black87,
              ),
              icon: Icon(Icons.check),
            ),

            ElevatedButton(
              onPressed: () => setState(() {
                readSelected = false;
                unreadSelected = true;
                filter = 'unread';
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: unreadSelected ? Colors.green.shade700 : null,
                iconColor: unreadSelected ? Colors.white : Colors.black87,
              ),
              child: CustomText(
                'Read',
                textColor: unreadSelected ? Colors.white : Colors.black87,
              ),
            ),


            Spacer(), 


            if(unreadSelected) ElevatedButton.icon(  
              onPressed: (){
                //TODO: function to mark all the user's unread notification as read.
              },

              style: ElevatedButton.styleFrom(  
                backgroundColor: Colors.blue.shade400,
                iconColor: Colors.white
              ),
              icon: Icon(Icons.check),
              label: CustomText(
                'Mark all as read', 
                textColor: Colors.white,
              ),
            )
          ],
        ),

        if (loaded.notifications.isEmpty)
          Expanded(
            child: MessagePlaceholder(
              icon: Icons.notifications_outlined,
              message: 'No Notifications yet.',
            ),
          ),

        if (loaded.notifications.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationRow(notification: notifications[index]);
              },
            ),
          ),
      ],
    );
  }
}

class NotificationRow extends StatelessWidget {
  final AppNotification notification;

  const NotificationRow({super.key, required this.notification});

  Color get notificationTypeColor {
    switch (notification.notificationType) {
      case "info":
        return Colors.blue;

      case 'success':
        return Colors.green.shade700;

      case 'reminder':
        return Colors.deepPurple.shade700;

      default:
        return Colors.amber;
    }
  }

  IconData get getIconType {
    switch (notification.notificationType) {
      case 'info':
        return Icons.info;

      case 'success':
        return Icons.check;

      case 'reminder':
        return Icons.notifications_outlined;

      default:
        return Icons.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(getIconType, color: notificationTypeColor, size: 40),
      title: CustomText(
        notification.title,
        fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.normal,
        fontSize: 16,
      ),
      subtitle: CustomText(notification.message),

      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 3,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            formatTime(notification.createdAt),
            fontWeight: notification.isRead
                ? FontWeight.w600
                : FontWeight.normal,
            textColor: notification.isRead
                ? notificationTypeColor
                : Colors.grey.shade50,
          ),

          CustomText(
            formatDate(notification.createdAt),
            textColor: Colors.grey.shade500,
          ),
        ],
      ),

      onTap: () {

        //TODO: send a message to the server that a notification has been read.

        showModalBottomSheet(
        context: context,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        builder: (_) => NotificationModalSheet(
          notification: notification,
          notificationTypeColor: notificationTypeColor,
          notificationIcon: getIconType,
        ),
      );
      },
    );
  }
}

class NotificationModalSheet extends StatelessWidget {
  final AppNotification notification;
  final Color notificationTypeColor;
  final IconData notificationIcon;

  const NotificationModalSheet({
    super.key,
    required this.notification,
    required this.notificationTypeColor,
    required this.notificationIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Icon(notificationIcon, color: notificationTypeColor, size: 60),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText('Notification'),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 2,
                    children: [
                      CustomText(
                        notification.id,
                        textColor: Colors.grey.shade600,
                      ),

                      CustomText(
                        '\u2022',
                        textColor: Colors.grey.shade500,
                        fontSize: 16,
                      ),

                      Container(
                        padding: const EdgeInsets.all(3),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: notificationTypeColor.withOpacity(.15),
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: CustomText(
                          notification.notificationType.toUpperCase(),
                          fontWeight: FontWeight.w600,
                          textColor: notificationTypeColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),



          Row(  
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [

              Expanded(
                child: _buildField( 
                  title: 'Date',
                  value: formatDate(notification.createdAt)
                ),
              ),


              Expanded(
                child: _buildField(
                  title: 'Time', 
                  value: formatTime(notification.createdAt)
                )
              ),

            ],
          ),


          _buildField(  
            title: 'Title',
            value: notification.title
          ), 


          _buildField(  
            title: 'Message',
            value: notification.message
          ), 

        ],
      ),
    );
  }

  Widget _buildField({required String title, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          HeaderText(title, textColor: Colors.grey.shade600, fontSize: 14),

          CustomText(value),
        ],
      ),
    );
  }
}

//data and time formatters
String formatTime(DateTime dt) {
  return '${dt.hour % 12}:${dt.minute} ${dt.hour >= 12 ? 'pm' : 'am'}';
}

String formatDate(DateTime dt) {
  final now = DateTime.now();

  final day = dt.day;
  final month = dt.month;
  final year = dt.year;

  if (day == now.day && month == now.month && year == now.year) {
    return 'Today';
  }

  if ((now.day - day) == 1 && month == now.month && year == now.year) {
    return 'Yesterday';
  }

  final months = [
    'Jan',
    'Feb',
    'Mar',
    'May',
    'June',
    'July',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec',
  ];

  //todo: change this later.
  return '${months[month % months.length]}. $day, $year';
}
