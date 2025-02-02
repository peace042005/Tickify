import 'package:flutter/material.dart';
import 'package:groupe03_application/data/models/ticket.dart';
import 'package:intl/intl.dart';

class TicketCard extends StatelessWidget {
  final Data ticket;

  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.typeTicket?.evenement?.nom ?? "Unknown Event",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "Status: ${ticket.statut ?? "Unknown"}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              "Type: ${ticket.typeTicket?.nom ?? "N/A"}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              "Purchased on: ${ticket.createdAt != null ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(ticket.createdAt!)) : "N/A"}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
