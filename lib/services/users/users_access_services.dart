// class UsersAccessServices {
//   // Simula um banco de dados ou fonte de permissões
//   final Map<String, List<String>> _accessControl = {
//     'adminPage': ['admin'],
//     'userPage': ['admin', 'user'],
//     'guestPage': ['guest', 'user', 'admin'],
//   };

//   // Método para verificar se um usuário tem acesso a uma página específica
//   bool hasAccess(String tipoUsuario, String page) {
//     if (_accessControl.containsKey(page)) {
//       return _accessControl[page]!.contains(tipoUsuario);
//     }
//     // Se a página não estiver no mapeamento, comportamento padrão: sem acesso
//     return false;
//   }

//   // Exemplo de método para verificar acesso a múltiplas páginas
//   Map<String, bool> checkAccessForPages(
//       String tipoUsuario, List<String> pages) {
//     Map<String, bool> accessResults = {};
//     for (var page in pages) {
//       accessResults[page] = hasAccess(tipoUsuario, page);
//     }
//     return accessResults;
//   }
// }

import 'package:self_order/models/users/users_access.dart';

class UsersAccessServices {
  // Refined access control mapping with more specific roles and permissions
  final Map<String, List<String>> _rolePermissions = {
    'admin': [
      'manage_users',
      'manage_funcionarios',
      'view_reports',
      'manage_orders',
      'manage_menu',
      'manage_settings'
    ],
    'gerente': [
      'view_reports',
      'manage_orders',
      'manage_menu',
      'view_funcionarios'
    ],
    'funcionario': ['manage_orders', 'view_menu'],
    'user': ['place_order', 'view_menu', 'view_order_history'],
    'guest': ['view_menu']
  };

  // Page access mapping
  final Map<String, List<String>> _pageAccess = {
    'adminPage': ['admin'],
    'gerentePage': ['admin', 'gerente'],
    'funcionarioPage': ['admin', 'gerente', 'funcionario'],
    'userPage': ['admin', 'gerente', 'funcionario', 'user'],
    'guestPage': ['guest', 'user', 'funcionario', 'gerente', 'admin'],
  };

  // Check if user has access to a specific page
  bool hasPageAccess(UsersAccess userAccess, String page) {
    if (!userAccess.isActive) return false;

    if (_pageAccess.containsKey(page)) {
      return _pageAccess[page]!.contains(userAccess.tipoUsuario);
    }
    return false;
  }

  // Check if user has a specific permission
  bool hasPermission(UsersAccess userAccess, String permission) {
    if (!userAccess.isActive) return false;

    final userRole = userAccess.tipoUsuario;
    if (userRole != null && _rolePermissions.containsKey(userRole)) {
      return _rolePermissions[userRole]!.contains(permission);
    }
    return false;
  }

  // Check multiple permissions at once
  Map<String, bool> checkMultiplePermissions(
      UsersAccess userAccess, List<String> permissions) {
    return {
      for (var permission in permissions)
        permission: hasPermission(userAccess, permission)
    };
  }

  // Check access for multiple pages at once
  Map<String, bool> checkMultiplePageAccess(
      UsersAccess userAccess, List<String> pages) {
    return {for (var page in pages) page: hasPageAccess(userAccess, page)};
  }

  // Update last access time
  void updateLastAccess(UsersAccess userAccess) {
    userAccess.lastAccessTime = DateTime.now();
  }

  // Validate user access
  bool isValidAccess(UsersAccess userAccess) {
    if (!userAccess.isActive) return false;

    // Check if user type is valid
    if (userAccess.tipoUsuario == null) return false;
    if (!_rolePermissions.containsKey(userAccess.tipoUsuario)) return false;

    return true;
  }
}
