
import 'package:flutter/material.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() =>
      _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final otpController = TextEditingController();

  double get maxWidth {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return width * 0.92;
    if (width < 1000) return 450;
    return 500;
  }

  @override
  Widget build(BuildContext context) {
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
                  buildCard(),
                ],
              ),
            ),
          ),
        ),
      ),
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.mark_email_read, color: Colors.white, size: 34),
          SizedBox(height: 16),
          Text(
            "Verify Your Email",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Enter the 6-digit code sent to your email address.",
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),
        ],
      ),
    );
  }

  // ================= CARD =================
  Widget buildCard() {
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
          const Text(
            "Email Verification",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          buildOtpField(),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                padding:
                const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                // TODO: verify OTP
              },
              child: const Text(
                "Verify",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 14),

          TextButton(
            onPressed: () {
              // TODO: resend OTP
            },
            child: const Text(
              "Resend Code",
              style: TextStyle(color: Colors.green),
            ),
          )
        ],
      ),
    );
  }

  // ================= OTP FIELD =================
  Widget buildOtpField() {
    return TextField(
      controller: otpController,
      keyboardType: TextInputType.number,
      maxLength: 6,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 22,
        letterSpacing: 8,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: "------",
        counterText: "",
        filled: true,
        fillColor: const Color(0xffF1F5F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}