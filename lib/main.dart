import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FlutterDownloader.initialize();
  // final initFuture = MobileAds.instance.initialize();
  // final adState = AdState(initFuture);
  runApp(MyApp()); //Provider.value(
  // value: adState,
  // builder: (context, child) => MyApp(),);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        textTheme: GoogleFonts.cinzelTextTheme(),
      ),
      title: 'Wallpaper App',
      home: Home(),
    );
  }
}
