class AppUser {
  final String uid;
  final String email;
  final String name;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
  });

  // convert app user -> json
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'name': name,
  };

  // convert json -> app user
  factory AppUser.fromJson(Map<String, dynamic> json) =>
      AppUser(
        uid: json['uid'],
        email: json['email'],
        name: json['name'],
      );
}
