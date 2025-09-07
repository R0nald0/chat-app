import 'dart:convert';

import 'package:chat/src/app/data/dto/user_dto.dart';


class User {
  final int? id;
   final String name;
   final String email;
   final String password;
   final String? urlImage;

  User({
    this.id,
    required this.urlImage,
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' :id,
      'name': name,
      'email': email,
      'password': password,
      'image_url' : urlImage
    };
  }
  factory User.fromUserDto(UserDto map) {
    return 
      User(
      id: map.id ,
      urlImage:map.imageUrl,
      name: map.name,
      email: map.email,
      password: '',
    );
  }

  factory User.fromMap(Map<String,dynamic> map) {
    return switch(map){
      {
        'id' :final int id,
        'name': final String name,
        'email' : final String email,
        'image_url' : final String urlImage
      } => User(
      id: id ,
      urlImage: urlImage,
      name: name,
      email: email,
      password: '',
    ),
    _=> throw ArgumentError('Invalid json') 
    };
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
