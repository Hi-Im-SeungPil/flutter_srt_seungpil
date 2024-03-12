enum ErrorType {
  EMAIL_SEND_ERROR, API_ERROR, EXCEPTION
}

const Map<ErrorType, String> _errorMapper = {
  ErrorType.EMAIL_SEND_ERROR : "이메일을 보내는 도중 오류가 발생했습니다.",
  ErrorType.EXCEPTION: "EXCEPTION 입니다..",
  ErrorType.API_ERROR: "API에러 입니다."
};

String errorMessageMapper(ErrorType errorType) {
  return _errorMapper[errorType] ?? "";
}