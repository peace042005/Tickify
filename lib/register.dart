import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groupe03_application/data/services/user_service.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final nameController = TextEditingController();
  final prenomController = TextEditingController();
  UserService userService = UserService();

  bool loading = false;

  createUser() async {
    setState(() {
      loading = true;
    });

    try {
      Map<String, dynamic> data = {
        'name': nameController.text.trim(),
        'prenom': prenomController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'password_confirmation': passwordConfirmationController.text
      };

      final result = await userService.create(data);

      if (result.token != null) {
        passwordController.clear();
        passwordConfirmationController.clear();
        nameController.clear();
        prenomController.clear();
        emailController.clear();

        Fluttertoast.showToast(
          msg: "Utilisateur créé avec succès",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Null response");
        print(e.response?.data);
        print(e.response?.statusCode);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }

      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
      );
      //
      // Fluttertoast.showToast(msg: "Une erreur est survenue");
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
          "Création de compte",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            "Créer un compte",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: Text("Nom"),
                    icon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    return value == null || value == ""
                        ? "Ce champ est obligatoire"
                        : null;
                  },
                ),
                TextFormField(
                  controller: prenomController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: Text("Prénom"),
                    icon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    return value == null || value == ""
                        ? "Ce champ est obligatoire"
                        : null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: Text("Email"),
                    icon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    return value == null || value == ""
                        ? "Ce champ est obligatoire"
                        : null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: Text("Mot de passe"),
                    icon: Icon(Icons.password),
                  ),
                  validator: (value) {
                    return value == null || value == ""
                        ? "Ce champ est obligatoire"
                        : null;
                  },
                ),
                TextFormField(
                  controller: passwordConfirmationController,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: Text("Confirmer mot de passe"),
                    icon: Icon(Icons.password),
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
                await createUser();
              }
            },
            child: loading
                ? const CircularProgressIndicator()
                : const Text("Enregistrer"),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const Login()),
              // );
            },
            child: const Text("Se connecter"),
          ),
        ],
      ),
    );
  }
}
