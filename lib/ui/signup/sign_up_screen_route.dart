import 'package:flutter/cupertino.dart';
import 'package:flutter_srt_seungpil/ui/signup/sign_up_screen.dart';
import 'package:flutter_srt_seungpil/ui/signup/sign_up_screen_view_model.dart';
import 'package:provider/provider.dart';

class SignUpScreenRoute extends StatelessWidget {
  const SignUpScreenRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => SignUpScreenViewModel(),
        child: const SignUpScreen());


  }
}
