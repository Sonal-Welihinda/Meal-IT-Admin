import 'package:meal_it_admin/Classes/Rider.dart';

abstract class RiderInterface{
  Future<String> createRiders(Rider rider);
  Future<List<Rider>> getAllRiders();
  Future<String> LoginRider(String email,String password);
}