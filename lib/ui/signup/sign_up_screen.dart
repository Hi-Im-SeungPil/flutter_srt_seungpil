import 'package:flutter/material.dart';
import 'package:flutter_srt_seungpil/ui/signup/sign_up_screen_state_holder.dart';
import 'package:flutter_srt_seungpil/ui/signup/sign_up_screen_view_model.dart';
import 'package:provider/provider.dart';
import '../common/common_button.dart';
import '../util/utils.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpScreenStateHolder holder = SignUpScreenStateHolder();
    return SafeArea(
        child: Scaffold(
            appBar: signUpScreenAppBar(context),
            body: SingleChildScrollView(child: Consumer<SignUpScreenViewModel>(
                builder: (context, viewModel, child) {
              holder.showErrorDialog(context, viewModel.showErrorDialog,
                  viewModel.errorDialogDismissAction, viewModel.errorMessage);
              return Column(children: [
                SigneUpScreenTextField(
                    textFieldTitle: '아이디',
                    placeHolderText: 'open@openobject.net',
                    controller: holder.idController,
                    buttonText: '인증하기',
                    errorCheck: holder.errorCheck,
                    onPressed: () {
                      holder.sendEmailBtnAction(viewModel.requestSendEmailCode);
                    },
                    isEnable: !(viewModel.isSuccessSendEmailCode &&
                        viewModel.isSuccessVerifyCode),
                    isSuccessVerifyCode: viewModel.isSuccessVerifyCode),
                Visibility(
                    visible: holder.isCorrectEmail &&
                        viewModel.isSuccessSendEmailCode &&
                        !viewModel.isSuccessVerifyCode,
                    child: SigneUpScreenTextField(
                      textFieldTitle: '인증코드',
                      placeHolderText: '인증코드',
                      controller: holder.codeController,
                      buttonText: '확인',
                      onPressed: () {
                        holder.verifyCodeBtnAction(viewModel.requestVerifyCode);
                      },
                    )),
                Visibility(
                    visible: viewModel.isSuccessSendEmailCode &&
                        viewModel.isSuccessVerifyCode,
                    child: Column(
                      children: [
                        SigneUpScreenTextField(
                            textFieldTitle: '이름',
                            placeHolderText: '김오픈',
                            controller: holder.nameController),
                        SigneUpScreenTextField(
                            textFieldTitle: '생년월일',
                            placeHolderText: 'YYYYMMDD',
                            controller: holder.birthController),
                        SigneUpScreenTextField(
                            textFieldTitle: '비밀번호',
                            placeHolderText: '영문.숫자 조합 8자리 이상',
                            controller: holder.pwdController,
                            updateSignUpTask: holder.updateSignUpTask),
                        SigneUpScreenTextField(
                          textFieldTitle: '비밀번호 확인',
                          placeHolderText: '',
                          controller: holder.confirmPwdController,
                          errorCheck: holder.errorCheck,
                          updateSignUpTask: holder.updateSignUpTask,
                        ),
                        SignUpButton(onPressed: () {
                          holder.signUpBtnAction(viewModel.requestSignUp,
                              viewModel.isSuccessVerifyCode, context);
                        })
                      ],
                    ))
              ]);
            }))));
  }
}

PreferredSizeWidget signUpScreenAppBar(BuildContext context) {
  return AppBar(
    title: const Center(child: Text('회원가입')),
    titleTextStyle: const TextStyle(fontSize: 18, color: Color(0xFF000000)),
    actions: [
      IconButton(
          onPressed: () {
            Utils.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: Color(0xFF000000),
          ))
    ],
    toolbarHeight: 56,
    automaticallyImplyLeading: false,
    leading: const Spacer(),
  );
}

class SigneUpScreenTextField extends StatefulWidget {
  final String textFieldTitle;
  final String placeHolderText;
  final TextEditingController controller;
  final TextEditingController? pwController;
  String buttonText;
  String errorText;
  Function(String)? errorCheck;
  Function()? onPressed;
  Function(String)? updateSignUpTask;
  bool isEnable;
  bool isSuccessVerifyCode;

   SigneUpScreenTextField(
      {super.key,
      required this.textFieldTitle,
      required this.placeHolderText,
      required this.controller,
      this.buttonText = "",
      this.errorText = "",
      this.errorCheck,
      this.onPressed,
      this.isEnable = true,
      this.pwController,
      this.updateSignUpTask,
      this.isSuccessVerifyCode = false});

  @override
  State<SigneUpScreenTextField> createState() => _SigneUpScreenTextFieldState();
}

class _SigneUpScreenTextFieldState extends State<SigneUpScreenTextField> {
  late FocusNode _focusNode;
  late TextInputType textInputType;
  late bool obscure;

  @override
  void initState() {
    switch (widget.textFieldTitle) {
      case "비밀번호":
      case "비밀번호 확인":
        textInputType = TextInputType.visiblePassword;
        obscure = true;
        break;
      case "생년월일":
        textInputType = TextInputType.number;
        obscure = false;
        break;
      default:
        textInputType = TextInputType.text;
        obscure = false;
    }
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        if (widget.errorCheck != null) {
          if (!_focusNode.hasFocus) {
            widget.errorText = widget.errorCheck!(widget.textFieldTitle);
          } else {
            widget.errorText = "";
          }
        }
      });
    });
    if (widget.textFieldTitle == "비밀번호") {
      widget.controller.addListener(() {
        if (widget.updateSignUpTask != null) {
          widget.updateSignUpTask!(widget.textFieldTitle);
        }
        setState(() {
          if (widget.controller.text.length < 8) {
            widget.errorText = "비밀번호는 8자리 이상입니다.";
          } else {
            widget.errorText = "";
          }
        });
      });
    }
    if (widget.textFieldTitle == "비밀번호 확인") {
      widget.controller.addListener(() {
        if (widget.updateSignUpTask != null) {
          widget.updateSignUpTask!(widget.textFieldTitle);
        }
        if (widget.pwController != null) {
          if (widget.controller.text.length < 8 ||
              widget.controller.text != widget.pwController!.text) {
            widget.errorText = "비밀번호가 일치하지 않습니다.";
          } else {
            widget.errorText = "";
          }
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
        child: Column(
          children: [
            SizedBox(
                width: double.infinity,
                child: Text(
                  widget.textFieldTitle,
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF888888)),
                  textAlign: TextAlign.start,
                )),
            TextField(
              keyboardType: textInputType,
              obscureText: obscure,
              enabled: widget.isEnable,
              focusNode: _focusNode,
              controller: widget.controller,
              style: TextStyle(
                  fontSize: 22,
                  color: widget.isSuccessVerifyCode
                      ? const Color(0xFFCCCCCC)
                      : const Color(0xff000000)),
              decoration: InputDecoration(
                  hintText: widget.placeHolderText,
                  hintStyle: const TextStyle(color: Color(0xffCCCCCC)),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffCCCCCC)), // 포커스가 있을 때의 색상
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffCCCCCC)), // 활성 상태일 때의 색상
                  ),
                  disabledBorder: const UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffCCCCCC)), // 비활성 상태일 때의 색상
                  )),
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          widget.errorText,
                          style: TextStyle(
                              color: widget.errorText.isNotEmpty
                                  ? const Color(0xffDA1D1D)
                                  : const Color(0x00000000)),
                        ))),
                Visibility(
                    visible: widget.buttonText.isNotEmpty &&
                        widget.isSuccessVerifyCode == false,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          commonButton(
                              buttonText: widget.buttonText,
                              width: 150,
                              height: 48,
                              onPressed: () {
                                if (widget.onPressed != null) {
                                  widget.onPressed!();
                                }
                              })
                        ],
                      ),
                    ))
              ],
            )
          ],
        ));
  }
}

class SignUpButton extends StatelessWidget {
  final Function() onPressed;

  const SignUpButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(left: 24, right: 24, bottom: 16, top: 16),
        child: commonButton(
            onPressed: onPressed,
            width: double.infinity,
            height: 48,
            buttonText: "가입하기"));
  }
}
