
import 'package:meal_it_admin/Classes/Branch.dart';

abstract class BranchInterface{
  Future<String> createBranch(Branch branch);
  Future<List<Branch>> getAllBranches();
}