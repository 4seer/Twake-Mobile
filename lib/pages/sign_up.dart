import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:twake/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:twake/blocs/registration_cubit/registration_cubit.dart';
import 'package:twake/config/dimensions_config.dart';
import 'package:twake/config/styles_config.dart';
import 'package:url_launcher/url_launcher.dart';

const link1 = "https://twake.app/en/terms-of-service/";
const link2 = "https://twake.app/en/privacy/";

class SignUp extends StatefulWidget {
  final Function? onCancel;

  const SignUp({
    Key? key,
    this.onCancel,
  }) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _tapGestureRecognizerF = TapGestureRecognizer();
  final _tapGestureRecognizerS = TapGestureRecognizer();
  bool emailExistsErr = false;
  bool exit = false;
  @override
  void initState() {
    _controller.clear();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    _tapGestureRecognizerF.dispose();
    _tapGestureRecognizerS.dispose();
  }

  static bool validateEmail(String value) {
    const String regExpMail =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    if (RegExp(regExpMail).hasMatch(value))
      return true;
    else
      return false;
  }

  void _sendLink(String email) async {
    if (_formKey.currentState!.validate()) {
      final stateRegistration = Get.find<RegistrationCubit>().state;
      if (stateRegistration is RegistrationFailed &&
          stateRegistration.emailExists) {
        Get.find<RegistrationCubit>().prepare();
        await Future.delayed(const Duration(seconds: 1));
      }
      final stateReg = Get.find<RegistrationCubit>().state;
      if (stateReg is RegistrationReady) {
        await Get.find<RegistrationCubit>().signup(
            email: email,
            secretToken: stateReg.secretToken,
            code: stateReg.code);
      }
    } else {
      setState(() {
        emailExistsErr = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: SafeArea(
          child: Row(
            children: <Widget>[
              Container(
                width: 70,
              ),
              Spacer(),
              BlocBuilder<RegistrationCubit, RegistrationState>(
                  bloc: Get.find<RegistrationCubit>(),
                  builder: (ctx, state) {
                    if (state is RegistrationSuccess) {
                      return SizedBox(
                        width: Dim.widthPercent(25),
                        child: Image.asset(
                            'assets/images/3.0x/twake_home_logo.png'),
                      );
                    }
                    return Container();
                  }),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CupertinoButton(
                  child: Icon(
                    CupertinoIcons.clear,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    exit = true;
                    widget.onCancel!();
                    _controller.clear();
                    Get.find<RegistrationCubit>().emit(RegistrationInitial());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<RegistrationCubit, RegistrationState>(
          bloc: Get.find<RegistrationCubit>(),
          buildWhen: (_, currentState) => currentState is! RegistrationAwaiting,
          builder: (ctx, state) {
            if (state is RegistrationReady) {
              exit = false;
              return registrationInitial(emailExists: false, init: false);
            } else if (state is RegistrationSuccess) {
              return registrationSuccess();
            } else if (state is EmailResendSuccess) {
              return registrationSuccess(emailResendSuccess: true);
            } else if (state is EmailResendFailed) {
              return registrationSuccess(emailResendSuccess: false);
            } else if (state is RegistrationFailed) {
              if (state.emailExists) {
                return registrationInitial(emailExists: true, init: false);
              } else {
                return registrationFailed();
              }
            } else {
              return registrationInitial(emailExists: false, init: true);
            }
          },
        ),
      ),
    );
  }

  Widget registrationInitial({required bool emailExists, required bool init}) {
    final List<String> signupAgreement =
        AppLocalizations.of(context)!.signupAgreement.split("#");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 25),
          child: Text(
            AppLocalizations.of(context)!.signup,
            style: TextStyle(
              fontFamily: 'SFProDisplayHeavy',
              fontSize: 28.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 25, right: 25, top: 10),
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: signupAgreement[0],
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Color(0xFF969698),
                  )),
              TextSpan(
                  text: signupAgreement[1],
                  recognizer: _tapGestureRecognizerF
                    ..onTap = () async {
                      if (await canLaunch(link1)) {
                        await launch(
                          link1,
                        );
                      }
                    },
                  style: StylesConfig.signupAgreement),
              TextSpan(
                  text: signupAgreement[2],
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Color(0xFF969698),
                  )),
              TextSpan(
                  text: signupAgreement[3],
                  recognizer: _tapGestureRecognizerS
                    ..onTap = () async {
                      if (await canLaunch(link2)) {
                        await launch(
                          link2,
                        );
                      }
                    },
                  style: StylesConfig.signupAgreement)
            ]),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 15),
          child: Form(
            key: _formKey,
            child: TextFormField(
              validator: (value) {
                if (init || exit) {
                  return null;
                } else {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.emailAddressRequest;
                  }
                  if (validateEmail(value)) {
                    return null;
                  } else {
                    return AppLocalizations.of(context)!.incorrectEmailError;
                  }
                }
              },
              controller: _controller,
              onFieldSubmitted: (_) {
                /*
                      if (_controller.text.indexOf(" ") == -1) {
                        _sendLink(_controller.text);
                      } else {
                        _controller.text = _controller.text
                            .substring(0, _controller.text.indexOf(" "));
                        _sendLink(_controller.text);
                      }
                      */
              },
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.email,
                hintStyle: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffc8c8c8),
                ),
                alignLabelWithHint: true,
                fillColor: Color(0xfff4f4f4),
                filled: true,
                suffix: _formKey.currentState == null
                    ? Container(
                        width: 30,
                        height: 25,
                        padding: EdgeInsets.only(left: 10),
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () => _controller.clear(),
                          iconSize: 15,
                          icon: Icon(CupertinoIcons.clear),
                        ),
                      )
                    : _formKey.currentState!.validate()
                        ? Container(
                            width: 30,
                            height: 25,
                            padding: EdgeInsets.only(left: 10),
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () => _controller.clear(),
                              iconSize: 15,
                              icon: Icon(CupertinoIcons.clear),
                            ),
                          )
                        : CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.white,
                            child: Icon(
                              CupertinoIcons.exclamationmark_circle_fill,
                              color: Colors.red[400],
                              size: 20,
                            ),
                          ),
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    width: 0.0,
                    style: BorderStyle.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (emailExists && emailExistsErr)
          Padding(
            padding: const EdgeInsets.only(left: 35),
            child: Text(
              AppLocalizations.of(context)!.emailAlreadyInUse,
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
          ),
        SizedBox(
          height: Dim.heightPercent(8),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            AppLocalizations.of(context)!.alreadyHaveAnAccount,
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFF969698)),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: () async {
              widget.onCancel!();
              _controller.clear();
              Get.find<RegistrationCubit>().emit(RegistrationInitial());
              await Get.find<AuthenticationCubit>().authenticate();
            },
            child: Text(
              AppLocalizations.of(context)!.signin,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff3840f7),
              ),
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
          child: TextButton(
            onPressed: () {
              emailExistsErr = true;
              final stateRegistration = Get.find<RegistrationCubit>().state;
              if (stateRegistration is RegistrationAwaiting) {
              } else {
                if (_controller.text.indexOf(" ") == -1) {
                  _sendLink(_controller.text);
                } else {
                  _controller.text = _controller.text
                      .substring(0, _controller.text.indexOf(" "));
                  _sendLink(_controller.text);
                }
              }
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFF004DFF),
                borderRadius: BorderRadius.circular(14.0),
              ),
              alignment: Alignment.center,
              child: BlocBuilder<RegistrationCubit, RegistrationState>(
                bloc: Get.find<RegistrationCubit>(),
                builder: (context, state) {
                  if (state is RegistrationAwaiting && !init) {
                    return CircularProgressIndicator();
                  }
                  return Text(
                    AppLocalizations.of(context)!.startUsingTwake,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget registrationSuccess({bool? emailResendSuccess}) {
    return Column(
      children: [
        SizedBox(
          height: Dim.heightPercent(10),
        ),
        SizedBox(
            width: Dim.widthPercent(25),
            child: Image.asset('assets/images/3.0x/send_tile.png')),
        Padding(
          padding: EdgeInsets.only(top: 25, bottom: 15),
          child: Text(
            AppLocalizations.of(context)!.registrationEmailSent,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.normal,
                color: Color(0xFF969698)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
          child: Text(
            _controller.text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
        ),
        emailResendSuccess == null
            ? Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
                child: TextButton(
                  onPressed: () async {
                    final registrationState = Get.find<RegistrationCubit>();
                    if (registrationState is RegistrationAwaiting) {
                    } else {
                      await Get.find<RegistrationCubit>()
                          .resendEmail(email: _controller.text);
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF004DFF),
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    alignment: Alignment.center,
                    child: BlocBuilder<RegistrationCubit, RegistrationState>(
                      bloc: Get.find<RegistrationCubit>(),
                      builder: (context, state) {
                        if (state is RegistrationAwaiting) {
                          return CircularProgressIndicator();
                        } else {
                          return Text(
                            AppLocalizations.of(context)!.resendEmail,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              )
            : emailResendSuccess
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        color: Color(0xFF02A82E),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.emailSent,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF02A82E),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.emailResendFailed,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[400],
                        ),
                      ),
                    ],
                  ),
        TextButton(
          onPressed: () async {
            widget.onCancel!();
            _controller.clear();
            Get.find<RegistrationCubit>().emit(RegistrationInitial());
            await Get.find<AuthenticationCubit>().authenticate();
          },
          child: Text(
            AppLocalizations.of(context)!.signin,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff3840f7),
            ),
          ),
        ),
      ],
    );
  }

  Widget registrationFailed() {
    return Padding(
      padding: EdgeInsets.only(
          left: Dim.widthPercent(10), right: Dim.widthPercent(10)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Text(
              AppLocalizations.of(context)!.signupFailed,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            AppLocalizations.of(context)!.signupFailedInfo,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: Dim.heightPercent(5),
          ),
          Container(
            width: Dim.widthPercent(40),
            child: Image.asset(
              'assets/images/3.0x/emoji_face.png',
            ),
          ),
          SizedBox(
            height: Dim.heightPercent(10),
          ),
          Text(
            AppLocalizations.of(context)!.signupAgainInfo,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.normal,
              color: Color(0xFF8A898E),
            ),
          ),
          SizedBox(
            height: Dim.heightPercent(10),
          ),
          TextButton(
            onPressed: () {
              Get.find<RegistrationCubit>().prepare();
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFF004DFF),
                borderRadius: BorderRadius.circular(14.0),
              ),
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context)!.signupAgain,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
