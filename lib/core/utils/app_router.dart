import 'package:chateo/core/models/user_model.dart';
import 'package:chateo/core/utils/routes.dart';
import 'package:chateo/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:chateo/features/auth/presentation/view_model/change_avatar_cubit.dart';
import 'package:chateo/features/auth/presentation/views/login_view.dart';
import 'package:chateo/features/auth/presentation/views/register_view.dart';
import 'package:chateo/features/chat/presentation/view_model/chat_cubit.dart';
import 'package:chateo/features/chat/presentation/view_model/emoji_cubit.dart';
import 'package:chateo/features/chat/presentation/view_model/image_upload_cubit.dart';
import 'package:chateo/features/chat/presentation/views/chat_view.dart';
import 'package:chateo/features/chat/presentation/views/users_list_view.dart';
import 'package:chateo/features/chat/presentation/widgets/image_preview.dart';
import 'package:chateo/features/profile/presentation/views/profile_view.dart';
import 'package:chateo/features/profile/presentation/views/user_2_profile_view.dart';
import 'package:chateo/features/splash_and_introduction/presentation/views/intro_view.dart';
import 'package:chateo/features/splash_and_introduction/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //!SplashView
      case Routes.splashViewRoute:
        return MaterialPageRoute(
          builder: (context) => const SplashView(),
        );
      //!IntroView
      case Routes.introViewRoute:
        return MaterialPageRoute(
          builder: (context) => const IntroView(),
        );
      //!LoginView
      case Routes.loginViewRoute:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AuthCubit(),
            child: const LoginView(),
          ),
        );
      //!RegisterView
      case Routes.registerViewRoute:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    ChangeAvatarCubit('assets/images/add_image.png'),
              ),
              BlocProvider(
                create: (context) => AuthCubit(),
              ),
            ],
            child: const RegisterView(),
          ),
        );
      //!UsersListView
      case Routes.usersListViewRoute:
        return MaterialPageRoute(
          builder: (context) => const UsersListView(),
        );
     
      //!ChatView
      case Routes.chatViewRoute:
        final args = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ChatCubit(),
              ),
              BlocProvider(
                create: (context) => MediaCubit(),
              ),
              BlocProvider(
                create: (context) => EmojCubit(),
              ),
            ],
            child: ChatView(userModel: args),
          ),
        );
      //!ProfileView
      case Routes.profileViewRoute:
        final user = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    ChangeAvatarCubit(user.image ?? 'assets/images/Avatar.png'),
              ),
              BlocProvider(
                create: (context) => AuthCubit(),
              ),
            ],
            child: ProfileView(user: user),
          ),
        );
      //! image Preview
      case Routes.user2ProfileViewRoute:
        final user = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (context) => User2ProfileView(user: user),
        );
      //! image Preview
      case Routes.imagePreViewViewRoute:
        final imageUrl = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => ImagePreView(imageUrl: imageUrl),
        );
      default:
        return MaterialPageRoute(
          builder: (context) {
            return const Scaffold(
              body: Center(
                child: Text("No Route Found!!"),
              ),
            );
          },
        );
    }
  }
}
