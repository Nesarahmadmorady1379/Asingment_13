import 'package:flutter/material.dart';
import 'package:notapp/screens/saveddata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController usernamecontrolar = TextEditingController();
  TextEditingController passwordcontrolar = TextEditingController();
  late SharedPreferences logindata;
  late bool newuser;
  @override
  void initState() {
    super.initState();
    cheack_if_alradylogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Login page'),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: usernamecontrolar,
            decoration: InputDecoration(
                hintText: 'Enter your Username',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: passwordcontrolar,
            decoration: InputDecoration(
                hintText: 'Enter your Password',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              String username = usernamecontrolar.text;
              String password = passwordcontrolar.text;
              if (username != '' && password != '') {
                logindata.setBool('login', false);
                logindata.setString('username', username);
                Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => SavedDataPage()));
              }
            },
            child: const Text(
              'Login',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }

  void cheack_if_alradylogin() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    if (newuser == false) {
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (context) => SavedDataPage()));
    }
  }

  @override
  void dispose() {
    super.dispose();
    usernamecontrolar.dispose();
    passwordcontrolar.dispose();
  }
}
