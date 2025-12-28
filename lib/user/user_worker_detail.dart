import 'package:flutter/material.dart';

class UserWorkerDetail extends StatefulWidget {
  const UserWorkerDetail({super.key});

  @override
  State<UserWorkerDetail> createState() => _UserWorkerDetailState();
}

class _UserWorkerDetailState extends State<UserWorkerDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Tukang"),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Card(
        color: Theme.of(context).colorScheme.primary,
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .stretch,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisSize: .min,
                mainAxisAlignment: .center,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.grey[500],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: .center,
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            "Adi Hartono",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: .bold,
                              fontSize: 24.0,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "4.7 / 5",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: .bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              const Icon(Icons.star),
                            ],
                          ),
                          Text(
                            'Sudah terverifikasi!',
                            style: TextStyle(
                              fontWeight: .bold,
                              color: Colors.blue[700],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  const Text(
                    'Keterampilan',
                    textAlign: .start,
                    style: TextStyle(
                      fontWeight: .bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                        child: const Text(
                          'Listrik',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                        child: const Text(
                          'Pemasangan Pipa Air',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                        child: const Text(
                          'Pemasangan Keramik',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {},
                    child: Text(
                      'Hubungi lewat WhatsApp',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: .bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}