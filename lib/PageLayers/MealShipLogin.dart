import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_it_admin/Admin_home_tablayout.dart';
import 'package:meal_it_admin/Classes/BL.dart';
import 'package:meal_it_admin/PageLayers/AdminUsersPage.dart';
import 'package:meal_it_admin/Services/FirebaseDBService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealShipLogin extends StatefulWidget {


  @override
  _MealShipLoginState createState() => _MealShipLoginState();
}

class _MealShipLoginState extends State<MealShipLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final BusinessLayer _businessL = BusinessLayer();

  Future<void> _saveValue(String field,String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(field, value);
  }



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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Perform login
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      _businessL.LoginAdmin(email, password).then((value)   async {
                        String type = await _businessL.getUserType(FirebaseAuth.instance.currentUser?.uid);
                        if(type.trim().isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Invalid Account ")),
                          );
                          return ;
                        }

                        if(type.trim() == "Branch-Admin"||type.trim() == "AdminHQ"){
                          await _saveValue("AccountType", type);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Success fully login as "+type)),
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                settings: RouteSettings(name: '/AdminHome'),
                                builder: (context) => Admin_home_tablayout()
                            ),
                          );
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Invalid Account !")),
                          );
                        }


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
