class SignUpReq {
  final String name;
  final String pw;
  final String birth;
  final String email;

  SignUpReq(this.name, this.pw, this.birth, this.email);

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'pw': pw,
      'birth': birth,
    };
  }
}
