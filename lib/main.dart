import 'package:app_konstruksi_tukang/user/user_dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Tukang PUPR Jogja',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue, brightness: Brightness.light),
      ),
      home: const HomePage(title: 'Aplikasi Tukang PUPR Jogja'),
    );
  }
}

enum HomePageForms { login, register }

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageForms selectedForm = HomePageForms.login;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        // Here we take the value from the HomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              padding: EdgeInsets.all(20.0),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  SegmentedButton<HomePageForms>(
                    segments: const <ButtonSegment<HomePageForms>>[
                      ButtonSegment<HomePageForms>(
                        value: HomePageForms.login,
                        label: Text('Masuk'),
                        icon: Icon(Icons.login),
                      ),
                      ButtonSegment<HomePageForms>(
                        value: HomePageForms.register,
                        label: Text('Daftar'),
                        icon: Icon(Icons.app_registration),
                      ),
                    ],
                    selected: <HomePageForms>{selectedForm},
                    onSelectionChanged: (Set<HomePageForms> newSelection) {
                      setState(() {
                        selectedForm = newSelection.first;
                      });
                    },
                    multiSelectionEnabled: false,
                  ),
                  SizedBox(height: 20),

                  selectedForm == HomePageForms.login ? _LoginForm() : _RegisterForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {

  const _LoginForm({super.key});

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              icon: Icon(Icons.phone),
              labelText: 'Nomor Telepon',
              border: OutlineInputBorder(),
            ),
            onChanged: (String newPhoneNum) {
              setState(() {
                phoneNumber = newPhoneNum;
              });
            },
          ),
          SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const UserDashboard(),
                ),
              );
            },
            child: Text('Kirim Kode OTP ke WhatsApp'),
          ),
        ],
      ),
    );
  }
}

enum RegisterRole { user, worker }

class _RegisterForm extends StatefulWidget {

  const _RegisterForm({super.key});

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  String fullName = "";
  String phoneNumber = "";
  RegisterRole? registerAs = RegisterRole.user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.person),
              labelText: 'Nama Lengkap',
              border: OutlineInputBorder(),
            ),
            onChanged: (String newName) {
              setState(() {
                fullName = newName;
              });
            },
          ),
          SizedBox(height: 10),
          TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              icon: Icon(Icons.phone),
              labelText: 'Nomor Telepon',
              border: OutlineInputBorder(),
            ),
            onChanged: (String newPhoneNum) {
              setState(() {
                phoneNumber = newPhoneNum;
              });
            },
          ),
          SizedBox(height: 10),
          RadioGroup<RegisterRole>(
            groupValue: registerAs,
            onChanged: (RegisterRole? val) {
              setState(() {
                registerAs = val;
              });
            },
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Daftar sebagai Pengguna',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  leading: Radio<RegisterRole>(value: RegisterRole.user),
                ),
                ListTile(
                  title: Text(
                    'Daftar sebagai Pekerja',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  leading: Radio<RegisterRole>(value: RegisterRole.worker),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          FilledButton(
            onPressed: () {

            },
            child: Text('Kirim Kode OTP ke WhatsApp'),
          ),
        ],
      ),
    );
  }
}