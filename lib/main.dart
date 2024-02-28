import 'package:actionable_tweets/auth/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:actionable_tweets/auth/controllers/auth_controller.dart';
import 'auth/utils/constants.dart';

// void main() {
//   runApp(
//     const ProviderScope(
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends ConsumerWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return MaterialApp(
//         title: 'Actionable Tweets App',
//         theme: AppTheme.theme,
//         home: ref.watch(currentUserAccountProvider).when(
//               data: (user) {
//                 // if (user != null) {
//                 return const SignUp();
//                 // }
//                 //return const TweetPredictionScreen();
//                 //return const WelcomeScreen();
//               },
//               error: (error, st) => ErrorPage(
//                 error: error.toString(),
//               ),
//               loading: () => const LoadingPage(),
//             ));
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebaseInitialization.then((value) => {
        Get.put(AuthController()),
      });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Actionable Tweets App',
      theme: ThemeData(
        //primarySwatch: Colors.blue, // Change this to your desired color
        appBarTheme: const AppBarTheme(
          backgroundColor:
              Color.fromARGB(255, 255, 255, 255), // Set your desired color
        ),
      ),
      home: const SignUp(),
    );
  }
}
