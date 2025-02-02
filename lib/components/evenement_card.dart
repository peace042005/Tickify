import 'package:flutter/material.dart';
import 'package:groupe03_application/data/models/evenement.dart';

class EvenementCard extends StatelessWidget {
  final Data event;
  final String Function(String?) formatDate;
  final VoidCallback? onTap;

  const EvenementCard({
    super.key,
    required this.event,
    required this.formatDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Theme.of(context).colorScheme.onSecondary,
            width: 0.3,
          )),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.images != null && event.images!.isNotEmpty)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8)),
                child: AspectRatio(
                  aspectRatio: 3 / 2,
                  child: Image.network(
                    event.images!.first.url ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.image,
                            color: Theme.of(context).colorScheme.onSecondary),
                      );
                    },
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.nom ?? 'Sans titre',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          formatDate(event.dateDebut) ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.local_activity,
                          size: 14,
                          color: Theme.of(context).colorScheme.onSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          // '${event.nombreTickets ?? 0} tickets',
                          event.nombreTickets == 0
                              ? 'Épuisé'
                              : '${event.nombreTickets} tickets',
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
