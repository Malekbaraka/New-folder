import 'package:flutter/foundation.dart';
import '../models/employee.dart';
import '../database/database_helper.dart';

class EmployeeProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Employee> _employees = [];
  List<Employee> _favoriteEmployees = [];
  bool _isLoading = false;

  // الحصول على قائمة الموظفين
  List<Employee> get employees => _employees;

  // الحصول على قائمة الموظفين المفضلين
  List<Employee> get favoriteEmployees => _favoriteEmployees;

  // حالة التحميل
  bool get isLoading => _isLoading;

  // تحميل جميع الموظفين من قاعدة البيانات
  Future<void> loadEmployees() async {
    _isLoading = true;
    notifyListeners();

    _employees = await _databaseHelper.getAllEmployees();
    _favoriteEmployees = await _databaseHelper.getFavoriteEmployees();

    _isLoading = false;
    notifyListeners();
  }

  // إضافة موظف جديد
  Future<void> addEmployee(Employee employee) async {
    _isLoading = true;
    notifyListeners();

    await _databaseHelper.insertEmployee(employee);
    await loadEmployees(); // إعادة تحميل القائمة بعد الإضافة
  }

  // تحديث بيانات موظف
  Future<void> updateEmployee(Employee employee) async {
    _isLoading = true;
    notifyListeners();

    await _databaseHelper.updateEmployee(employee);
    await loadEmployees(); // إعادة تحميل القائمة بعد التحديث
  }

  // حذف موظف
  Future<void> deleteEmployee(int id) async {
    _isLoading = true;
    notifyListeners();

    await _databaseHelper.deleteEmployee(id);
    await loadEmployees(); // إعادة تحميل القائمة بعد الحذف
  }

  // تبديل حالة المفضلة للموظف
  Future<void> toggleFavorite(Employee employee) async {
    await _databaseHelper.toggleFavorite(employee);
    await loadEmployees(); // إعادة تحميل القائمة بعد تغيير حالة المفضلة
  }
}
