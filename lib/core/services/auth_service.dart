import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseService.auth;
  static final FirebaseFirestore _firestore = FirebaseService.firestore;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Auth state stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  static Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with username (convert to email first)
  static Future<UserCredential?> signInWithUsername({
    required String username,
    required String password,
  }) async {
    try {
      // First, find the user by username in the students collection
      QuerySnapshot query = await _firestore
          .collection('students')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw Exception('User not found or not approved');
      }

      DocumentSnapshot userDoc = query.docs.first;
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String email = userData['email'];

      return await signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // Register new user
  static Future<UserCredential?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user data to students_pending collection
      await _firestore
          .collection('students_pending')
          .doc(result.user!.uid)
          .set({
        ...userData,
        'uid': result.user!.uid,
        'email': email,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user data from Firestore
  static Future<Map<String, dynamic>?> getCurrentUserData() async {
    if (currentUser == null) return null;

    try {
      // First check in students collection
      DocumentSnapshot doc = await _firestore
          .collection('students')
          .doc(currentUser!.uid)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }

      // If not found, check in students_pending
      doc = await _firestore
          .collection('students_pending')
          .doc(currentUser!.uid)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get user data: ${e.toString()}');
    }
  }

  // Update user FCM token
  static Future<void> updateFCMToken(String token) async {
    if (currentUser == null) return;

    try {
      await _firestore
          .collection('students')
          .doc(currentUser!.uid)
          .update({'fcmToken': token});
    } catch (e) {
      print('Failed to update FCM token: $e');
    }
  }

  // Check if user is approved
  static Future<bool> isUserApproved() async {
    if (currentUser == null) return false;

    try {
      DocumentSnapshot doc = await _firestore
          .collection('students')
          .doc(currentUser!.uid)
          .get();

      return doc.exists && (doc.data() as Map<String, dynamic>)['status'] == 'approved';
    } catch (e) {
      return false;
    }
  }

  // Handle Firebase Auth exceptions
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}
