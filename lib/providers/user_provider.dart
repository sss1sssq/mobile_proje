import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'auth_provider.dart';

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserModel?>>((ref) {
  return UserProfileNotifier(ref.watch(authServiceProvider));
});

class UserProfileNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService _authService;

  UserProfileNotifier(this._authService) : super(const AsyncValue.data(null));

  Future<void> loadUserProfile(String uid) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.getUserData(uid);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile(UserModel user) async {
    try {
      await _authService.updateUserProfile(user);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void clearProfile() {
    state = const AsyncValue.data(null);
  }
}

