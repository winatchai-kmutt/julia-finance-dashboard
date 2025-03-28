class ClientInfo {
  final String uid;
  final String name;
  final String email;
  final String address;
  final String logoUrl;

  ClientInfo({
    required this.uid,
    required this.name,
    required this.email,
    required this.address,
    required this.logoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'address': address,
      'logoUrl': logoUrl,
    };
  }

  factory ClientInfo.fromJson({required Map<String, dynamic> json}) =>
      ClientInfo(
        uid: json['uid'],
        name: json['name'],
        email: json['email'],
        address: json['address'],
        logoUrl: json['logoUrl'],
      );

  ClientInfo copyWith({
    String? uid,
    String? name,
    String? email,
    String? address,
    String? logoUrl,
  }) {
    return ClientInfo(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }
}
