import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

Future<Map<String, dynamic>?> getUserData() async {
  User? user = FirebaseAuth.instance.currentUser;

  var defaultData = <String, dynamic>{
    'fullName': 'Unknown',
    'phoneNumber': '+6212345678901',
    'userRole': 'user',
  };

  if (user != null) {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (doc.exists) {
      return doc.data();
    } else {
      return defaultData;
    }
  } else {
    return defaultData;
  }
}

class _UserDashboardState extends State<UserDashboard> {
  int currentPageIndex = 0;

  Map<String, dynamic>? userData;

  @override
  Widget build(BuildContext context) {
    getUserData().then((Map<String, dynamic>? value) {
      setState(() {
        userData = value;
      });
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.assignment),
            icon: Icon(Icons.assignment_outlined),
            label: 'Pemesanan',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Pengaturan',
          ),
        ],
      ),
      body: Card(
        color: Theme.of(context).colorScheme.primary,
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Row(
              crossAxisAlignment: .center,
              children: [
                const SizedBox(width: 20),
                CircleAvatar(
                  radius: 40,
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .start,
                  children: [
                    const Text(
                      "Hai,",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      userData?["fullName"],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: .bold,
                        fontSize: 32.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  // todo: add a map
                  FilledButton(onPressed: () {}, child: const Text("Pilih Jasa Tukang")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}