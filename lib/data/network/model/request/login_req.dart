class LoginReq {
  final String email;
  final String pw;

  LoginReq({required this.email, required this.pw});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'pw': pw,
    };
  }
}