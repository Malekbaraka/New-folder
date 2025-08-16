import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/employee.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // الحصول على قاعدة البيانات
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // تهيئة قاعدة البيانات
  Future<Database> _initDatabase() async {
    String path;

    // التحقق مما إذا كان التطبيق يعمل على الويب
    if (kIsWeb) {
      // استخدام مسار افتراضي للويب
      path = 'hospital_management.db';
    } else {
      // استخدام مسار الجهاز للتطبيقات المحلية
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      path = p.join(documentsDirectory.path, 'hospital_management.db');
    }

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // إنشاء جدول الموظفين
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE employees(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        position TEXT NOT NULL,
        phoneNumber TEXT NOT NULL,
        workSchedule TEXT NOT NULL,
        isFavorite INTEGER NOT NULL DEFAULT 0
      )
      ''');

    // إضافة 25 موظف افتراضي عند إنشاء قاعدة البيانات لأول مرة
    await _insertDefaultEmployees(db);
  }

  // إضافة موظف جديد
  Future<int> insertEmployee(Employee employee) async {
    Database db = await database;
    return await db.insert('employees', employee.toMap());
  }

  // تحديث بيانات موظف
  Future<int> updateEmployee(Employee employee) async {
    Database db = await database;
    return await db.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  // حذف موظف
  Future<int> deleteEmployee(int id) async {
    Database db = await database;
    return await db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }

  // الحصول على قائمة جميع الموظفين
  Future<List<Employee>> getAllEmployees() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('employees');
    return List.generate(maps.length, (i) => Employee.fromMap(maps[i]));
  }

  // الحصول على قائمة الموظفين المفضلين
  Future<List<Employee>> getFavoriteEmployees() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'employees',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => Employee.fromMap(maps[i]));
  }

  // تبديل حالة المفضلة للموظف
  Future<int> toggleFavorite(Employee employee) async {
    Employee updatedEmployee = employee.copyWith(
      isFavorite: !employee.isFavorite,
    );
    return await updateEmployee(updatedEmployee);
  }

  // إضافة 25 موظف افتراضي
  Future<void> _insertDefaultEmployees(Database db) async {
    List<Map<String, dynamic>> defaultEmployees = [
      {
        'name': 'أحمد محمد',
        'position': 'طبيب قلب',
        'phoneNumber': '0501234567',
        'workSchedule': 'السبت - الخميس: 8:00 ص - 3:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'سارة علي',
        'position': 'طبيبة أطفال',
        'phoneNumber': '0591234567',
        'workSchedule': 'الأحد - الخميس: 9:00 ص - 4:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'محمد عبدالله',
        'position': 'جراح عام',
        'phoneNumber': '0561234567',
        'workSchedule': 'السبت - الأربعاء: 7:00 ص - 2:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'فاطمة أحمد',
        'position': 'ممرضة',
        'phoneNumber': '0591234567',
        'workSchedule': 'الأحد - الخميس: 7:00 ص - 7:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'خالد محمد',
        'position': 'طبيب أسنان',
        'phoneNumber': '0591234567',
        'workSchedule': 'السبت - الخميس: 10:00 ص - 6:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'نورة سعد',
        'position': 'طبيبة نساء وولادة',
        'phoneNumber': '0591234567',
        'workSchedule': 'الأحد - الخميس: 8:00 ص - 3:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'عبدالرحمن علي',
        'position': 'طبيب عيون',
        'phoneNumber': '0561234567',
        'workSchedule': 'السبت - الأربعاء: 9:00 ص - 5:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'منى محمد',
        'position': 'صيدلانية',
        'phoneNumber': '0561234567',
        'workSchedule': 'الأحد - الخميس: 8:00 ص - 8:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'يوسف أحمد',
        'position': 'فني مختبر',
        'phoneNumber': '0591234567',
        'workSchedule': 'السبت - الخميس: 7:00 ص - 3:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'ليلى عبدالله',
        'position': 'ممرضة',
        'phoneNumber': '0591234567',
        'workSchedule': 'الأحد - الخميس: 7:00 م - 7:00 ص',
        'isFavorite': 0,
      },
      {
        'name': 'عمر محمد',
        'position': 'طبيب باطنية',
        'phoneNumber': '0561234568',
        'workSchedule': 'السبت - الخميس: 8:00 ص - 4:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'هند سعيد',
        'position': 'طبيبة جلدية',
        'phoneNumber': '0591234568',
        'workSchedule': 'الأحد - الخميس: 10:00 ص - 6:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'سلطان فهد',
        'position': 'طبيب أشعة',
        'phoneNumber': '0561234568',
        'workSchedule': 'السبت - الأربعاء: 8:00 ص - 3:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'عائشة محمد',
        'position': 'ممرضة',
        'phoneNumber': '0591234568',
        'workSchedule': 'الأحد - الخميس: 7:00 ص - 7:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'فيصل عبدالعزيز',
        'position': 'مدير المشفى',
        'phoneNumber': '0591234568',
        'workSchedule': 'السبت - الخميس: 8:00 ص - 4:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'رنا خالد',
        'position': 'أخصائية تغذية',
        'phoneNumber': '0561234568',
        'workSchedule': 'الأحد - الخميس: 9:00 ص - 5:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'ماجد سعود',
        'position': 'طبيب عظام',
        'phoneNumber': '0591234568',
        'workSchedule': 'السبت - الأربعاء: 8:00 ص - 4:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'دانة فهد',
        'position': 'طبيبة أعصاب',
        'phoneNumber': '0561234568',
        'workSchedule': 'الأحد - الخميس: 9:00 ص - 5:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'بدر ناصر',
        'position': 'فني أشعة',
        'phoneNumber': '0561234568',
        'workSchedule': 'السبت - الخميس: 7:00 ص - 3:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'سمية عبدالله',
        'position': 'ممرضة',
        'phoneNumber': '0591234568',
        'workSchedule': 'الأحد - الخميس: 7:00 م - 7:00 ص',
        'isFavorite': 0,
      },
      {
        'name': 'طارق سعد',
        'position': 'طبيب مسالك بولية',
        'phoneNumber': '0561234569',
        'workSchedule': 'السبت - الخميس: 9:00 ص - 5:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'لمى محمد',
        'position': 'طبيبة نفسية',
        'phoneNumber': '0561234569',
        'workSchedule': 'الأحد - الخميس: 10:00 ص - 6:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'نايف عبدالله',
        'position': 'مسؤول إداري',
        'phoneNumber': '0561234569',
        'workSchedule': 'السبت - الخميس: 8:00 ص - 4:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'غادة سعيد',
        'position': 'صيدلانية',
        'phoneNumber': '0591234569',
        'workSchedule': 'الأحد - الخميس: 8:00 ص - 8:00 م',
        'isFavorite': 0,
      },
      {
        'name': 'راشد محمد',
        'position': 'فني مختبر',
        'phoneNumber': '0591234569',
        'workSchedule': 'السبت - الخميس: 7:00 ص - 3:00 م',
        'isFavorite': 0,
      },
    ];

    for (var employee in defaultEmployees) {
      await db.insert('employees', employee);
    }
  }
}
