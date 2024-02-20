import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whatsapp_messenger/page1.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  void initState() {
    super.initState();
  }

  Future<void> _signUpWithEmailAndPassword() async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    print("Signed up: ${userCredential.user?.uid}");

    Get.snackbar(
      "Success",
      "Signed up successfully",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );

    
     Get.off(const Page1());
  } on FirebaseAuthException catch (e) {
    print("Error: $e");

    Get.snackbar(
      "Error",
      "Failed to sign up: ${e.message}",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}

Future<void> _signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    print("Signed in with Google: ${userCredential.user?.displayName}");

    Get.snackbar(
      "Success",
      "Signed in with Google successfully",
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
    Get.off(Page1());
  } catch (e) {
    print("Error signing in with Google: $e");
    print('Unexpected error during Google Sign-In: $e');
  }
}

 



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text(
              "WELCOME TO WHATSAPP",
              style: TextStyle(
                color: Color.fromARGB(255, 30, 184, 35),
                fontWeight: FontWeight.w900,
                fontSize: 30,
              ),
            ),
            SvgPicture.asset(
              'assets/logo.png',
              semanticsLabel: 'whatsapp logo',
              height: 200,
              width: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(),
                ),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email id',
                    hintText: 'Enter your Email id',
                    prefixIcon: Icon(Icons.mail_outline_rounded),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(),
                ),
                child: TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your Password',
                    prefixIcon: Icon(Icons.password_outlined),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 30, 184, 35),
              ),
              onPressed: () async {
                try {
                  print("testing");
                  await _signInWithGoogle();
                  Get.to(() => const Page1());
                } catch (e) {
                  print('Error signing in: $e');
                }
              },
              child: const Text(
                "SIGN IN WITH GOOGLE",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 30, 184, 35),
              ),
              onPressed: () {
                _signUpWithEmailAndPassword();
              },
              child: const Text(
                "SIGN IN WITH EMAIL",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
