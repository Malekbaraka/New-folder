import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../providers/employee_provider.dart';
import 'employee_form_screen.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final Employee employee;

  const EmployeeDetailScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الموظف'),
        centerTitle: true,
        actions: [
          // زر تعديل الموظف
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeFormScreen(employee: employee),
                ),
              );
            },
          ),
          // زر حذف الموظف
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // معلومات الموظف
                _buildInfoCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // بناء بطاقة معلومات الموظف
  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: const Color.fromARGB(255, 77, 182, 77),
                child: Text(
                  employee.name.isNotEmpty ? employee.name[0] : '?',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow(Icons.person, 'الاسم', employee.name),
            const Divider(),
            _buildInfoRow(Icons.work, 'الوظيفة', employee.position),
            const Divider(),
            _buildInfoRow(Icons.phone, 'رقم الجوال', employee.phoneNumber),
            const Divider(),
            _buildInfoRow(
              Icons.schedule,
              'مواعيد العمل',
              employee.workSchedule,
            ),
            const SizedBox(height: 20),
            // زر إضافة/إزالة من المفضلة
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Provider.of<EmployeeProvider>(
                    context,
                    listen: false,
                  ).toggleFavorite(employee);
                  Navigator.pop(context); // العودة للشاشة السابقة بعد التحديث
                },
                icon: Icon(
                  employee.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: employee.isFavorite ? Colors.red : null,
                ),
                label: Text(
                  employee.isFavorite ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // بناء صف معلومات
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color.fromARGB(255, 77, 154, 87)),
          const SizedBox(width: 10),
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  // عرض مربع حوار تأكيد الحذف
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: Text('هل أنت متأكد من حذف ${employee.name}؟'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(); // إغلاق مربع الحوار
                },
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  // حذف الموظف
                  if (employee.id != null) {
                    Provider.of<EmployeeProvider>(
                      context,
                      listen: false,
                    ).deleteEmployee(employee.id!);
                  }
                  Navigator.of(ctx).pop(); // إغلاق مربع الحوار
                  Navigator.of(context).pop(); // العودة للشاشة السابقة
                },
                child: const Text('حذف', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
