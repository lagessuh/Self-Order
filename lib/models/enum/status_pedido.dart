enum StatusPedido { pendente, preparo, pronto, entregue, cancelado }

extension StatusPedidoExtension on StatusPedido {
  String get name {
    switch (this) {
      case StatusPedido.pendente:
        return 'Pendente';
      case StatusPedido.preparo:
        return 'Em Preparo';
      case StatusPedido.pronto:
        return 'Pronto';
      case StatusPedido.entregue:
        return 'Entregue';
      case StatusPedido.cancelado:
        return 'Cancelado';
    }
  }
}
