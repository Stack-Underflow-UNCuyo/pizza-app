class MyUserEntity {
  String userId;
  String email;
  String name;
  bool hasActiveCart;

  MyUserEntity(
      {required this.userId,
      required this.email,
      required this.name,
      required this.hasActiveCart});

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'hasActiveCard': hasActiveCart
    };
  }

  static MyUserEntity fromJson(Map<String, dynamic> json) {
    return MyUserEntity(
        userId: json['userId'],
        email: json['email'],
        name: json['name'],
        hasActiveCart: json['hasActiveCart']);
  }
}
