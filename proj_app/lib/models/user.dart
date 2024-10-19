class MyUser {
  String name;
  String email;
  String? profileImage;

  MyUser({
    required this.name,
    required this.email,
    this.profileImage,
  });

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profileImage': profileImage,
    };
  }
}
