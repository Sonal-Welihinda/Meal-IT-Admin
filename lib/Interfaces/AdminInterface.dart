
import 'package:meal_it_admin/Classes/Admin..dart';

abstract class AdminInterface{
  Future<String> createAdmin(Admin admin,String uid);
  Future<List<Admin>> getAllAdmins();
  Future<String> LoginAdmin(String email,String password);
  Future<String> UpdateAdmin(Admin admin);
  Future<String> UpdateAdminField(String uID,String fieldName,String value);
}