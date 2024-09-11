class UserModel {
  UserModel(
      {required this.name,
      required this.email,
      required this.uid,
      required this.imageUrl});

  final String? name;
  final String? email;
  final String? uid;
  String? imageUrl;
}
