import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groupe03_application/data/services/ticket_service.dart';
import 'package:groupe03_application/data/models/ticket.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  List<Ticket> tickets = [];
  TicketService ticketService = TicketService();

  // Chargement des tickets
  loadTickets() async {
    try {
      final ticketList = await ticketService.all();
      setState(() {
        tickets = [ticketList]; // Assuming the `all()` service fetches one ticket or modifies this logic accordingly.
      });
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.statusCode);
      } else {
        print(e.requestOptions);
        print(e.message);
      }

      Fluttertoast.showToast(msg: "Une erreur est survenue lors du chargement des tickets");
    }
  }

  @override
  void initState() {
    super.initState();
    loadTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mes Tickets",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: tickets.isEmpty
          ? const Center(
        child: Text(
          "Aucun ticket disponible",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return Card(
            child: ListTile(
              leading: Text("${ticket.id}"),
              title: Text(
                "Statut : ${ticket.statut}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Créé le : ${ticket.createdAt}"),
            ),
          );
        },
      ),
    );
  }
}
