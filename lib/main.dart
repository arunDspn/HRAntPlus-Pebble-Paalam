import 'package:ant_pebble_paalam/home/antplus_status/cubit/ant_plus_connection_status_cubit.dart';
import 'package:ant_pebble_paalam/search_devices/connect_ant_device_cubit/connect_ant_device_cubit.dart';
import 'package:ant_pebble_paalam/search_devices/search_result_cubit/search_result_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home/home.dart';

void main() {
  runApp(const MyApp());
}

const kPrimaryColorBackground = Color.fromRGBO(51, 51, 51, 1);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SearchResultCubit(),
        ),
        BlocProvider(
          create: (_) => ConnectAntDeviceCubit(),
        ),
        BlocProvider(
          create: (_) => AntPlusConnectionStatusCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Pebble Ant Paalam',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          scaffoldBackgroundColor: kPrimaryColorBackground,
          textTheme: const TextTheme(
            bodyText1: TextStyle(
              color: Colors.white,
            ),
            bodyText2: TextStyle(
              color: Colors.white,
            ),
            headline4: TextStyle(
              color: Colors.white,
            ),
          ),
          appBarTheme: const AppBarTheme(
            color: Color.fromRGBO(62, 62, 62, 1),
            centerTitle: true,
            elevation: 1,
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.deepOrange,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
