class Employee {
  final int? id;
  final String name;
  final String position;
  final String phoneNumber;
  final String workSchedule;
  final bool isFavorite;

  Employee({
    this.id,
    required this.name,
    required this.position,
    required this.phoneNumber,
    required this.workSchedule,
    this.isFavorite = false,
  });

  // تحويل الموظف إلى Map لتخزينه في قاعدة البيانات
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'phoneNumber': phoneNumber,
      'workSchedule': workSchedule,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  // إنشاء موظف من Map مستخرج من قاعدة البيانات
  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      position: map['position'],
      phoneNumber: map['phoneNumber'],
      workSchedule: map['workSchedule'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  // إنشاء نسخة جديدة من الموظف مع تحديث بعض الخصائص
  Employee copyWith({
    int? id,
    String? name,
    String? position,
    String? phoneNumber,
    String? workSchedule,
    bool? isFavorite,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      workSchedule: workSchedule ?? this.workSchedule,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
