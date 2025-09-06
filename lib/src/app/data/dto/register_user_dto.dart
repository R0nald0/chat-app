import 'dart:convert';


class RegisterUserDto {
  final String name;
  final String email;
  final DateTime createdAt;
  final DateTime updatedA;
  RegisterUserDto({
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedA,
  });


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedA': updatedA.millisecondsSinceEpoch,
    };
  }

  factory RegisterUserDto.fromMap(Map<String, dynamic> map) {
    return RegisterUserDto(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedA: DateTime.fromMillisecondsSinceEpoch(map['updatedA']),
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterUserDto.fromJson(String source) => RegisterUserDto.fromMap(json.decode(source));
}

