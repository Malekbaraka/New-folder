import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../providers/employee_provider.dart';

class EmployeeFormScreen extends StatefulWidget {
  final Employee? employee; // إذا كانت القيمة null فهذا يعني إضافة موظف جديد

  const EmployeeFormScreen({super.key, this.employee});

  @override
  State<EmployeeFormScreen> createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _positionController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _workScheduleController = TextEditingController();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    // إذا كان هناك موظف للتعديل، قم بتعبئة الحقول بالبيانات الحالية
    if (widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _positionController.text = widget.employee!.position;
      _phoneNumberController.text = widget.employee!.phoneNumber;
      _workScheduleController.text = widget.employee!.workSchedule;
      _isFavorite = widget.employee!.isFavorite;
    }
  }

  @override
  void dispose() {
    // تحرير الموارد عند إغلاق الشاشة
    _nameController.dispose();
    _positionController.dispose();
    _phoneNumberController.dispose();
    _workScheduleController.dispose();
    super.dispose();
  }

  // حفظ بيانات الموظف
  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      final employeeProvider = Provider.of<EmployeeProvider>(
        context,
        listen: false,
      );

      // إنشاء كائن الموظف من البيانات المدخلة
      final employee = Employee(
        id: widget.employee?.id, // استخدام معرف الموظف الحالي إذا كان موجوداً
        name: _nameController.text,
        position: _positionController.text,
        phoneNumber: _phoneNumberController.text,
        workSchedule: _workScheduleController.text,
        isFavorite: _isFavorite,
      );

      // إضافة أو تحديث الموظف حسب الحالة
      if (widget.employee == null) {
        employeeProvider.addEmployee(employee);
      } else {
        employeeProvider.updateEmployee(employee);
      }

      // العودة للشاشة السابقة
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.employee == null ? 'إضافة موظف جديد' : 'تعديل بيانات الموظف',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // حقل الاسم
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'الاسم',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال اسم الموظف';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // حقل الوظيفة
                  TextFormField(
                    controller: _positionController,
                    decoration: const InputDecoration(
                      labelText: 'الوظيفة',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.work),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال وظيفة الموظف';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // حقل رقم الجوال
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'رقم الجوال',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رقم جوال الموظف';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // حقل مواعيد العمل
                  TextFormField(
                    controller: _workScheduleController,
                    decoration: const InputDecoration(
                      labelText: 'مواعيد العمل',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.schedule),
                      hintText: 'مثال: السبت - الخميس: 8:00 ص - 3:00 م',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال مواعيد عمل الموظف';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // خيار المفضلة
                  Card(
                    elevation: 2,
                    child: SwitchListTile(
                      title: const Text('إضافة للمفضلة'),
                      value: _isFavorite,
                      onChanged: (value) {
                        setState(() {
                          _isFavorite = value;
                        });
                      },
                      secondary: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // زر الحفظ
                  ElevatedButton(
                    onPressed: _saveEmployee,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: const Color.fromARGB(255, 29, 152, 93),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      widget.employee == null
                          ? 'إضافة الموظف'
                          : 'حفظ التغييرات',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
