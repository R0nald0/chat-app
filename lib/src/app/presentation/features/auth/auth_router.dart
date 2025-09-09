import 'package:chat/src/app/core/provider/service_locator.dart';
import 'package:chat/src/app/domain/usecase/login_use_case.dart';
import 'package:chat/src/app/domain/usecase/lout_use_case.dart';
import 'package:chat/src/app/domain/usecase/register_use_case.dart';
import 'package:chat/src/app/presentation/features/auth/bloc/auth_cubit.dart';
import 'package:chat/src/app/presentation/features/auth/login_page.dart';
import 'package:chat/src/app/presentation/features/auth/register_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthRouter {
  static Map<String, WidgetBuilder> route = {
    '/login': (context) => BlocProvider(
        create: (context) => AuthCubit(
          loginUseCase: getIt.get<LoginUseCase>(), 
          registrtUseCase: getIt.get<RegisterUseCase>(), 
          logoutUseCse: getIt.get<LogoutUseCase>()
        ),
        child: LoginPage(),
      )
  };

  static Map<String, WidgetBuilder> routeRegister = {
    '/register': (context) => BlocProvider(
        create: (context) => AuthCubit(
          loginUseCase: getIt.get<LoginUseCase>(), 
          registrtUseCase: getIt.get<RegisterUseCase>(), 
          logoutUseCse: getIt.get<LogoutUseCase>()
        ),
        child: RegisterPage(),
      )
  };
}
