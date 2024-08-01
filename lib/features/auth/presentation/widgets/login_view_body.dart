import 'package:chateo/core/utils/app_colors.dart';
import 'package:chateo/core/utils/routes.dart';
import 'package:chateo/core/utils/styles.dart';
import 'package:chateo/core/widgets/custom_button.dart';
import 'package:chateo/core/widgets/custom_cherry_toast.dart';
import 'package:chateo/core/widgets/custom_loading_widget.dart';
import 'package:chateo/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:chateo/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: context.read<AuthCubit>().formKey,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/data-protection.png',
                    width: 220,
                  ),
                  SizedBox(height: 40.h),
                  CustomTextFormField(
                    controller: context.read<AuthCubit>().emailController,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16.h),
                  CustomTextFormField(
                    controller: context.read<AuthCubit>().passwordController,
                    hintText: 'Password',
                  ),
                  SizedBox(height: 50.h),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthLoginSuccess) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.usersListViewRoute,
                          (route) => false,
                        );
                      } else if (state is AuthLoginFailure) {
                        errorCherryToast(
                          context,
                          'Error',
                          state.errMessage,
                        );
                      }
                    },
                    builder: (context, state) {
                      return state is AuthLoginLoading
                          ? const CustomLoadingWidget()
                          : CustomButton(
                              text: 'Login',
                              textStyle: Styles.textStyle20
                                  .copyWith(fontWeight: FontWeight.bold),
                              onPressed: () {
                                context.read<AuthCubit>().login();
                              },
                            );
                    },
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, Routes.registerViewRoute);
                        },
                        child: Text(
                          'Register',
                          style: Styles.textStyle14.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
