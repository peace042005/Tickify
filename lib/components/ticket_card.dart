import 'package:flutter/material.dart';
import 'package:groupe03_application/data/models/ticket.dart';
import 'package:intl/intl.dart';

class TicketCard extends StatelessWidget {
  final Data ticket;
  final Function(int) onDelete;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final event = ticket.typeTicket?.evenement;

    // Date formatting helpers
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('HH:mm');

    // Event date parsing
    DateTime? startDate;
    DateTime? endDate;
    if (event?.dateDebut != null) {
      startDate = DateTime.parse(event!.dateDebut!);
      endDate = event.dateFin != null ? DateTime.parse(event.dateFin!) : null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Container(
        decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSecondary,
              width: 0.3,
            )
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.1),
            //     blurRadius: 6,
            //     offset: const Offset(0, 2),
            //   ),
            // ],
            ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      event?.nom ?? "Unknown Event",
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  _StatusChip(status: ticket.statut ?? "Unknown"),
                ],
              ),
              const SizedBox(height: 16),

              // Event dates
              if (startDate != null)
                _InfoRow(
                  icon: Icons.calendar_today,
                  label: "Date:",
                  value: endDate != null && endDate != startDate
                      ? '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}'
                      : '${dateFormat.format(startDate)} ${timeFormat.format(startDate)}',
                ),

              // Location
              if (event?.lieu != null)
                _InfoRow(
                  icon: Icons.location_pin,
                  label: "Lieu:",
                  value: event!.lieu!,
                ),

              // Ticket type and price
              Row(
                children: [
                  Expanded(
                    child: _InfoRow(
                      icon: Icons.local_activity,
                      label: "Type:",
                      value: ticket.typeTicket?.nom ?? "N/A",
                    ),
                  ),
                  if (ticket.typeTicket?.prix != null)
                    Text(
                      '${ticket.typeTicket!.prix} FCFA',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.inversePrimary,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(color: colorScheme.onSecondary.withOpacity(0.3)),
              const SizedBox(height: 8),

              // Footer information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.confirmation_number,
                          size: 16, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Text(
                        "#${ticket.id?.toString().padLeft(4, '0') ?? '----'}",
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                  if (ticket.createdAt != null)
                    Row(
                      children: [
                        Icon(Icons.shopping_cart,
                            size: 16, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd MMM yyyy')
                              .format(DateTime.parse(ticket.createdAt!)),
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ElevatedButton(
                    onPressed: () =>
                        onDelete(ticket.id ?? -1), // Changed to use a callback
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.onSecondary,
                          width: 0.2,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable status chip component
class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = status.toLowerCase() == 'valide';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.green : colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isActive
                  ? colorScheme.onPrimary
                  : colorScheme.onErrorContainer,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
      ),
    );
  }
}

// Reusable info row component
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
