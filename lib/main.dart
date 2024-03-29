import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/music_list.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'Changer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<Changer>(create: (_) => Changer()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(fontFamily: 'iransans'),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          DefaultCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('fa', ''),
        ],
        home: music_list(),
      ),
    );
  }
}
