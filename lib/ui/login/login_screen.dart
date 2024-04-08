import 'package:flutter/material.dart';
import 'package:flutter_srt_seungpil/constants/constants.dart';
import 'package:flutter_srt_seungpil/ui/login/login_state_holder.dart';
import 'package:flutter_srt_seungpil/ui/login/login_view_model.dart';
import 'package:flutter_srt_seungpil/ui/signup/sign_up_screen_route.dart';
import 'package:provider/provider.dart';

import '../util/utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoginScreenStateHolder holder = LoginScreenStateHolder();
    return Consumer<LoginScreenViewModel>(builder: (context, viewModel, child) {
      holder.showErrorDialog(context, viewModel.showErrorDialog,
          viewModel.errorDialogDismissAction, viewModel.errorMessage);
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const OpenObjectLogo(),
                const SRTLogo(),
                LoginScreenTextField(
                    textEditingController: holder.idEditingController,
                    identityText: getStrings(context).login_screen_text_id),
                LoginScreenTextField(
                    textEditingController: holder.pwdEditingController,
                    identityText: getStrings(context).login_screen_text_pw),
                LoginScreenButton(requestLogin: () {
                  holder.loginButtonAction(viewModel.requestLogin, context);
                }),
                Row(
                  children: [
                    LoginScreenCheckBox(stateHolder: holder),
                    const Expanded(flex: 1, child: Spacer()),
                    const LoginScreenSignUp()
                  ],
                ),
              ],
            ),
          ));
    });
  }
}

class OpenObjectLogo extends StatelessWidget {
  const OpenObjectLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: const Padding(
        padding: EdgeInsets.only(top: 40, left: 28),
        child: Image(
          image: AssetImage('${Constants.IMAGE_PATH}img_open_object_logo.png'),
          width: 135.04,
          height: 22,
        ),
      ),
    );
  }
}

class SRTLogo extends StatelessWidget {
  const SRTLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Padding(
          padding: EdgeInsets.only(top: 97),
          child: Image(
            image: AssetImage('${Constants.IMAGE_PATH}img_logo.png'),
            width: 200,
            height: 49,
          )),
    );
  }
}

class LoginScreenTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String identityText;

  const LoginScreenTextField(
      {super.key,
      required this.textEditingController,
      required this.identityText});

  @override
  State<LoginScreenTextField> createState() => _LoginScreenTextFieldState();
}

class _LoginScreenTextFieldState extends State<LoginScreenTextField> {
  late String identityText;
  late TextEditingController textEditingController;
  late double textFieldMargin;

  @override
  void initState() {
    textFieldMargin = widget.identityText == "ID" ? 97 : 12;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 23, right: 23, top: textFieldMargin),
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: const Color(0xFFEEEEEE),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(
                    left: 23, right: 20, top: 20, bottom: 20),
                child: Text(
                  widget.identityText,
                  style:
                      const TextStyle(color: Color(0xFF888888), fontSize: 16),
                )),
            Expanded(
                flex: 1,
                child: TextField(
                    controller: widget.textEditingController,
                    decoration: const InputDecoration(border: InputBorder.none),
                    style:
                        const TextStyle(fontSize: 16, color: Color(0xFF000000)),
                    keyboardType: widget.identityText ==
                            getStrings(context).login_screen_text_pw
                        ? TextInputType.visiblePassword
                        : TextInputType.text,
                    obscureText: widget.identityText ==
                        getStrings(context).login_screen_text_pw))
          ],
        ));
  }
}

class LoginScreenButton extends StatelessWidget {
  final Function() requestLogin;

  const LoginScreenButton({super.key, required this.requestLogin});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 25, left: 24, right: 24),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF476EFF)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))))),
                  onPressed: () {
                    requestLogin();
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        getStrings(context).login_screen_login,
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xFFFFFFFF)),
                      )),
                ))
          ],
        ));
  }
}

class LoginScreenCheckBox extends StatefulWidget {
  final LoginScreenStateHolder stateHolder;

  const LoginScreenCheckBox({super.key, required this.stateHolder});

  @override
  State<LoginScreenCheckBox> createState() => _LoginScreenCheckBoxState();
}

class _LoginScreenCheckBoxState extends State<LoginScreenCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Row(
          children: [
            FutureBuilder(
                future: widget.stateHolder.getSavedId(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == null) {
                      widget.stateHolder.updateIsSaveId(false);
                    } else {
                      widget.stateHolder.updateIsSaveId(true);
                    }
                    return Checkbox(
                        value: widget.stateHolder.isSaveId,
                        onChanged: (value) {
                          setState(() {
                            widget.stateHolder.checkBoxOnChanged(value!);
                          });
                        });
                  } else {
                    return Checkbox(
                        value: widget.stateHolder.isSaveId,
                        onChanged: (value) {
                          setState(() {
                            widget.stateHolder.checkBoxOnChanged(value!);
                          });
                        });
                  }
                }),
            Text(getStrings(context).login_screen_save_id,
                style: const TextStyle(color: Color(0xFF888888), fontSize: 12))
          ],
        ));
  }
}

class LoginScreenSignUp extends StatelessWidget {
  const LoginScreenSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 24),
        child: GestureDetector(
            child: Text(
              getStrings(context).login_screen_sign_up,
              style: const TextStyle(
                  color: Color(0xff666666),
                  fontSize: 17,
                  decoration: TextDecoration.underline),
            ),
            onTap: () {
              Utils.push(context, const SignUpScreenRoute());
            }));
  }
}
