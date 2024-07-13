import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? image;
  final String? createdAt;
  final String? password;
  final String? lastActive;
  final String? about;
  final String? name;
  final bool? isOnline;
  final String? id;
  final String? pushToken;
  final String? email;

  const UserModel({
    this.image,
    this.createdAt,
    this.password,
    this.lastActive,
    this.about,
    this.name,
    this.isOnline,
    this.id,
    this.pushToken,
    this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        image: json['image'] as String?,
        createdAt: json['createdAt'] as String?,
        password: json['password'] as String?,
        lastActive: json['lastActive'] as String?,
        about: json['about'] as String?,
        name: json['name'] as String?,
        isOnline: json['isOnline'] as bool?,
        id: json['id'] as String?,
        pushToken: json['pushToken'] as String?,
        email: json['email'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'image': image,
        'createdAt': createdAt,
        'password': password,
        'lastActive': lastActive,
        'about': about,
        'name': name,
        'isOnline': isOnline,
        'id': id,
        'pushToken': pushToken,
        'email': email,
      };


UserModel? copyWith({required String pushToken}) {
    return UserModel(
      image: image,
      createdAt: createdAt,
      password: password,
      lastActive: lastActive,
      about: about,
      name: name,
      isOnline: isOnline,
      id: id,
      pushToken: pushToken,
      email: email,
    );
  }

  @override
  List<Object?> get props {
    return [
      image,
      createdAt,
      password,
      lastActive,
      about,
      name,
      isOnline,
      id,
      pushToken,
      email,
    ];
  }

  
}
