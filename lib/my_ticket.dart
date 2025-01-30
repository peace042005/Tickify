import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groupe03_application/data/services/ticket_service.dart';
import 'package:groupe03_application/data/models/ticket.dart';
import 'package:groupe03_application/login.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Formatage des dates

class MyTicket extends StatefulWidget {
  const MyTicket({super.key});

  @override
  State<MyTicket> createState() => _MyTicketState();
}

class _MyTicketState extends State<MyTicket> {
  List<Ticket> tickets = [];
  final TicketService ticketService = TicketService();

  // Vérification de l'authentification
  Future<void> checkAuth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token") ?? '';

    if (token == "") {
      // Rediriger vers la page de connexion
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } else {
      loadTickets();
    }
  }

  void _checkAuthAndLoadTickets() async {
    await checkAuth();
  }

  // Chargement des tickets
  loadTickets() async {
    try {
      final ticketList = await ticketService.all();

      setState(() {
        // Trier les tickets du plus récent au plus ancien
        tickets = ticketList
          ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      });
    } on DioException catch (e) {
      print("Erreur API : ${e.response?.data}");
      Fluttertoast.showToast(msg: "Erreur lors du chargement des tickets");
    }
  }

  @override
  void initState() {
    super.initState();
    _checkAuthAndLoadTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Mes Tickets"),
      ),
      body: tickets.isEmpty
          ? const Center(
              child: Text(
                "Aucun ticket disponible",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical, // Permet le scroll vertical
                    child: SingleChildScrollView(
                      scrollDirection: Axis
                          .horizontal, // Permet le scroll horizontal si besoin
                      child: SizedBox(
                        width: MediaQuery.of(context)
                            .size
                            .width, // Largeur maximale
                        child: DataTable(
                          columnSpacing: 30, // Espacement entre les colonnes
                          border: TableBorder.all(width: 1, color: Colors.grey),
                          columns: const [
                            DataColumn(
                                label: Text("N",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Statut",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Acheté le",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: tickets
                              .asMap()
                              .map(
                                (index, ticket) => MapEntry(
                                  index,
                                  DataRow(
                                    cells: [
                                      DataCell(Text((index + 1)
                                          .toString())), // Affiche l'index + 1
                                      DataCell(
                                          Text(ticket.statut ?? "Inconnu")),
                                      DataCell(Text(
                                        DateFormat('dd/MM/yyyy HH:mm').format(
                                            DateTime.parse(ticket.createdAt!)),
                                      )),
                                    ],
                                  ),
                                ),
                              )
                              .values
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
