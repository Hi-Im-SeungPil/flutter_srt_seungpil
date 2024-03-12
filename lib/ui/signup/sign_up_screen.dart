import 'package:flutter/material.dart';
import 'package:flutter_srt_seungpil/ui/common/common_dialog.dart';
import 'package:flutter_srt_seungpil/ui/signup/sign_up_screen_state_holder.dart';
import 'package:flutter_srt_seungpil/ui/signup/sign_up_screen_view_model.dart';
import 'package:provider/provider.dart';
import '../common/common_button.dart';
import '../util/utils.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpScreenStateHolder stateHolder = SignUpScreenStateHolder();
    return SafeArea(
        child: Scaffold(
            appBar: signUpScreenAppBar(),
            body: SingleChildScrollView(child: Consumer<SignUpScreenViewModel>(
                builder: (context, viewModel, child) {
              stateHolder.showErrorDialog(context, viewModel.showErrorDialog,
                  viewModel.errorDialogDismissAction, viewModel.errorMessage);
              return Column(children: [
                SigneUpScreenTextField(
                  textFieldTitle: '아이디',
                  placeHolderText: 'open@openobject.net',
                  controller: stateHolder.idController,
                  buttonText: '인증하기',
                  errorCheck: stateHolder.errorCheck,
                  onPressed: () {
                    stateHolder
                        .sendEmailBtnAction(viewModel.requestSendEmailCode);
                  },
                  isEnable: !(viewModel.isSuccessSendEmailCode &&
                      viewModel.isSuccessVerifyCode),
                ),
                SignUpButton(onPressed: () {
                  stateHolder.signUpBtnAction(
                      viewModel.requestSignUp,
                      viewModel.isSuccessVerifyCode,
                      viewModel.completeSignUp,
                      context);
                }),
                Visibility(
                    visible: stateHolder.isCorrectEmail &&
                        viewModel.isSuccessSendEmailCode &&
                        !viewModel.isSuccessVerifyCode,
                    child: SigneUpScreenTextField(
                      textFieldTitle: '인증코드',
                      placeHolderText: '인증코드',
                      controller: stateHolder.codeController,
                      buttonText: '확인',
                      onPressed: () {
                        stateHolder
                            .verifyCodeBtnAction(viewModel.requestVerifyCode);
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
                            controller: stateHolder.nameController),
                        SigneUpScreenTextField(
                            textFieldTitle: '생년월일',
                            placeHolderText: 'YYMMDD',
                            controller: stateHolder.birthController),
                        SigneUpScreenTextField(
                            textFieldTitle: '비밀번호',
                            placeHolderText: '영문.숫자 조합 8자리 이상',
                            controller: stateHolder.pwdController),
                        SigneUpScreenTextField(
                          textFieldTitle: '비밀번호 확인',
                          placeHolderText: '',
                          controller: stateHolder.confirmPwdController,
                          errorCheck: stateHolder.errorCheck,
                        ),
                        SignUpButton(onPressed: () {
                          stateHolder.signUpBtnAction(
                              viewModel.requestSignUp,
                              viewModel.isSuccessVerifyCode,
                              viewModel.completeSignUp,
                              context);
                        })
                      ],
                    ))
              ]);
            }))));
  }
}

PreferredSizeWidget signUpScreenAppBar() {
  return AppBar(
    title: const Center(child: Text('회원가입')),
    titleTextStyle: const TextStyle(fontSize: 18, color: Color(0xFF000000)),
    actions: [
      IconButton(
          onPressed: () {},
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
      this.updateSignUpTask});

  @override
  State<SigneUpScreenTextField> createState() => _SigneUpScreenTextFieldState();
}

class _SigneUpScreenTextFieldState extends State<SigneUpScreenTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
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
        widget.updateSignUpTask!(widget.textFieldTitle);
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
      widget.updateSignUpTask!(widget.textFieldTitle);
      widget.controller.addListener(() {
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
              keyboardType: widget.textFieldTitle == "생년월일"
                  ? TextInputType.number
                  : TextInputType.text,
              enabled: widget.isEnable,
              focusNode: _focusNode,
              controller: widget.controller,
              style: const TextStyle(fontSize: 22, color: Color(0xff000000)),
              decoration: InputDecoration(
                  hintText: widget.placeHolderText,
                  hintStyle: const TextStyle(color: Color(0xffCCCCCC)),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffCCCCCC)), // 포커스가 있을 때의 색상
                  ),
                  enabledBorder: const UnderlineInputBorder(
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
                    visible: widget.buttonText.isNotEmpty,
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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: commonButton(
            onPressed: onPressed,
            width: double.infinity,
            height: 48,
            buttonText: "가입하기"));
  }
}
