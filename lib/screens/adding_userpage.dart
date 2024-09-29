import 'package:flutter/material.dart';
import 'package:notapp/moodle/modle.dart';
import 'package:notapp/screens/saveddata.dart';
import 'package:notapp/utility/Databas_helper.dart';

class AddingUserPage extends StatefulWidget {
  final User?
      userData; // User data passed for editing (can be null if adding a new user)

  const AddingUserPage({Key? key, this.userData}) : super(key: key);

  @override
  _AddingUserPageState createState() => _AddingUserPageState();
}

class _AddingUserPageState extends State<AddingUserPage> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  int? _editingId;

  @override
  void initState() {
    super.initState();

    // If we are editing, pre-fill the fields
    if (widget.userData != null) {
      _editingId = widget.userData!.id;
      _nameController.text = widget.userData!.username;
      _contactController.text = widget.userData!.password.toString();
    }
  }

  void _submitData() async {
    final name = _nameController.text;
    final contact = _contactController.text;
    if (name.isEmpty ||
        contact.isEmpty ||
        contact.length != 10 ||
        !RegExp(r'^\d{10}$').hasMatch(contact)) {
      _showErrorDialog(
          'Please enter a valid name and 10-digit contact number.');
      return;
    }

    if (_editingId != null) {
      var user = User.withId(_editingId, name, int.parse(contact));
      await _dbHelper.updateUser(user);
    } else {
      var user = User(name, int.parse(contact));
      await _dbHelper.insertUser(user);
    }

    _nameController.clear();
    _contactController.clear();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SavedDataPage()));
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(_editingId != null ? 'Edit User' : 'Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _contactController,
              decoration: InputDecoration(
                  hintText: 'Enter Your Contact',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: Text(_editingId != null ? 'Update' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
