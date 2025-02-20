import 'package:flutter/material.dart';
import 'package:groupe03_application/components/image_carousel.dart';
import 'package:groupe03_application/data/services/evenement_service.dart';
import 'package:groupe03_application/data/models/evenement.dart';
import 'package:groupe03_application/data/services/ticket_service.dart';
import 'package:groupe03_application/login.dart';
import 'package:groupe03_application/util/check_auth.dart';
import 'package:groupe03_application/util/format_date.dart';

class EvenementDetail extends StatefulWidget {
  final int evenementId;

  const EvenementDetail({super.key, required this.evenementId});

  @override
  _EvenementDetailState createState() => _EvenementDetailState();
}

class _EvenementDetailState extends State<EvenementDetail> {
  late Future<Evenement> evenement;

  Future<bool> _showConfirmationDialog(String ticketName) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmer l\'achat'),
              content:
                  Text('Voulez-vous vraiment acheter le ticket "$ticketName"?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                  ),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                  child: const Text('Confirmer'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<bool> _buyTicket(int id) async {
    if (await userLoggedIn()) {
      try {
        TicketService ticketService = TicketService();
        final success = await ticketService.buy(id: id);
        return success;
      } catch (e) {
        return false;
      }
    } else {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    evenement = EvenementService().selectEvenement(id: widget.evenementId);
  }

  // String _formatDate(String? dateString) {
  //   if (dateString == null) return 'Date non définie';
  //   try {
  //     final date = DateTime.parse(dateString);
  //     return '${date.day.toString().padLeft(2, '0')}/'
  //         '${date.month.toString().padLeft(2, '0')}/'
  //         '${date.year} à '
  //         '${date.hour.toString().padLeft(2, '0')}:'
  //         '${date.minute.toString().padLeft(2, '0')}';
  //   } catch (e) {
  //     return 'Date invalide';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Détails de l\'événement',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Theme.of(context).colorScheme.onSurface,
            height: 0.1,
          ),
        ),
      ),
      body: FutureBuilder<Evenement>(
        future: evenement,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const SizedBox(height: 16),
                  const Text('Chargement en cours...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur de chargement: ${snapshot.error}',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.data == null) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_busy, size: 64),
                  SizedBox(height: 16),
                  Text('Aucun événement trouvé'),
                ],
              ),
            );
          }

          final evenementData = snapshot.data!.data!.first;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (evenementData.images != null &&
                    evenementData.images!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      // child: SizedBox(
                      //   height: 280,
                      //   child: _buildImageCarousel(evenementData.images!),
                      // ),
                      child: ImageCarousel(
                        images: evenementData.images!,
                        height: 280,
                        borderRadius: 16,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event Title
                      Text(
                        evenementData.nom ?? "Nom de l'événement",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 20),

                      // Event Details Card
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.onSecondary,
                            width: 0.5,
                          ),
                        ),
                        color: Theme.of(context).colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildDetailRow(
                                icon: Icons.location_on_outlined,
                                text: evenementData.lieu ?? "Lieu non spécifié",
                              ),
                              const Divider(height: 24),
                              _buildDetailRow(
                                icon: Icons.calendar_today_outlined,
                                text:
                                    '${formatDate(evenementData.dateDebut)} au \n${formatDate(evenementData.dateFin)}',
                              ),
                              const Divider(height: 24),
                              _buildDetailRow(
                                icon: Icons.confirmation_number_outlined,
                                text:
                                    '${evenementData.nombreTickets ?? 0} tickets disponibles',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description
                      Text(
                        'Description',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        evenementData.description ??
                            "Aucune description disponible",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.8),
                              height: 1.6,
                            ),
                      ),
                      const SizedBox(height: 28),

                      // Ticket Types
                      if (evenementData.typesTickets != null &&
                          evenementData.typesTickets!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tickets disponibles',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: evenementData.typesTickets!.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final ticket =
                                    evenementData.typesTickets![index];
                                return Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      width: 0.5,
                                    ),
                                  ),
                                  color: Theme.of(context).colorScheme.surface,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              ticket.nom ?? "Type de ticket",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                            ),
                                            Text(
                                              '${ticket.prix} CFA',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () async {
                                            final confirmed =
                                                await _showConfirmationDialog(
                                                    ticket.nom ?? '');
                                            if (!confirmed) return;

                                            final success =
                                                await _buyTicket(ticket.id!);
                                            if (!mounted) return;

                                            if (success) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Ticket ${ticket.nom} acheté avec succès!'),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Échec de l\'achat. Veuillez réessayer.'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            // backgroundColor: Theme.of(context)
                                            //     .colorScheme
                                            //     .inversePrimary,
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14),
                                          ),
                                          child: const Text('Acheter'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            size: 20,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
