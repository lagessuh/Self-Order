import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:self_order/commons/mypicked_image.dart';
import 'package:self_order/pages/autenticacao/login_page2.dart';
import 'package:self_order/pages/home/main_page.dart';
import 'package:self_order/pages/user/user_profile_edit_page.dart';
import 'package:self_order/services/cardapio/categoria/categoria_services.dart';
import 'package:self_order/services/cardapio/produto_services.dart';
import 'package:self_order/services/carrinho/carrinho_services.dart';
import 'package:self_order/services/users/funcionario_services.dart';
import 'package:self_order/services/users/cliente_services.dart';

void main() async {
  // var options = const FirebaseOptions(
  //     apiKey: "AIzaSyBjgcsNlHKFZ-CJtXNAK4slslrUri3q9dU",
  //     authDomain: "self-order-ca1c1.firebaseapp.com",
  //     projectId: "self-order-ca1c1",
  //     storageBucket: "self-order-ca1c1.firebasestorage.app",
  //     messagingSenderId: "107557154609",
  //     appId: "1:107557154609:web:5fa7274c181724d13e8a10",
  //     measurementId: "G-NH8PS27XSR");
  var options = const FirebaseOptions(
      apiKey: "AIzaSyAvL70V85C4ripLXm7xCWpxH7xkXkq_eno",
      authDomain: "mercadinho-632c0.firebaseapp.com",
      projectId: "mercadinho-632c0",
      storageBucket: "mercadinho-632c0.appspot.com",
      messagingSenderId: "840564386914",
      appId: "1:840564386914:web:af8be599b497b2aa6f753b",
      measurementId: "G-YBWCNVVTS1");

  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(options: options);
  } else {
    await Firebase.initializeApp();
  }
  await Hive.initFlutter();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ClienteServices>(
          create: (_) => ClienteServices(),
        ),
        ChangeNotifierProvider<MyPickedImage>(
          create: (_) => MyPickedImage(),
        ),
        ChangeNotifierProvider<ProdutoServices>(
          create: (_) => ProdutoServices(),
        ),
        ChangeNotifierProvider<CategoriaServices>(
          create: (_) => CategoriaServices(),
        ),
        ChangeNotifierProvider<CarrinhoServices>(
          create: (_) => CarrinhoServices(),
        ),
        ChangeNotifierProvider<FuncionarioServices>(
          create: (_) => FuncionarioServices(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LoginPage2(),
      routes: {
        '/mainpage': (context) => const MainPage(),
        '/loginpage2': (context) => LoginPage2(),
        '/userprofileeditpage': (context) => UserProfileEditPage(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Erro')),
            body: const Center(child: Text('Página não encontrada')),
          ),
        );
      },
    );
  }
}
