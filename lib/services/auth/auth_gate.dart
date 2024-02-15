import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:herogamescase/pages/home_page.dart';
import 'package:herogamescase/services/auth/loginorregister.dart';
import 'package:herogamescase/splaspage.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return SplashPage();
          } else {
            return LoginOrRegister();
          }
        },
      ),
    );
  }
}

