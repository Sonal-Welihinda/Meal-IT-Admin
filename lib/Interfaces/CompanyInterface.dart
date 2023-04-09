
import 'package:meal_it_admin/Classes/Company.dart';

abstract class CompanyInterface{
  Future<String> createCompany(Company company);
  Future<List<Company>> getAllCompanies();
  Future<String> UpdateCompanyField(String uID,String fieldName,String value);
}