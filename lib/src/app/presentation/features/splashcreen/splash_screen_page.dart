import 'package:chat/src/app/core/constants/chat_constants.dart';
import 'package:chat/src/app/core/provider/service_locator.dart';
import 'package:chat/src/app/core/ui/widgets/chat_loader.dart';
import 'package:chat/src/app/presentation/features/splashcreen/bloc/splash_screen_bloc.dart';
import 'package:chat/src/app/presentation/features/splashcreen/bloc/splash_screen_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreenPage extends StatelessWidget {
 final splashBloc = getIt.get<SplashScreenBloc>()..verifyUserOn();
   SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: BlocListener<SplashScreenBloc, SplashScreenState>(
          bloc:splashBloc ,
          listener: (context, state) {
             if (state.status ==SplashScreenStatus.erro) {
               Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
             }
             if (state.status ==SplashScreenStatus.success) {
               Navigator.of(context).pushNamedAndRemoveUntil('/mainvaigation', (_) => false);
             }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ChatConstants.LOGO_APP, scale: 4),
              Text('Loading...', style: TextStyle(fontSize: 17)),
              SizedBox(height: 10),
              ChatLoader(size: 70),
            ],
          ),
        ),
      ),
    );
  }
}
