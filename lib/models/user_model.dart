class UserModel {
  final String? name;
  final String? email;
  final String? uid;
  String? imageUrl;

  UserModel(
      {required this.name,
      required this.email,
      required this.uid,
      required this.imageUrl});

  factory UserModel.fromJSON(Map<String, dynamic> user) {
    return UserModel(
        name: user['name'],
        email: user['email'],
        uid: user['uid'],
        imageUrl: user['imageUrl']);
  }
}
