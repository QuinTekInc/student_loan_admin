
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_loan/pages/auth/signup.dart';
import 'package:student_loan/router/app_router.dart';

import '../../bloc/auth_cubit.dart';
import '../../components/text.dart';
import '../student_portal/std_landing_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurePassword = true;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  double get maxWidth {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) return width * 0.92; // mobile
    if (width < 1000) return 450; // tablet
    return 500; // desktop
  }


  //the login button should be disabled by default.
  bool disableButton = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state){
        if(state is AuthError){
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Login Error"),
              content: CustomText(state.errorMessage),
            )
          );
          return;
        }


        if(state is AuthAuthenticated){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StudentLandingPage()
            )
          );
          return;
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xffF6FBF7),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: maxWidth,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      buildHeader(),
                      const SizedBox(height: 20),
                      buildFormCard(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  // ================= HEADER =================
  Widget buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade700,
            Colors.green.shade500,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock, color: Colors.white, size: 34),

          SizedBox(height: 16),

          HeaderText(
            "Welcome Back",
            textColor: Colors.white,
          ),
          SizedBox(height: 8),

          CustomText(
            "Login to continue to your student loan dashboard.",
            textColor: Colors.white70,
            height: 1.5
          ),
        ],
      ),
    );
  }

  // ================= FORM =================
  Widget buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [

          HeaderText(
            "Login",
            fontSize: 22
          ),
          const SizedBox(height: 20),

          CustomTextField(
            controller: usernameController,
            hintText: 'Username',
            leadingIcon: CupertinoIcons.person,
            onChanged: (newValue) => validateFields()
          ),

          const SizedBox(height: 10,),

          CustomPasswordField(
            controller: passwordController,
            onChanged: (newValue) => validateFields(),
          ),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: ()  => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignupPage()
                )
              ),
              child: const Text(
                "Forgot Password?",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: IgnorePointer(
              ignoring: disableButton,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => context.read<AuthCubit>().login(usernameController.text, passwordController.text),
                child: CustomText(
                  "Login",
                  textColor: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText("Don't have an account? ", fontSize: 15,),

              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRouter.signup),
                child: CustomText(
                  "Sign Up",
                  textColor: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )
        ],
      ),
    );
  }



  void validateFields(){

    String username = usernameController.text;
    String password = passwordController.text;

    setState(() => disableButton = username.isEmpty || password.isEmpty);
  }

}