
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groupe03_application/home.dart';
import 'package:groupe03_application/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/models/authenticated_user.dart';
import 'data/services/user_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  UserService userService = UserService();

  bool loading = false;

  loginUser() async {
    // déclencher le loading
    setState(() {
      loading = true;
    });

    try {
      // Prépare les données à envoyer
      Map<String, dynamic> data = {
        'email': emailController.text,
        'password': passwordController.text
      };

      // Lancer la requête
      AuthenticatedUser authUser = await userService.login(data);

      // Initialiser une instance de shared preference
      final sharedPref = await SharedPreferences.getInstance();

      // Sauvegerder le token en mémoire
      sharedPref.setString("token", authUser.token!);

      // Afficher un message de succès
      Fluttertoast.showToast(msg: "Utilisateur connecté avec succès");

      // rediriger vers la page home
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } on DioException catch (e) {
      // Quand erreur de requête, afficher les erreurs et le status code
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.statusCode);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }

      Fluttertoast.showToast(msg: "Une erreur est survenue");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Connexion",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            "Page de connexion",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: Text("Nom d'utilisateur"),
                    icon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    return value == null || value == ""
                        ? "Ce champ est obligatoire"
                        : null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text("Mot de passe"),
                    icon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    return value == null || value == ""
                        ? "Ce champ est obligatoire"
                        : null;
                  },
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await loginUser();
              }
            },
            child: loading
                ? const CircularProgressIndicator()
                : const Text("Se connecter"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Register()),
              );
            },
            child: const Text("Créer un compte"),
          ),
        ],
      ),
    );
  }
}
