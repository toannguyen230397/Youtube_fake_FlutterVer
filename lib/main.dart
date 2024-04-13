import 'package:flutter/material.dart';
import 'package:youtube_fake/blocs/album_video/album_video_bloc.dart';
import 'package:youtube_fake/blocs/button_press/button_press_bloc.dart';
import 'package:youtube_fake/blocs/interacts_video/interacts_video_bloc.dart';
import 'package:youtube_fake/blocs/login_register/login_register_bloc.dart';
import 'package:youtube_fake/blocs/picker/picker_bloc.dart';
import 'package:youtube_fake/blocs/search_video/search_video_bloc.dart';
import 'package:youtube_fake/blocs/video_manager/video_manager_bloc.dart';
import 'package:youtube_fake/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:youtube_fake/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_fake/screens/test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => VideoManagerBloc()),
        BlocProvider(create: (context) => SearchVideoBloc()),
        BlocProvider(create: (context) => ButtonPressBloc()),
        BlocProvider(create: (context) => InteractsVideoBloc()),
        BlocProvider(create: (context) => LoginRegisterBloc()),
        BlocProvider(create: (context) => AlbumVideoBloc()),
        BlocProvider(create: (context) => PickerBloc()),
        ],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    )
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
//         useMaterial3: true,
//       ),
//       home: Test(),
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (context) => VideoManagerBloc()),
//         BlocProvider(create: (context) => SearchVideoBloc()),
//         BlocProvider(create: (context) => ButtonPressBloc()),
//         BlocProvider(create: (context) => InteractsVideoBloc()),
//         ],
//       child: MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
//         useMaterial3: true,
//       ),
//       home: const Test(),
//     )
//     );
//   }
// }
