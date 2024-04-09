import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_srt_seungpil/constants/url.dart';
import 'package:flutter_srt_seungpil/ui/common/common_button.dart';
import 'package:flutter_srt_seungpil/ui/reservation_confirm/reservation_confirm_route.dart';
import 'package:provider/provider.dart';
import '../util/utils.dart';
import 'ReservationScreenProvider.dart';

enum TextFieldKey {
  NAME,
  PHONE_NUM,
  PASSWORD,
  PASSWORD_CONFIRM,
}

class ReservationScreen extends StatelessWidget {
  const ReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(context),
      body: Consumer<ReservationScreenProvider>(
          builder: (context, provider, child) {
        return Column(
          children: [
            _commonTextField(
              id: const ValueKey(TextFieldKey.NAME),
              textFieldTitle: getStrings(context).common_name,
              hintText: getStrings(context).reservation_screen_name_hint,
              controller: provider.holder.nameController,
              errorText: getStrings(context).reservation_screen_name_error,
              doMasking: provider.holder.doMasking,
            ),
            _commonTextField(
                id: const ValueKey(TextFieldKey.PHONE_NUM),
                textFieldTitle: getStrings(context).common_phone_num,
                hintText: getStrings(context).reservation_screen_phone_num_hint,
                controller: provider.holder.phoneNumController,
                errorText:
                    getStrings(context).reservation_screen_phone_num_error,
                doMasking: provider.holder.doMasking),
            _commonTextField(
              id: const ValueKey(TextFieldKey.PASSWORD),
              textFieldTitle: getStrings(context).common_pwd,
              hintText: getStrings(context).reservation_screen_pwd_hint,
              controller: provider.holder.pwdController,
              errorText: getStrings(context).reservation_screen_pwd_error,
              textInputType: TextInputType.number,
              obscure: true,
            ),
            _commonTextField(
              id: const ValueKey(TextFieldKey.PASSWORD_CONFIRM),
              textFieldTitle: getStrings(context).common_pwd_confirm,
              hintText: getStrings(context).reservation_screen_pwd_confirm_hint,
              controller: provider.holder.pwdConfirmController,
              errorText:
                  getStrings(context).reservation_screen_pwd_confirm_error,
              textInputType: TextInputType.number,
              obscure: true,
              pwdController: provider.holder.pwdController,
            ),
            const Spacer(
              flex: 1,
            ),
            _CompleteButton(isAllReady: provider.holder.isAllReady)
          ],
        );
      }),
    ));
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 56,
      centerTitle: true,
      title: Text(getStrings(context).reservation_screen_title,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18)),
      automaticallyImplyLeading: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Utils.pop(context);
        },
      ),
    );
  }
}

class _CompleteButton extends StatelessWidget {
  final bool Function() isAllReady;

  const _CompleteButton({super.key, required this.isAllReady});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: commonButton(
            onPressed: () {
              if (isAllReady()) {
                showTermsSheet(context);
              }
            },
            width: double.infinity,
            height: 48,
            buttonText: getStrings(context).common_success));
  }
}

class _commonTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController? pwdController;
  final String textFieldTitle;
  final String hintText;
  final String errorText;
  late ValueKey<TextFieldKey> id;
  bool errorTextVisibleCondition = false;
  Function(bool)? doMasking;
  late final FocusNode _focusNode = FocusNode();
  int maxLength = 11;

  bool obscure = false;
  TextInputType textInputType = TextInputType.text;

  _commonTextField(
      {super.key,
      required this.controller,
      required this.textFieldTitle,
      required this.hintText,
      required this.errorText,
      required this.id,
      this.doMasking,
      this.obscure = false,
      this.textInputType = TextInputType.text,
      this.pwdController});

  @override
  State<_commonTextField> createState() => _commonTextFieldState();
}

class _commonTextFieldState extends State<_commonTextField> {
  @override
  void initState() {
    widget._focusNode.addListener(() {
      switch (widget.id.value) {
        case TextFieldKey.NAME:
        case TextFieldKey.PHONE_NUM:
          setState(() {
            if (!widget._focusNode.hasFocus) {
              if (widget.controller.text.isEmpty) {
                widget.errorTextVisibleCondition = true;
              } else {
                widget.errorTextVisibleCondition = false;
              }
            }
          });
          break;
        default:
          break;
      }
    });
    if (widget.id.value == TextFieldKey.NAME) {
      widget.controller.addListener(() {
        // widget.doMasking!(true);
      });
    } else if (widget.id.value == TextFieldKey.PHONE_NUM) {
      widget.controller.addListener(() {
        // widget
        // widget.doMasking!(false);
      });
    } else if (widget.id.value == TextFieldKey.PASSWORD) {
      widget.maxLength = 5;
      widget.controller.addListener(() {
        setState(() {
          if (widget.controller.text.length < 5) {
            widget.errorTextVisibleCondition = true;
          } else if (widget.controller.text.length == 5) {
            widget.errorTextVisibleCondition = false;
            FocusScope.of(context).unfocus();
          }
        });
      });
    } else if (widget.id.value == TextFieldKey.PASSWORD_CONFIRM) {
      widget.maxLength = 5;
      widget.pwdController?.addListener(() {
        setState(() {
          if (widget.pwdController?.text.length == 5) {
            FocusScope.of(context).requestFocus(widget._focusNode);
          }
        });
      });
      widget.controller.addListener(() {
        setState(() {
          if (widget.controller.text.length < 5) {
            widget.errorTextVisibleCondition = true;
          } else if (widget.controller.text.length == 5) {
            if (widget.controller.text == widget.pwdController!.text) {
              widget.errorTextVisibleCondition = false;
              FocusScope.of(context).unfocus();
            }
          }
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 9),
        child: Column(children: [
          SizedBox(
              width: double.infinity,
              child: Text(
                widget.textFieldTitle,
                style: const TextStyle(fontSize: 14, color: Color(0xFF888888)),
                textAlign: TextAlign.start,
              )),
          TextField(
            keyboardType: widget.textInputType,
            obscureText: widget.obscure,
            controller: widget.controller,
            focusNode: widget._focusNode,
            maxLength: widget.maxLength,
            style: const TextStyle(fontSize: 22),
            decoration: InputDecoration(
                counterText: "",
                hintText: widget.hintText,
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
          Visibility(
              visible: widget.errorTextVisibleCondition,
              child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(widget.errorText,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFFDA1D1D)),
                      textAlign: TextAlign.start))),
          Visibility(
              visible: !widget.errorTextVisibleCondition,
              child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 5),
                  child: const Text("")))
        ]));
  }
}

Future<dynamic> showTermsSheet(BuildContext context) {
  bool agreeAllTerms = false;
  bool terms1 = false;
  bool terms2 = false;
  bool terms3 = false;

  return showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (BuildContext context) {
        return Wrap(children: [
          StatefulBuilder(
              builder: (BuildContext context, StateSetter bottomState) {
            return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 23),
                        child: Row(children: [
                          Expanded(
                              flex: 1,
                              child: Text(
                                  getStrings(context)
                                      .reservation_screen_terms_all_agree,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500))),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close))
                        ])),
                    Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 16),
                        child: GestureDetector(
                            onTap: () {
                              bottomState(() {
                                if (agreeAllTerms) {
                                  terms1 = false;
                                  terms2 = false;
                                  terms3 = false;
                                  agreeAllTerms = false;
                                } else {
                                  terms1 = true;
                                  terms2 = true;
                                  terms3 = true;
                                  agreeAllTerms = true;
                                }
                              });
                            },
                            child: Row(children: [
                              Icon(Icons.check_circle_outline,
                                  size: 32,
                                  color: agreeAllTerms
                                      ? Colors.blue
                                      : const Color(0xffCCCCCC)),
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    getStrings(context)
                                        .reservation_screen_terms_all_agree,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: agreeAllTerms
                                            ? Colors.black
                                            : const Color(0xff666666)),
                                  ))
                            ]))),
                    Container(
                      color: Colors.black,
                      width: double.infinity,
                      height: 1,
                      margin: const EdgeInsets.only(bottom: 32),
                    ),
                    GestureDetector(
                      child: termsSheetItem(
                          URL_PERSONAL_INFO_USING_TERMS,
                          getStrings(context)
                              .reservation_screen_terms_personal_info_using,
                          terms1),
                      onTap: () {
                        bottomState(() {
                          if (terms1) {
                            terms1 = false;
                            agreeAllTerms = false;
                          } else {
                            terms1 = true;
                            agreeAllTerms = terms1 && terms2 && terms3;
                          }
                        });
                      },
                    ),
                    GestureDetector(
                      child: termsSheetItem(
                          URL_PERSONAL_INFO_PROVIDE_TERMS,
                          getStrings(context)
                              .reservation_screen_terms_personal_info_provide,
                          terms2),
                      onTap: () {
                        bottomState(() {
                          if (terms2) {
                            terms2 = false;
                            agreeAllTerms = false;
                          } else {
                            terms2 = true;
                            agreeAllTerms = terms1 && terms2 && terms3;
                          }
                        });
                      },
                    ),
                    GestureDetector(
                      child: termsSheetItem(
                          URL_MARKETING_INFO_TERMS,
                          getStrings(context)
                              .reservation_screen_terms_marketing,
                          terms3),
                      onTap: () {
                        bottomState(() {
                          if (terms3) {
                            terms3 = false;
                            agreeAllTerms = false;
                          } else {
                            terms3 = true;
                            agreeAllTerms = terms1 && terms2 && terms3;
                          }
                        });
                      },
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 16, top: 28),
                        child: commonButton(
                            onPressed: () {
                              if (terms1 && terms2 && terms3) {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                             const ReservationConfirmRoute(),
                                        settings: const RouteSettings(
                                          arguments: "",
                                        )));
                              }
                            },
                            width: double.infinity,
                            height: 48,
                            buttonText: getStrings(context).common_confirm))
                  ],
                ));
          })
        ]);
      });
}

Widget termsSheetItem(String url, String description, bool isCheckedTerm) {
  return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        SizedBox(
            width: 32,
            height: 32,
            child: Icon(
              Icons.check_rounded,
              size: 18,
              color: isCheckedTerm ? Colors.blue : const Color(0xffAAAAAA),
            )),
        Expanded(
            flex: 1,
            child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 12),
                child: Text(
                  description,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isCheckedTerm
                          ? Colors.black
                          : const Color(0xff666666)),
                ))),
        SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
                onPressed: () {
                  Utils.urlLauncher(url);
                },
                icon: const Icon(
                  Icons.keyboard_arrow_right,
                  size: 16,
                ))),
      ]));
}