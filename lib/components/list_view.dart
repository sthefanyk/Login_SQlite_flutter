import 'package:flutter/material.dart';

import '../model/user_model.dart';

class UserListView extends StatelessWidget {
  const UserListView({super.key, required this.users, required this.index});

  final List<UserModel> users;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    users[index].userId,
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    users[index].userName,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    users[index].userEmail,
                    style: const TextStyle(
                      fontSize: 16.0,
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
