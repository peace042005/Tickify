import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groupe03_application/data/services/user_service.dart';
import 'package:groupe03_application/login.dart';
import 'package:groupe03_application/profil.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;
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

        // Initialiser une instance de shared preference
        final sharedPref = await SharedPreferences.getInstance();

        // Sauvegerder le token en mémoire
        sharedPref.setString("token", result.token!);
        sharedPref.setString("name", result.user!.name!);
        sharedPref.setString("prenom", result.user!.prenom!);
        sharedPref.setString("email", result.user!.email!);

        Fluttertoast.showToast(
          msg: "Utilisateur créé avec succès",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Profil()),
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // print("Null response");
        // print(e.response?.data);
        // print(e.response?.statusCode);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        // print(e.requestOptions);
        // print(e.message);
      }

      Fluttertoast.showToast(
        msg: e.response?.data['message'] ??
            "Une erreur est survenue lors de la création du compte",
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
    // ignore: unused_local_variable
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          "Création de compte",
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.1), // Thickness of the border
          child: Container(
            color: Theme.of(context).colorScheme.onSurface,
            height: 0.1, // Thickness
          ),
        ),
        elevation: 0,
        // titleTextStyle: Theme.of(context).textTheme.titleMedium,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Créer un compte",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const Center(
                  child: Text(
                    "Créer vore compte afin de pouvoir acheter des tickets",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Nom",
                          prefixIcon: const Icon(Icons.person_outline),
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
                        controller: prenomController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Prénom",
                          prefixIcon: const Icon(Icons.person),
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
                        obscureText: _obscurePassword1,
                        decoration: InputDecoration(
                          labelText: "Mot de passe",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword1 = !_obscurePassword1;
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
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordConfirmationController,
                        obscureText: _obscurePassword2,
                        decoration: InputDecoration(
                          labelText: "Confirmer mot de passe",
                          prefixIcon: const Icon(Icons.lock_reset),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword2 = !_obscurePassword2;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Ce champ est obligatoire";
                          }
                          if (value != passwordController.text) {
                            return "Les mots de passe ne correspondent pas";
                          }
                          return null;
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
                        await createUser();
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
                            "Enregistrer",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Vous avez déjà un compte? ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        "Se connecter",
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
