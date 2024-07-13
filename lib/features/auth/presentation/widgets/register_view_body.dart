import 'package:chateo/core/utils/app_colors.dart';
import 'package:chateo/core/utils/routes.dart';
import 'package:chateo/core/utils/styles.dart';
import 'package:chateo/core/widgets/custom_button.dart';
import 'package:chateo/core/widgets/custom_cherry_toast.dart';
import 'package:chateo/core/widgets/custom_loading_widget.dart';
import 'package:chateo/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:chateo/features/auth/presentation/view_model/change_avatar_cubit.dart';
import 'package:chateo/features/auth/presentation/widgets/avatar_bottom_sheet.dart';
import 'package:chateo/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterViewBody extends StatelessWidget {
  const RegisterViewBody({super.key});

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
                    Expanded(child: SizedBox(height: 10.h)),
                    InkWell(
                        onTap: () {
                          avatarBottomSheet(context);
                        },
                        borderRadius: BorderRadius.circular(100),
                        child: BlocBuilder<ChangeAvatarCubit, String>(
                          builder: (context, image) {
                            context.read<AuthCubit>().avatar = image;
                            return Image.asset(
                              image,
                              width: 120,
                            );
                          },
                        )),
                    SizedBox(height: 50.h),
                    CustomTextFormField(
                      controller: context.read<AuthCubit>().nameController,
                      hintText: 'Name',
                    ),
                    SizedBox(height: 16.h),
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
                        if (state is AuthRegisterSuccess) {
                          Navigator.pushReplacementNamed(
                            context,
                            Routes.loginViewRoute,
                          );
                          successCherryToast(
                            context,
                            'Success',
                            'Register Success',
                          );
                        } else if (state is AuthRegisterFailure) {
                          errorCherryToast(context, 'Error', state.errMessage);
                        }
                      },
                      builder: (context, state) {
                        return state is AuthRegisterLoading
                            ? const CustomLoadingWidget()
                            : CustomButton(
                                text: 'Register',
                                textStyle: Styles.textStyle20
                                    .copyWith(fontWeight: FontWeight.bold),
                                onPressed: () {
                                  context.read<AuthCubit>().register();
                                },
                              );
                      },
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Login',
                            style: Styles.textStyle14.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: SizedBox(height: 10.h))
                  ],
                ),
              )
            ],
          )),
    );
  }
}
