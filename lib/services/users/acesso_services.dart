class AcessoService {
  // Simula um banco de dados ou fonte de permissões
  final Map<String, List<String>> _accessControl = {
    'adminPage': ['admin'],
    'userPage': ['admin', 'user'],
    'guestPage': ['guest', 'user', 'admin'],
  };

  // Método para verificar se um usuário tem acesso a uma página específica
  bool hasAccess(String tipoUsuario, String page) {
    if (_accessControl.containsKey(page)) {
      return _accessControl[page]!.contains(tipoUsuario);
    }
    // Se a página não estiver no mapeamento, comportamento padrão: sem acesso
    return false;
  }

  // Exemplo de método para verificar acesso a múltiplas páginas
  Map<String, bool> checkAccessForPages(
      String tipoUsuario, List<String> pages) {
    Map<String, bool> accessResults = {};
    for (var page in pages) {
      accessResults[page] = hasAccess(tipoUsuario, page);
    }
    return accessResults;
  }
}
