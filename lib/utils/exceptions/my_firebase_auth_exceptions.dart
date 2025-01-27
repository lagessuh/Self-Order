class MyFirebaseAuthExceptions implements Exception {
  MyFirebaseAuthExceptions(this.code);

  final String code;

  String get message {
    switch (code) {
      case 'email-already-in-use':
        return 'O endereço de email já foi registrado. Por favor, use um email diferente';
      case 'invalid-email':
        return 'O endereço de email fornecido está inválido. Por favor, entre com um email válido';
      case 'weak-password':
        return 'A senha fornecida é muito fraca.. Por favor, use uma senha forte';
      case 'user-disabled':
        return 'Esta conta de usuário foi desabilitada. Por favor entre em com contato com o suporte';
      case 'user-not-found':
        return 'Detalhes de login inválido. Usuário não encontrado';
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
}
