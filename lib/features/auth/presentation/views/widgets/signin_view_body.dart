import 'package:couzinty/core/utils/app_router.dart';
import 'package:couzinty/core/utils/app_styles.dart';
import 'package:couzinty/core/utils/constants.dart';
import 'package:couzinty/core/utils/size_config.dart';
import 'package:couzinty/core/utils/string_util.dart';
import 'package:couzinty/core/utils/widgets/custom_button.dart';
import 'package:couzinty/core/utils/widgets/custom_loading_indicator.dart';
import 'package:couzinty/features/auth/presentation/viewmodel/signin_cubit/signin_cubit.dart';
import 'package:couzinty/features/auth/presentation/viewmodel/signin_cubit/signin_state.dart';
import 'package:couzinty/features/navigation/presentation/views/user_navigation.dart';
import 'package:couzinty/features/profile/presentation/views/viewmodel/user_cubit/user_cubit.dart';
import 'package:couzinty/features/recipes_review/presentation/views/recipes_review_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_loadingindicator/flutter_loadingindicator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SignInViewBody extends StatefulWidget {
  const SignInViewBody({super.key});

  @override
  State<SignInViewBody> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignInViewBody> {
  var _entredEmail = '';
  var _entredPassword = '';

  // used to hide the keyboard when the user press submit
  final FocusNode _focusNode = FocusNode();

  //Initially password is obscure
  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninCubit, SigninState>(builder: (context, state) {
      if (state is SigninSuccess) {
        context.read<UserCubit>().setUser(state.user);
        if (state.user.role == 'user') {
          return const UserNavigation();
        } else {
          return const RecipesReviewView();
        }
      } else if (state is SigninLoading) {
        return const Center(child: CustomLoadingIncicator());
      } else {
        if (state is SigninError) {
          EasyLoading.showError(state.errorMessage);
          context.read<SigninCubit>().resetState();
        }

        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/logo.svg',
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        style: AppStyles.styleMedium15(context),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          if (value != null &&
                              value.isNotEmpty &&
                              !StringUtil.isValidEmail(value)) {
                            return 'L\'e-mail n\'est pas valide';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.alternate_email_rounded),
                          hintText: 'Entrer votre Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) {
                          _entredEmail = value!;
                        },
                      ),
                      SizedBox(height: SizeConfig.defaultSize! * 1.6),
                      TextFormField(
                        validator: (String? value) {
                          if (value != null && value.isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                        style: AppStyles.styleMedium15(context),
                        controller: _passwordController,
                        obscureText: _obscureText,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            CupertinoIcons.lock,
                          ),
                          hintText: 'Tapez votre mot de passe',
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        onSaved: (value) {
                          _entredPassword = value!;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.defaultSize! * 3),
                CustomButton(
                  onTap: () async {
                    _focusNode.unfocus();
                    final isValid = _formKey.currentState!.validate();

                    if (!isValid) {
                      return;
                    }

                    _formKey.currentState!.save();
                    await context.read<SigninCubit>().login(
                          _entredEmail,
                          _entredPassword,
                        );
                  },
                  text: 'Sign in',
                  color: Colors.white,
                  fontSize: 16,
                  borderRadius: 32,
                  backgroundColor: kMainGreen,
                ),
                SizedBox(height: SizeConfig.defaultSize! * 2.5),
                InkWell(
                  onTap: () {
                    GoRouter.of(context).pushReplacement(AppRouter.kSignUpView);
                  },
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: RichText(
                      text: TextSpan(
                        text: 'Vous n\'avez pas de compte ? ',
                        style: AppStyles.styleBold15(context),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' S\'inscrire maintenant',
                              style: AppStyles.styleMedium15(context).copyWith(
                                  color: kMainGreen,
                                  fontWeight: FontWeight.w800))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}
