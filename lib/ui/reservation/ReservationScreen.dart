import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../util/utils.dart';
import 'ReservationScreenProvider.dart';

class ReservationScreen extends StatelessWidget {
  const ReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: _appBar(context),
          body: Consumer<ReservationScreenProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    _nameTextField(
                      textFieldTitle: "이름",
                      hintText: "김*픈",
                      controller: provider.holder.nameController,
                    ),
                    _nameTextField(
                      textFieldTitle: "휴대폰번호",
                      hintText: "01012**56**",
                      controller: provider.holder.phoneNumController,
                    ),
                    _nameTextField(
                      textFieldTitle: "비밀번호",
                      hintText: "숫자 5자리",
                      controller: provider.holder.pwdController,
                    ),
                    _nameTextField(
                      textFieldTitle: "비밀번호 확인",
                      hintText: "숫자 5자리",
                      controller: provider.holder.pwdConfirmController,
                    ),
                  ],
                );
              }),
        ));
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 56,
      centerTitle: true,
      title: const Text('예매 고객정보 입력',
          style: TextStyle(
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

class _nameTextField extends StatefulWidget {
  final TextEditingController controller;
  final String textFieldTitle;
  final String hintText;

  bool obscure = false;
  TextInputType textInputType = TextInputType.text;

  _nameTextField({
    super.key,
    required this.controller,
    required this.textFieldTitle,
    required this.hintText,
    this.obscure = false,
    this.textInputType = TextInputType.text
  });

  @override
  State<_nameTextField> createState() => _nameTextFieldState();
}

class _nameTextFieldState extends State<_nameTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
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
            style: const TextStyle(fontSize: 22),
            decoration: InputDecoration(
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
          )
        ]));
  }
}
