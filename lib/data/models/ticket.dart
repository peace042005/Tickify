import 'dart:convert';

Ticket ticketFromJson(String str) => Ticket.fromJson(json.decode(str));

String ticketToJson(Ticket data) => json.encode(data.toJson());

class Ticket {
  List<Data>? data;

  Ticket({this.data});

  Ticket.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? statut;
  int? typeTicketId;
  int? userId;
  String? createdAt;
  String? updatedAt;
  TypeTicket? typeTicket;

  Data(
      {this.id,
      this.statut,
      this.typeTicketId,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.typeTicket});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    statut = json['statut'];
    typeTicketId = json['type_ticket_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    typeTicket = json['type_ticket'] != null
        ? TypeTicket.fromJson(json['type_ticket'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['statut'] = statut;
    data['type_ticket_id'] = typeTicketId;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (typeTicket != null) {
      data['type_ticket'] = typeTicket!.toJson();
    }
    return data;
  }
}

class TypeTicket {
  int? id;
  String? nom;
  int? prix;
  int? evenementId;
  String? createdAt;
  String? updatedAt;
  Evenement? evenement;

  TypeTicket(
      {this.id,
      this.nom,
      this.prix,
      this.evenementId,
      this.createdAt,
      this.updatedAt,
      this.evenement});

  TypeTicket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    prix = json['prix'];
    evenementId = json['evenement_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    evenement = json['evenement'] != null
        ? Evenement.fromJson(json['evenement'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['prix'] = prix;
    data['evenement_id'] = evenementId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (evenement != null) {
      data['evenement'] = evenement!.toJson();
    }
    return data;
  }
}

class Evenement {
  int? id;
  String? nom;
  String? description;
  int? createdBy;
  String? dateDebut;
  String? dateFin;
  String? lieu;
  int? nombreTickets;
  String? createdAt;
  String? updatedAt;

  Evenement(
      {this.id,
      this.nom,
      this.description,
      this.createdBy,
      this.dateDebut,
      this.dateFin,
      this.lieu,
      this.nombreTickets,
      this.createdAt,
      this.updatedAt});

  Evenement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    description = json['description'];
    createdBy = json['created_by'];
    dateDebut = json['date_debut'];
    dateFin = json['date_fin'];
    lieu = json['lieu'];
    nombreTickets = json['nombre_tickets'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['description'] = description;
    data['created_by'] = createdBy;
    data['date_debut'] = dateDebut;
    data['date_fin'] = dateFin;
    data['lieu'] = lieu;
    data['nombre_tickets'] = nombreTickets;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
