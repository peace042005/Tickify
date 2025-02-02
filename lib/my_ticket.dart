import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groupe03_application/components/ticket_card.dart';
import 'package:groupe03_application/data/services/ticket_service.dart';
import 'package:groupe03_application/data/models/ticket.dart';
import 'package:groupe03_application/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTicket extends StatefulWidget {
  const MyTicket({super.key});

  @override
  State<MyTicket> createState() => _MyTicketState();
}

class _MyTicketState extends State<MyTicket> {
  List<Data> ticketData = [];
  final TicketService ticketService = TicketService();
  bool isLoading = true;

  Future<void> checkAuth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token") ?? '';

    if (token.isEmpty) {
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

  loadTickets() async {
    try {
      setState(() {
        isLoading = true;
      });

      final ticketResponse = await ticketService.all();
      setState(() {
        ticketData = ticketResponse.data ?? [];
        ticketData
            .sort((a, b) => (b.createdAt ?? '').compareTo(a.createdAt ?? ''));
      });
    } on DioException catch (e) {
      print("API Error: \${e.response?.data}");
      Fluttertoast.showToast(msg: "Error loading tickets");
    } finally {
      setState(() {
        isLoading = false;
      });
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.1), // Thickness of the border
          child: Container(
            color: Theme.of(context).colorScheme.onSurface,
            height: 0.1, // Thickness
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      );
    }

    if (ticketData.isEmpty) {
      return const Center(
        child: Text(
          "No tickets available",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: ticketData.length,
      itemBuilder: (context, index) => TicketCard(ticket: ticketData[index]),
    );
  }
}
