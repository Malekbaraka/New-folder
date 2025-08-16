import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../providers/employee_provider.dart';
import '../providers/theme_provider.dart';
import 'employee_detail_screen.dart';
import 'employee_form_screen.dart';
import 'favorite_employees_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // تحميل قائمة الموظفين عند بدء الشاشة
    Future.microtask(() {
      Provider.of<EmployeeProvider>(context, listen: false).loadEmployees();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'دليل موظفين مستشفيات غزة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // زر البحث
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: EmployeeSearchDelegate(
                  Provider.of<EmployeeProvider>(
                    context,
                    listen: false,
                  ).employees,
                ),
              );
            },
          ),
          // زر الانتقال إلى صفحة المفضلة
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteEmployeesScreen(),
                ),
              );
            },
          ),
          // زر تبديل السمة
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      // عرض قائمة الموظفين
      body: SafeArea(
        child: Consumer<EmployeeProvider>(
          builder: (context, employeeProvider, child) {
            if (employeeProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (employeeProvider.employees.isEmpty) {
              return const Center(child: Text('لا يوجد موظفين'));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: employeeProvider.employees.length,
              itemBuilder: (context, index) {
                final employee = employeeProvider.employees[index];
                return EmployeeListItem(
                  employee: employee,
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
                );
              },
            );
          },
        ),
      ),
      // زر إضافة موظف جديد
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EmployeeFormScreen()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// عنصر قائمة الموظف
class EmployeeListItem extends StatelessWidget {
  final Employee employee;
  final VoidCallback onTap;

  const EmployeeListItem({
    super.key,
    required this.employee,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          radius: 25,
          child: Text(
            employee.name.isNotEmpty ? employee.name[0] : '?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : null,
            ),
          ),
        ),
        title: Text(
          employee.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(employee.position),
            const SizedBox(height: 2),
            Text(
              employee.phoneNumber,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: SizedBox(
          width: 70,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // زر إضافة/إزالة من المفضلة
              IconButton(
                icon: Icon(
                  employee.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: employee.isFavorite ? Colors.red : null,
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
        onTap: onTap,
      ),
    );
  }
}

// كلاس البحث عن الموظفين
class EmployeeSearchDelegate extends SearchDelegate<Employee> {
  final List<Employee> employees;

  EmployeeSearchDelegate(this.employees);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results =
        employees
            .where(
              (employee) =>
                  employee.name.toLowerCase().contains(query.toLowerCase()) ||
                  employee.position.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  employee.phoneNumber.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();

    if (results.isEmpty) {
      return const Center(child: Text('لا يوجد نتائج'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final employee = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Text(
              employee.name.isNotEmpty ? employee.name[0] : '?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : null,
              ),
            ),
          ),
          title: Text(employee.name),
          subtitle: Text(employee.position),
          onTap: () {
            close(context, employee);
            Future.microtask(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => EmployeeDetailScreen(employee: employee),
                ),
              );
            });
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions =
        employees
            .where(
              (employee) =>
                  employee.name.toLowerCase().contains(query.toLowerCase()) ||
                  employee.position.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  employee.phoneNumber.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final employee = suggestions[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Text(
              employee.name.isNotEmpty ? employee.name[0] : '?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : null,
              ),
            ),
          ),
          title: Text(employee.name),
          subtitle: Text(employee.position),
          onTap: () {
            close(context, employee);
            Future.microtask(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => EmployeeDetailScreen(employee: employee),
                ),
              );
            });
          },
        );
      },
    );
  }
}
