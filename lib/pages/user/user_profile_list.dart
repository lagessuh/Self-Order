import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:self_order/services/users/users_services.dart';

class UserProfileList extends StatelessWidget {
  const UserProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    UsersServices usersServices = UsersServices();

    return Scaffold(
        appBar: AppBar(title: const Text("Listagem de Ambientes Comuns")),
        body: StreamBuilder<QuerySnapshot>(
          stream: usersServices.getUsers(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<DocumentSnapshot> docSnap = snapshot.data!.docs;
              return Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: docSnap.length,
                  //productManager.allProductsByCategory.length,
                  padding: const EdgeInsets.all(4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14)),
                        child: Column(
                          children: [
                            //Image.network(docSnap[index].get('image')),
                            Text(docSnap[index].get('userName')),
                            Text(docSnap[index].get('email')),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ));
  }
}
