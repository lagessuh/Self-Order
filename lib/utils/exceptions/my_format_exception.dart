class MyFormatException implements Exception {
  final String message;
  const MyFormatException(
      [this.message = 'Um erro inesperado de formato ocorreu, Por favor, verifique sua entrada']);
  factory MyFormatException.fromMessage(String msg) {
    return MyFormatException(msg);
  }

  String get formattedMessage => message;
  factory MyFormatException.fromCode(String code) {
    switch (code) {
      case 'invalid-email-format':
        return const MyFormatException(
            'O formato do endereço de email está inválido. Por favor, entre com um email válido');
      case 'invalid-phone-number-format':
        return const MyFormatException(
            'O formato do telefone está inválido. Por favor, entre com um número válido');
      case 'invalid-date-format':
        return const MyFormatException(
            'O formato da data está errado. Por favor, entre com um data válida');
      case 'invalid-url-format':
        return const MyFormatException(
            'O formato da URL está inválida. Por favor, entre com uma URL válida');
      case 'invalid-credit-card-format':
        return const MyFormatException(
            'O formato do cartão de crédito está inválido. Por favor, entre com um número de cartão de crédito válido');
      case 'invalid-numeric-format':
        return const MyFormatException('A entrada de conter um formato númerico válido');
      default:
        return const MyFormatException('Um problema ocorreu');
    }
  }
}
