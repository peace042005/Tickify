import 'dart:convert';

Ticket ticketFromJson(String str) =>
    Ticket.fromJson(json.decode(str));

String ticketToJson(Ticket data) => json.encode(data.toJson());

class Ticket {
  int? id;
  String? statut;
  int? typeTicketId;
  int? userId;
  String? createdAt;
  String? updatedAt;

  Ticket(
      {this.id,
        this.statut,
        this.typeTicketId,
        this.userId,
        this.createdAt,
        this.updatedAt});

  Ticket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    statut = json['statut'];
    typeTicketId = json['type_ticket_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['statut'] = this.statut;
    data['type_ticket_id'] = this.typeTicketId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}