
import 'package:meal_it_admin/Classes/Admin..dart';

abstract class AdminInterface{
  Future<String> createAdmin(Admin admin);
  Future<List<Admin>> getAllAdmins();
  Future<String> LoginAdmin(String email,String password);
}