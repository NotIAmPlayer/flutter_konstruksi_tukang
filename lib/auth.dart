import 'package:app_konstruksi_tukang/main.dart';
import 'package:app_konstruksi_tukang/otp_verification_page.dart';
import 'package:app_konstruksi_tukang/user/user_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PendingSignUpData {
  final String fullName;
  final String phoneNumber;
  final RegisterRole role;

  PendingSignUpData({
    required this.fullName,
    required this.phoneNumber,
    required this.role,
  });
}

class AppAuthentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static String? verId;
  static PendingSignUpData? pendingSignUp;

  static bool get isSigningUp => pendingSignUp != null;

  static void startSignUp(
    BuildContext context, {
    required String fullName,
    required String phoneNumber,
    required RegisterRole role,
  }) {
    pendingSignUp = PendingSignUpData(
      fullName: fullName,
      phoneNumber: phoneNumber,
      role: role,
    );

    verifyPhoneNumber(context, phoneNumber);
  }

  static void startLogin(
    BuildContext context, {
      required String phoneNumber,
  }) {
    pendingSignUp = null;

    verifyPhoneNumber(context, phoneNumber);
  }

  static void verifyPhoneNumber(BuildContext context, String number) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+62 $number',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        verId = verificationId;
        print("verificationId $verId");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) => const OTPVerificationPage(),
          ),
        );
        print("code sent");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verId = verificationId;
      },
    );
  }

  static void logoutApp(BuildContext context) async {
    await _firebaseAuth.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (ctx) => const HomePage(title: "Aplikasi Tukang PUPR Jogja")
      ),
    );
  }

  static Future<void> submitOTP(BuildContext context, String otp) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verId!,
        smsCode: otp,
    );

    final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

    final user = userCredential.user!;

    final userDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();

    if (!userDoc.exists && pendingSignUp != null) {
      await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
          'fullName': pendingSignUp!.fullName,
          'phoneNumber': user.phoneNumber,
          'userRole': pendingSignUp!.role.name,
          'createdAt': FieldValue.serverTimestamp(),
      });
    } else if (!userDoc.exists && pendingSignUp == null) {
      await _firebaseAuth.signOut();

      if (!context.mounted) return;

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Akun tidak ditemukan'),
          content: const Text('Nomor telepon ini tidak terdaftar. Silakan mendaftar terlebih dahulu.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage(title: "Aplikasi Tukang PUPR Jogja")),
                );
              },
              child: const Text('Daftar')
            ),
          ],
        ),
      );

      return;
    }

    pendingSignUp = null;
    verId = null;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const UserDashboard()
      ),
    );
  }
}

