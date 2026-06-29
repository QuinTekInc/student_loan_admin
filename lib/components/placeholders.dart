
import 'package:flutter/material.dart';
import 'package:loan_admin/components/text.dart';


class LoadingPlaceholder extends StatelessWidget {
  const LoadingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          HeaderText('Loading...'),
          CircularProgressIndicator(),
          CustomText('Please wait')
        ],
      ),
    );
  }
}



class MessagePlaceholder extends StatelessWidget {
  
  final String message;
  final VoidCallback? onButtonPressed;
  final IconData? icon;
  final Color? iconColor;
  
  const MessagePlaceholder({
    super.key, 
    required this.message,
    this.icon,
    this.onButtonPressed,
    this.iconColor
  });


  factory MessagePlaceholder.error({
    required String message,
    required VoidCallback onButtonPressed
  }){

    return MessagePlaceholder(
      message: message,
      icon: Icons.warning,
      iconColor: Colors.red.shade700,
      onButtonPressed: onButtonPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center( 
      child: Column( 
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [

          Icon(icon, color: iconColor, size: 60,),

          CustomText(message),

          if(onButtonPressed != null) OutlinedButton(
            onPressed: onButtonPressed,
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.green.shade700)
              ),
            ),

            child: CustomText('Refresh'),
          )

        ],
      ),
    );
  }
}

