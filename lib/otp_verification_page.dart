import 'package:app_konstruksi_tukang/auth.dart';
import 'package:flutter/material.dart';

class OTPVerificationPage extends StatefulWidget {
  const OTPVerificationPage({super.key});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPage();
}

class _OTPVerificationPage extends State<OTPVerificationPage> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masukkan kode OTP'),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              padding: EdgeInsets.all(10.0),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Text(
                    'Nomor OTP telah dikirimkan ke nomor Anda.\nMasukkan kode OTP yang diberikan.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: .center,
                  ),
                  const SizedBox(height: 40,),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: otpController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: 'Kode OTP Anda',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                    maxLength: 6,
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      String otpCode = otpController.text;

                      AppAuthentication.submitOTP(context, otpCode);
                    },
                    child: Text('Masukkan kode OTP'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}