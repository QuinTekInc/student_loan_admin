
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/auth_bloc.dart';
import 'package:loan_admin/pages/auth/alt_login.dart';

import 'bloc/navigation_bloc.dart';

void main(){
  runApp(LoanAdminApp());
}


class LoanAdminApp extends StatelessWidget {
  const LoanAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthCubit(),
        ),

        BlocProvider(
          create: (_) => NavigationCubit(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
