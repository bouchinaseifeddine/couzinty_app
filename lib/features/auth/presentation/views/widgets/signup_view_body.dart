import 'package:couzinty/core/utils/app_router.dart';
import 'package:couzinty/core/utils/app_styles.dart';
import 'package:couzinty/core/utils/constants.dart';
import 'package:couzinty/core/utils/size_config.dart';
import 'package:couzinty/core/utils/string_util.dart';
import 'package:couzinty/core/utils/widgets/custom_button.dart';
import 'package:couzinty/core/utils/widgets/custom_loading_indicator.dart';
import 'package:couzinty/features/auth/presentation/viewmodel/signup/signup_cubit.dart';
import 'package:couzinty/features/auth/presentation/viewmodel/signup/signup_state.dart';
import 'package:couzinty/features/auth/presentation/views/signin_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_loadingindicator/flutter_loadingindicator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  //Initially password is obscure
  bool _obscureTextFieldOne = true, _obscureTextFieldTwo = true;
  final _isAuthenticating = false;
  var _entredEmail = '';
  var _entredPassword = '';
  var _entredUserName = '';

  // used to hide the keyboard when the user press submit
  final FocusNode _focusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordControllerConfirm =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordControllerConfirm.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(builder: (context, state) {
      if (state is SignupSuccess) {
        return const SignInView();
      } else if (state is SignupError) {
        EasyLoading.showError(state.errorMessage);
        context.read<SignupCubit>().resetState();
      } else if (state is SignupLoading) {
        return const Center(child: CustomLoadingIncicator());
      }
      return Padding(
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
                    controller: _usernameController,
                    style: AppStyles.styleMedium15(context),
                    onSaved: (value) {
                      _entredUserName = value!;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ce champ est obligatoire';
                      }
                      if (value.trim().length < 4) {
                        return 'Le nom d\'utilisateur doit comporter au moins 4 caractères';
                      }
                      if (value.trim().length > 10) {
                        return 'Le nom d\'utilisateur doit comporter au maximum 10 caractères';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(CupertinoIcons.person),
                      hintText: 'Nom d\'utilisateur',
                    ),
                  ),
                  SizedBox(height: SizeConfig.defaultSize! * 1.6),
                  TextFormField(
                    controller: _emailController,
                    style: AppStyles.styleMedium15(context),
                    onSaved: (value) {
                      _entredEmail = value!;
                    },
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
                      hintText: 'E-mail',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: SizeConfig.defaultSize! * 1.6),
                  TextFormField(
                    controller: _passwordController,
                    onSaved: (value) {
                      _entredPassword = value!;
                    },
                    validator: (String? value) {
                      if (value != null && value.isEmpty) {
                        return 'Ce champ est obligatoire';
                      }

                      if (value!.length < 8) {
                        return 'Le mot de passe doit comporter au moins 8 caractères';
                      }
                      return null;
                    },
                    style: AppStyles.styleMedium15(context),
                    obscureText: _obscureTextFieldOne,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        CupertinoIcons.lock,
                      ),
                      hintText: 'Mot de passe',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureTextFieldOne = !_obscureTextFieldOne;
                          });
                        },
                        child: Icon(
                          _obscureTextFieldOne
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.defaultSize! * 2.3),
                  TextFormField(
                    validator: (String? value) {
                      if (value != null && value.isEmpty) {
                        return "Ce champ est obligatoire";
                      }
                      if (value != _passwordController.text) {
                        return "Mot de passe différent";
                      }
                      return null;
                    },
                    style: AppStyles.styleMedium15(context),
                    controller: _passwordControllerConfirm,
                    obscureText: _obscureTextFieldTwo,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        CupertinoIcons.lock,
                      ),
                      hintText: "Confirmez le mot de passe",
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureTextFieldTwo = !_obscureTextFieldTwo;
                          });
                        },
                        child: Icon(
                          _obscureTextFieldTwo
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: SizeConfig.defaultSize! * 2.3),
                  CustomButton(
                    onTap: () async {
                      final isValid = _formKey.currentState!.validate();

                      if (!isValid) {
                        return;
                      }

                      _formKey.currentState!.save();
                      await context.read<SignupCubit>().signup(
                            _entredEmail,
                            _entredPassword,
                            _entredUserName,
                          );
                    },
                    text: 'S\'inscrire',
                    color: Colors.white,
                    backgroundColor: kMainGreen,
                    fontSize: 16,
                    isLoading: _isAuthenticating,
                    borderRadius: 32,
                  ),
                  SizedBox(height: SizeConfig.defaultSize! * 3),
                  InkWell(
                    onTap: () {
                      GoRouter.of(context).push(AppRouter.kSignInView);
                    },
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: RichText(
                        text: TextSpan(
                          text: 'Vous avez déjà un compte? ',
                          style: AppStyles.styleBold15(context),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Se connecter',
                                style: AppStyles.styleMedium15(context)
                                    .copyWith(
                                        color: kMainGreen,
                                        fontWeight: FontWeight.w800))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
