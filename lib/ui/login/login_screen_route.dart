import 'package:flutter/cupertino.dart';
import 'package:flutter_srt_seungpil/ui/login/login_screen.dart';
import 'package:flutter_srt_seungpil/ui/login/login_view_model.dart';
import 'package:provider/provider.dart';
import 'login_state_holder.dart';

class LoginScreenRoute extends StatelessWidget {
  const LoginScreenRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => LoginScreenViewModel(),
        child: const LoginScreen());
  }
}
