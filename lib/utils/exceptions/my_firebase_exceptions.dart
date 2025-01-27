class MyFirebaseExceptions implements Exception {
  final String code;

  MyFirebaseExceptions(this.code);

  String get message {
    switch (code) {
      case 'unknown':
        return 'Um erro desconhecido ocorreu no Firebase. Por favor, tente novamente';
      case 'invalid-custom-token':
        return 'Formato do token customizado está errado. Por favor, verifique o seu token customizado';
      case 'user-disable':
        return 'A conta do usuário está desabilitada';
      case 'user-not-found':
        return 'Usuário não encontrado para o email dado ou UID';
      case 'invalid-email':
        return 'O endereço de email fornecido está inválido. Por favor, informe um email válido';
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
      case 'email-already-in-use':
        return 'O endereço de email já foi registrado. Por favor, use um email diferente';
      case 'weak-password':
        return 'A senha fornecida é muito fraca.. Por favor, use uma senha forte';
      case 'user-disabled':
        return 'Esta conta de usuário foi desabilitada. Por favor entre em com contato com o suporte';
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Credenciais de login inválida';
      case 'user-token-expired':
        return 'Token expirado e autenticação é obrigatória. Por favor, acesse novamente';
      case 'invalid-action-code':
        return 'O código de ação é inválido. Por favor, verifique o código e tente novamente';
      case 'credential-already-in-use':
        return 'A credencial já está associada com uma conta de usuário diferente';
      default:
        return '(Firebase) Alguma coisa de errado aconteceu';
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
