import 'package:app_konstruksi_tukang/user/user_worker_detail.dart';
import 'package:flutter/material.dart';

class UserFoundWorkersList extends StatefulWidget {
  const UserFoundWorkersList({super.key});

  @override
  State<UserFoundWorkersList> createState() => _UserFoundWorkersListState();
}

class _UserFoundWorkersListState extends State<UserFoundWorkersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tukang di Dekatmu"),
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
                                ),
                            ),
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            child: Row(
                              crossAxisAlignment: .center,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.grey[500],
                                ),
                                const SizedBox(width: 10),
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
                                    Text(
                                      "Berjarak 500 meter dari tempatmu",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisSize: .max,
                                      mainAxisAlignment: .spaceBetween,
                                      children: [
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
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => UserWorkerDetail()
                                              ),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                'Cek profil',
                                                style: TextStyle(
                                                  fontWeight: .bold,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              const Icon(Icons.chevron_right),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            )
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: BoxBorder.all(
                                color: Colors.grey,
                                width: 2,
                              ),
                            ),
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            child: Row(
                              crossAxisAlignment: .center,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.grey[500],
                                ),
                                const SizedBox(width: 10),
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
                                    Text(
                                      "Berjarak 500 meter dari tempatmu",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisSize: .max,
                                      mainAxisAlignment: .spaceBetween,
                                      children: [
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
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => UserWorkerDetail()
                                              ),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                'Cek profil',
                                                style: TextStyle(
                                                  fontWeight: .bold,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              const Icon(Icons.chevron_right),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            )
                          ),
                        ],
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