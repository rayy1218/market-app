import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supermarket_management/api/service/authentication_service.dart';
import 'package:supermarket_management/model/entity/access_right.dart';
import 'package:supermarket_management/module/auth/ui/login_page.dart';
import 'package:supermarket_management/module/home/ui/home_page.dart';

void main() async {
  await dotenv.load();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(),
      ),
    ],
    child: const StartPage()
  ));
}

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Market',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(brightness: Brightness.light, seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const AuthenticationMiddleware(),
    );
  }
}

class AuthenticationMiddleware extends StatefulWidget {
  const AuthenticationMiddleware({super.key});

  @override
  State<AuthenticationMiddleware> createState() => _AuthenticationMiddlewareState();
}

class _AuthenticationMiddlewareState extends State<AuthenticationMiddleware> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case LogoutState:
              return LoginPage();
            case LogonState:
              return const HomePage();
            default:
              return Container();
          }
        },
    );
  }
}

abstract class AuthenticationState {}

class LogonState extends AuthenticationState {
  String token;
  List<AccessRight>? accessRights;

  LogonState({required this.token}) {
    AuthenticationService.of(token).getAccessRight().then((value) {
      accessRights = value;
    });
  }
}

class LogoutState extends AuthenticationState {}

abstract class AuthenticationEvent {}

class LogInEvent extends AuthenticationEvent {
  String token;

  LogInEvent({required this.token});
}

class LogOutEvent extends AuthenticationEvent {}

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(LogoutState()) {
    on<LogInEvent>((event, emit) {
      emit(LogonState(token: event.token));
    });

    on<LogOutEvent>((event, emit) {
      emit(LogoutState());
    });
  }
}