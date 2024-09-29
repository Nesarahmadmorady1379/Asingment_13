import 'package:flutter/material.dart';
import 'package:notapp/moodle/modle.dart';
import 'package:notapp/screens/adding_userpage.dart';
import 'package:notapp/screens/login.dart';
import 'package:notapp/screens/settings.dart';
import 'package:notapp/utility/Databas_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedDataPage extends StatefulWidget {
  @override
  _SavedDataPageState createState() => _SavedDataPageState();
}

class _SavedDataPageState extends State<SavedDataPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<User> savedDataList = [];
  late SharedPreferences logindata;
  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    var dataList = await _dbHelper.getUserList();
    setState(() {
      savedDataList = dataList;
    });
  }

  void _deleteUser(int id) async {
    await _dbHelper.deleteUser(id);
    _loadSavedData();
  }

  void _editUser(User userData) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddingUserPage(userData: userData),
      ),
    );

    if (result != null) {
      _loadSavedData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: 100,
        child: ListView(
          children: [
            DrawerHeader(
                child: CircleAvatar(
              child: Text(
                'N',
                style: TextStyle(fontSize: 28),
              ),
            )),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                },
                icon: Icon(
                  Icons.settings,
                  size: 50,
                )),
            IconButton(
                onPressed: () async {
                  logindata = await SharedPreferences.getInstance();
                  logindata.setBool('login', true);
                  Navigator.pushReplacement(context,
                      new MaterialPageRoute(builder: (context) => login()));
                },
                icon: Icon(
                  Icons.logout,
                  size: 50,
                )),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Saved Data'),
      ),
      body: body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddingUserPage()));
          setState(() {
            _loadSavedData();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget body() {
    return savedDataList.isNotEmpty
        ? ListView.builder(
            itemCount: savedDataList.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(
                    'Name: ${savedDataList[index].username}',
                    style: TextStyle(fontSize: 25),
                  ),
                  subtitle: Text(
                    'Contact: ${savedDataList[index].password}',
                    style: TextStyle(fontSize: 25),
                  ),
                  onTap: () => _editUser(savedDataList[index]), // Edit the user
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteUser(savedDataList[index].id),
                  ),
                ),
              );
            },
          )
        : Center(child: Text('No saved data available'));
  }
}
