import 'package:flutter/material.dart';
import '../components/list_view.dart';
import '../model/user_model.dart';

import '../external/database/db_sql_lite.dart';

class AdminPage extends StatefulWidget {
  //UserModel user;
  // AdminPage(this.user, {super.key});
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageFormState();
}

class _AdminPageFormState extends State<AdminPage> {
  final db = SqlLiteDb();

  List<UserModel> users = List.empty(growable: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db.getAllUser().then((list) {
      setState(() {
        users = list!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: users.length,
        itemBuilder: (context, index) {
          if (users.isEmpty) {
            return const Center(
              child: Text(
                'No Users Found',
                style: TextStyle(fontSize: 20),
              ),
            );
          } else {
            return UserListView(users: users, index: index,);
          }
        }),
    );
  }
}
