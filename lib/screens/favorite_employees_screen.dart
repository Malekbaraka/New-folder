import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../providers/employee_provider.dart';
import 'employee_detail_screen.dart';

class FavoriteEmployeesScreen extends StatefulWidget {
  const FavoriteEmployeesScreen({super.key});

  @override
  State<FavoriteEmployeesScreen> createState() =>
      _FavoriteEmployeesScreenState();
}

class _FavoriteEmployeesScreenState extends State<FavoriteEmployeesScreen> {
  @override
  void initState() {
    super.initState();
    // تحميل قائمة الموظفين المفضلين عند بدء الشاشة
    Future.microtask(() {
      Provider.of<EmployeeProvider>(context, listen: false).loadEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الموظفين المفضلين'), centerTitle: true),
      // عرض قائمة الموظفين المفضلين
      body: SafeArea(
        child: Consumer<EmployeeProvider>(
          builder: (context, employeeProvider, child) {
            if (employeeProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (employeeProvider.favoriteEmployees.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'لا يوجد موظفين في المفضلة',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: employeeProvider.favoriteEmployees.length,
              itemBuilder: (context, index) {
                final employee = employeeProvider.favoriteEmployees[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      radius: 25,
                      child: Text(
                        employee.name.isNotEmpty ? employee.name[0] : '?',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    title: Text(
                      employee.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(employee.position),
                        const SizedBox(height: 2),
                        Text(
                          employee.phoneNumber,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 70,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // زر إزالة من المفضلة
                          IconButton(
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 22,
                            ),
                            onPressed: () {
                              Provider.of<EmployeeProvider>(
                                context,
                                listen: false,
                              ).toggleFavorite(employee);
                            },
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 14),
                        ],
                      ),
                    ),
                    onTap: () {
                      // الانتقال إلى صفحة تفاصيل الموظف عند النقر على العنصر
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  EmployeeDetailScreen(employee: employee),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
