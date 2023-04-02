import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_it_admin/Admin_home_tablayout.dart';
import 'package:meal_it_admin/PageLayers/AdminUsersPage.dart';
import 'package:meal_it_admin/Services/FirebaseDBService.dart';

class MealShipLogin extends StatefulWidget {


  @override
  _MealShipLoginState createState() => _MealShipLoginState();
}

class _MealShipLoginState extends State<MealShipLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  FirebaseDBServices _dbServices = FirebaseDBServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 80),
                Center(
                  child: Text(
                    'MealShip login',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 48),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Perform login
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      _dbServices.LoginAdmin(email, password).then((value) => {
                      _dbServices.getUserType(FirebaseAuth.instance.currentUser?.uid),
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                            settings: RouteSettings(name: '/AdminHome'),
                            builder: (context) => Admin_home_tablayout()
                        ),
                        )
                      });
                    }
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
