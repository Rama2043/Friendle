import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:friendle/controller/provider/ProfileDataProvider/user_data_provider.dart';
import 'package:friendle/controller/provider/authProvider/auth_provider.dart';
import 'package:friendle/firebase_options.dart';
import 'package:friendle/view/authScreens/signin_logic_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Friendle());
}

class Friendle extends StatelessWidget {
  const Friendle({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, _, __) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<FriendleAuthProvider>(
              create: (context) => FriendleAuthProvider()),
          ChangeNotifierProvider<UserDataProvider>(
              create: (context) => UserDataProvider())
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SigninLogicScreen(),
        ),
      );
    });
  }
}
