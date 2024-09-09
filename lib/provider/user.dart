import 'package:flutter_project/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier()
      : super(UserModel(name: null, email: null, uid: null, imageUrl: null));

  void add(UserModel user) {
    state = user;
  }

  void delete() {
    state = UserModel(name: null, email: null, uid: null, imageUrl: null);
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, UserModel>((ref) => UserNotifier());
