import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_order/models/carrinho/carrinho.dart';
import 'package:self_order/models/enum/status_pedido.dart';
import 'package:self_order/services/carrinho/carrinho_services.dart';

class PedidoManagerPage extends StatelessWidget {
  const PedidoManagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Pedidos'),
      ),
      body: Consumer<CarrinhoServices>(
        builder: (_, carrinhoServices, __) {
          return StreamBuilder(
            stream: carrinhoServices.loadAllCarrinho(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Erro ao carregar pedidos'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final pedidos = snapshot.data?.docs ?? [];

              return ListView.builder(
                itemCount: pedidos.length,
                itemBuilder: (context, index) {
                  final pedidoDoc = pedidos[index];
                  final pedido = pedidoDoc.data() as Map<String, dynamic>;
                  final carrinho = Carrinho.fromMap(pedido);

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ExpansionTile(
                      title: Text('Pedido ${index + 1}'),
                      subtitle:
                          Text('Status: ${carrinho.status ?? "Pendente"}'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Cliente: ${carrinho.userModel?.userName ?? "N/A"}'),
                              Text('Data: ${carrinho.data}'),
                              const Divider(),
                              const Text('Alterar Status:'),
                              Wrap(
                                spacing: 8,
                                children: StatusPedido.values.map((status) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      carrinhoServices.atualizarStatusPedido(
                                        pedidoDoc.id,
                                        status.name,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          _getStatusColor(status.name),
                                    ),
                                    child: Text(status.name),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'preparo':
        return Colors.orange;
      case 'pronto':
        return Colors.green;
      case 'entregue':
        return Colors.blue;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
