import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../../models/student_model.dart';

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  return AuthService.authStateChanges;
});

// Current user data provider
final currentUserProvider = FutureProvider<Student?>((ref) async {
  final authState = ref.watch(authStateProvider);
  
  return authState.when(
    data: (user) async {
      if (user == null) return null;
      
      final userData = await AuthService.getCurrentUserData();
      if (userData == null) return null;
      
      return Student.fromMap(userData);
    },
    loading: () => null,
    error: (error, stack) => null,
  );
});

// Auth controller
class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController() : super(const AsyncValue.data(null));

  Future<void> signInWithUsername(String username, String password) async {
    state = const AsyncValue.loading();
    
    try {
      await AuthService.signInWithUsername(
        username: username,
        password: password,
      );
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    
    try {
      await AuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String nationalId,
    required String studentPhone,
    required String parentPhone,
    required String stage,
    required int age,
    required String center,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final userData = {
        'fullName': fullName,
        'username': username,
        'nationalId': nationalId,
        'studentPhone': studentPhone,
        'parentPhone': parentPhone,
        'stage': stage,
        'age': age,
        'center': center,
      };

      await AuthService.registerWithEmailAndPassword(
        email: email,
        password: password,
        userData: userData,
      );
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    
    try {
      await AuthService.signOut();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<bool> checkUserApprovalStatus() async {
    try {
      return await AuthService.isUserApproved();
    } catch (error) {
      return false;
    }
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController();
});
