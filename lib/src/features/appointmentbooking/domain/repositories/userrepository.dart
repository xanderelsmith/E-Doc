import 'package:healthai/src/features/authentication/data/models/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Userrepository extends StateNotifier<CustomUserData?> {
  Userrepository() : super(null);

  assignUser(CustomUserData user) {
    state = user;
  }
}

final userDetailsProvider =
    StateNotifierProvider<Userrepository, CustomUserData?>((ref) {
  return Userrepository();
});
