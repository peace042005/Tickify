import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groupe03_application/home.dart';
import 'package:groupe03_application/profil.dart';
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
  bool _obscurePassword = true;

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
      AuthenticatedUser apiResponse = await userService.login(data);

      // Initialiser une instance de shared preference
      final sharedPref = await SharedPreferences.getInstance();

      // Sauvegerder le token en mémoire
      sharedPref.setString("token", apiResponse.token!);
      sharedPref.setString("name", apiResponse.user!.name!);
      sharedPref.setString("prenom", apiResponse.user!.prenom!);
      sharedPref.setString("email", apiResponse.user!.email!);

      // Afficher un message de succès
      Fluttertoast.showToast(msg: "Utilisateur connecté avec succès");

      // rediriger vers la page home
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Profil()));

      // Navigator.pop(context);
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
        elevation: 0,
        // centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Connexion",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const Text(
                  "Connectez-vous pour accéder à votre compte",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.alternate_email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          return value == null || value == ""
                              ? "Ce champ est obligatoire"
                              : null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Mot de passe",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          return value == null || value == ""
                              ? "Ce champ est obligatoire"
                              : null;
                        },
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await loginUser();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Se connecter",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Vous n'avez pas de compte? ",
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        "Créer un compte",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
