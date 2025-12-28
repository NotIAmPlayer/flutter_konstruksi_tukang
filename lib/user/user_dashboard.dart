import 'dart:async';

import 'package:app_konstruksi_tukang/auth.dart';
import 'package:app_konstruksi_tukang/user/user_found_workers_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

enum OrderService { daily, painter, plumber, ceramic }

class _UserDashboardState extends State<UserDashboard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int currentPageIndex = 0;

  final TextEditingController _addressController = TextEditingController();
  String _mapAddressLoadingText = "";

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-6.200, 106.816), // Jakarta (by default)
    zoom: 12.0,
  );

  final Completer<GoogleMapController> _mapController = Completer();
  void _onMapCreated(GoogleMapController controller) {
    if (!_mapController.isCompleted) {
      _mapController.complete(controller);
    }
  }

  void _onTap(LatLng position) {
    if (dialogOpen) return;

    _updateLocation(position);
  }

  LatLng? _selectedLocation;
  OrderService? _selectedOrder;

  Set<Marker> _markers = {};
  void _updateLocation(LatLng latLng, {bool moveMap = true, bool getAddress = true}) async {
    if (!mounted) return;

    setState(() {
      _selectedLocation = latLng;
      _mapAddressLoadingText = getAddress ? "Mencari alamat..." : "Lokasi dipilih.";
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: latLng,
          infoWindow: const InfoWindow(title: 'Lokasi Anda'),
          draggable: true,
          onDragEnd: (newPosition) {
            _updateLocation(newPosition, getAddress: true);
          },
        )
      };
    });

    if (moveMap && _mapController.isCompleted) {
      final GoogleMapController controller = await _mapController.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 12.0),
      ));

      if (getAddress) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

          if (mounted && placemarks.isNotEmpty) {
            Placemark p = placemarks[0];
            String address = [p.street, p.subLocality, p.locality, p.subAdministrativeArea, p.postalCode]
              .where((s) => s != null && s.isNotEmpty).join(', ');

            setState(() {
              _addressController.text = address;
              _mapAddressLoadingText = "Alamat ditemukan.";
            });
          } else if (mounted) {
            setState(() {
              _addressController.text = "";
              _mapAddressLoadingText = "Tidak ada alamat yang ditemukan untuk lokasi ini.";
            });
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _mapAddressLoadingText = "Gagal menemukan alamat otomatis.";
            });
          }
        }
      }
    }
  }

  Future<void> _getLatLngFromAddress() async {
    if (_addressController.text.trim().isEmpty) return;
    if (!mounted) return;

    setState(() {
      _mapAddressLoadingText = "Mencari lokasi dari alamat...";
    });
    try {
      List<Location> locations = await locationFromAddress(_addressController.text);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        _updateLocation(LatLng(loc.latitude, loc.longitude), moveMap: true, getAddress: false);
        setState(() {
          _mapAddressLoadingText = "Lokasi ditemukan di peta.";
        });
      } else {
        setState(() {
          _mapAddressLoadingText = "Alamat tidak ditemukan.";
        });
      }
    } catch (e) {
      setState(() {
        _mapAddressLoadingText = "Gagal mencari lokasi. Periksa koneksi internet.";
      });
    }
  }

  Map<String, dynamic>? userData;
  bool dialogOpen = false;

  void showServiceDialog(BuildContext context) async {
    if (!context.mounted) return;

    setState(() {
      dialogOpen = true;
    });

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Pilih jasa tukang yang tersedia'),
              content: RadioGroup<OrderService>(
                groupValue: _selectedOrder,
                onChanged: (OrderService? val) {
                  setState(() {
                    _selectedOrder = val;
                  });
                },
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    ListTile(
                      title: Text(
                        'Tukang Harian',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      leading: Radio<OrderService>(
                        value: OrderService.daily,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Tukang Cat',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      leading: Radio<OrderService>(
                        value: OrderService.painter,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Tukang Pipa',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      leading: Radio<OrderService>(
                        value: OrderService.plumber,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Tukang Keramik',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      leading: Radio<OrderService>(
                        value: OrderService.ceramic,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        dialogOpen = false;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Kembali')
                ),
                FilledButton(
                    onPressed: () {
                      print(_selectedLocation);
                      print(_selectedOrder);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UserFoundWorkersList()),
                      );
                    },
                    child: const Text('Cari Tukang')
                ),
              ],
            );
          }
        );
      }
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getUserData().then((Map<String, dynamic>? value) {
      if (!mounted) return;

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
      body: <Widget>[
        // Beranda
        Card(
          color: Theme.of(context).colorScheme.primary,
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .stretch,
            children: [
              Row(
                crossAxisAlignment: .center,
                children: [
                  const SizedBox(width: 20),
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey[500],
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
                        (userData?.isNotEmpty ?? false) ? userData!["fullName"] : "-",
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
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.location_pin),
                          labelText: "Alamat Anda",
                          helperText: _mapAddressLoadingText,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: _getLatLngFromAddress,
                            icon: const Icon(Icons.search),
                            tooltip: 'Cari lokasi dari alamat ini',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 240,
                        child: GoogleMap(
                          initialCameraPosition: _initialPosition,
                          onMapCreated: _onMapCreated,
                          onTap: _onTap,
                          markers: _markers,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          zoomControlsEnabled: true,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FilledButton(
                        onPressed: () {
                          showServiceDialog(context);
                        },
                        child: const Text("Pilih Jasa Tukang")
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Pemesanan
        Card(
          color: Theme.of(context).colorScheme.primary,
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .stretch,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .start,
                  children: [
                    const Text(
                      "Pemesanan Saya",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: .bold,
                        fontSize: 32.0,
                      ),
                    ),
                    const Text(
                      "Lihat riwayat pemesanan Anda",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Container(
                margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisSize: .min,
                  mainAxisAlignment: .center,
                  children: [
                    ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: BoxBorder.all(
                                color: Colors.grey,
                                width: 2,
                              )
                          ),
                          margin: const EdgeInsets.all(10.0),
                          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          child: Column(
                            mainAxisAlignment: .center,
                            crossAxisAlignment: .stretch,
                            children: [
                              Text(
                                "Nama Tukang",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: .bold,
                                  fontSize: 28.0,
                                ),
                              ),
                              Text(
                                "Listrik",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: .bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  Text(
                                    "1 Januari 2025",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: .bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Text(
                                    "Selesai",
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: .bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: BoxBorder.all(
                                color: Colors.grey,
                                width: 2,
                              )
                          ),
                          margin: const EdgeInsets.all(10.0),
                          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          child: Column(
                            mainAxisAlignment: .center,
                            crossAxisAlignment: .stretch,
                            children: [
                              Text(
                                "Nama Tukang",
                                style: TextStyle(
                                  fontWeight: .bold,
                                  fontSize: 28.0,
                                ),
                              ),
                              Text(
                                "Listrik",
                                style: TextStyle(
                                  fontWeight: .bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  Text(
                                    "1 Januari 2025",
                                    style: TextStyle(
                                      fontWeight: .bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Text(
                                    "Selesai",
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: .bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Pengaturan
        Card(
          color: Theme.of(context).colorScheme.primary,
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .stretch,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .start,
                  children: [
                    const Text(
                      "Pengaturan",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: .bold,
                        fontSize: 32.0,
                      ),
                    ),
                    const Text(
                      "Kelola akun Anda",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Container(
                margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: .min,
                    mainAxisAlignment: .center,
                    children: [
                      Row(
                        crossAxisAlignment: .center,
                        children: [
                          const SizedBox(width: 20),
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.grey[500],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: .center,
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                (userData?.isNotEmpty ?? false) ? userData!["fullName"] : "-",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Divider(),
                      const SizedBox(height: 5),
                      ListView(
                        shrinkWrap: true,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                const Icon(Icons.person),
                                const SizedBox(width: 10),
                                Text(
                                  'Ubah Profil',
                                  style: TextStyle(
                                    fontWeight: .bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              AppAuthentication.logoutApp(context);
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.logout,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Keluar',
                                  style: TextStyle(
                                    fontWeight: .bold,
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ][currentPageIndex],
    );
  }
}