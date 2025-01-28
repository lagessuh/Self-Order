class MyPlatformExceptions implements Exception {
  final String code;

  MyPlatformExceptions(this.code);

  String get message {
    switch (code) {
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Credenciais de login inválida. Por favor, verifique a verificação dupla da sua informação';
      case 'too-many-requests':
        return 'Excesso de requisições. Por favor, tente novamente mais tarde';
      case 'invalid-argument':
        return 'Argumento inválido fornecido pelo método de autenticação';
      case 'invalid-password':
        return 'Senha incorreta. Por favor tente novamente';
      case 'invalid-phone-number':
        return 'O número de telefone fornecido está inválido.';
      case 'operation-not-allowed':
        return 'O acesso ao provedor está desabilitado para seu projeto firebase';
      case 'session-cookie-expired':
        return 'O cookie da sessão do Firebase foi expirado. Por favor, faça login de acesso novamente';
      case 'uid-already-exists':
        return 'o Id de usuário fornecido já está em uso por outro usuário';
      case 'sign_in_failed':
        return 'O acesso falhou. Por favor, tente novamente';
      case 'network-request-failed':
        return 'Falha na conexão.Por favor, verifique a sua conexão com a Internet';
      case 'internal-error':
        return 'Falha na conexão.Por favor, verifique a sua conexão com a Internet';
      case 'wrong-password':
        return 'A senha incorreta. Por favor, verifique a sua senha e tente novamente';
      case 'invalid-verification-code':
        return 'Código de verificação inválido. Por favor, entre com um código válido';
      case 'invalid-verification-id':
        return 'Id de verificação inválido. Por favor, requisite um novo código de verificação';
      case 'quota-exceeded':
        return 'Quantidade de tentativa excedida. Por favor, tente novamente mais tarde';
      case 'email-already-exists':
        return 'O endereço de email já existe. Por favor, use um email diferente';

      default:
        return 'Ocorreu um problema na autenticação';
    }
  }

  static String getErrorString(String code) {
    switch (code) {
      case 'ERROR_WEAK_PASSWORD':
        return 'Sua senha é muito fraca.';
      case 'ERROR_INVALID_EMAIL':
        return 'Seu e-mail é inválido.';
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return 'E-mail já está sendo utilizado em outra conta.';
      case 'ERROR_INVALID_CREDENTIAL':
        return 'Seu e-mail é inválido.';
      case 'ERROR_WRONG_PASSWORD':
        return 'Sua senha está incorreta.';
      case 'ERROR_USER_NOT_FOUND':
        return 'Não há usuário com este e-mail.';
      case 'ERROR_USER_DISABLED':
        return 'Este usuário foi desabilitado.';
      case 'ERROR_TOO_MANY_REQUESTS':
        return 'Muitas solicitações. Tente novamente mais tarde.';
      case 'ERROR_OPERATION_NOT_ALLOWED':
        return 'Operação não permitida.';

      default:
        return 'Um erro indefinido ocorreu.';
    }
  }
}
