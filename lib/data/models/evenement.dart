import 'dart:convert';

Evenement authenticatedUserFromJson(String str) =>
    Evenement.fromJson(json.decode(str));

String authenticatedUserToJson(Evenement data) => json.encode(data.toJson());

class Evenement {
  List<Data>? data;

  Evenement({this.data});

  // Evenement.fromJson(Map<String, dynamic> json) {
  //   if (json['data'] != null) {
  //     data = <Data>[];
  //     json['data'].forEach((v) {
  //       data!.add(Data.fromJson(v));
  //     });
  //   }
  // }

  Evenement.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      if (json['data'] is List) {
        // Handle array response (for getEvenements)
        json['data'].forEach((v) {
          data!.add(Data.fromJson(v));
        });
      } else {
        // Handle single object response (for selectEvenement)
        data!.add(Data.fromJson(json['data']));
      }
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
  String? nom;
  String? description;
  String? lieu;
  String? dateDebut;
  String? dateFin;
  int? nombreTickets;
  List<Images>? images;
  List<TypesTickets>? typesTickets;

  Data(
      {this.id,
      this.nom,
      this.description,
      this.lieu,
      this.dateDebut,
      this.dateFin,
      this.nombreTickets,
      this.images,
      this.typesTickets});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    description = json['description'];
    lieu = json['lieu'];
    dateDebut = json['dateDebut'];
    dateFin = json['dateFin'];
    nombreTickets = json['nombreTickets'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    if (json['typesTickets'] != null) {
      typesTickets = <TypesTickets>[];
      json['typesTickets'].forEach((v) {
        typesTickets!.add(TypesTickets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['description'] = description;
    data['lieu'] = lieu;
    data['dateDebut'] = dateDebut;
    data['dateFin'] = dateFin;
    data['nombreTickets'] = nombreTickets;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (typesTickets != null) {
      data['typesTickets'] = typesTickets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  int? id;
  String? url;

  Images({this.id, this.url});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    return data;
  }
}

class TypesTickets {
  int? id;
  String? nom;
  int? prix;

  TypesTickets({this.id, this.nom, this.prix});

  TypesTickets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    prix = json['prix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['prix'] = prix;
    return data;
  }
}
