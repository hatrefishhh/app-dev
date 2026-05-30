import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 目前登入的使用者
  User? get currentUser => _auth.currentUser;

  // 監聽登入狀態變化
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Google 登入
  Future<User?> signInWithGoogle() async {
    try {
      // 初始化（7.x 需要先 initialize）
      await GoogleSignIn.instance.initialize();

      // 呼叫登入
      final googleUser = await GoogleSignIn.instance.authenticate();

      // 取得 idToken
      final googleAuth = googleUser.authentication;

      // 建立 Firebase 憑證（7.x 不再有 accessToken，只用 idToken）
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Firebase 登入
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      // 使用者取消登入
      return null;
    }
  }

  // 登出
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }
}
