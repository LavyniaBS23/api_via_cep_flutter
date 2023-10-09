import 'package:flutter/material.dart';

class ViaCepsModel {
  List<ViaCepModel> results = [];

  ViaCepsModel(this.results);

  ViaCepsModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <ViaCepModel>[];
      json['results'].forEach((v) {
        results.add(ViaCepModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = results.map((v) => v.toJson()).toList();
      return data;
  }
}

class ViaCepModel {
  String objectId  = "";
  String createdAt  = "";
  String updatedAt  = "";
  String cep = "";
  String localidade = "";
  String uf = "";

  ViaCepModel.vazio();

  ViaCepModel(
      this.objectId,
      //this.createdAt,
     // this.updatedAt,
      this.cep,
      this.localidade,
      this.uf);
  
  ViaCepModel.criar(this.cep, this.localidade, this.uf);

  ViaCepModel.fromJson(Map<String, dynamic> json) {
    //objectId = json['objectId'];
    //createdAt = json['createdAt'];
   // updatedAt = json['updatedAt'];
    cep = json['cep'].replaceAll("-", "");
    localidade = json['localidade'];
    uf = json['uf'];
    objectId = json['objectId'];
  }

  ViaCepModel.fromJsonViaCep(Map<String, dynamic> json) {
    //objectId = json['objectId'];
    //createdAt = json['createdAt'];
   // updatedAt = json['updatedAt'];
    cep = json['cep'].replaceAll("-", "");
    localidade = json['localidade'];
    uf = json['uf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['cep'] = cep;
    data['localidade'] = localidade;
    data['uf'] = uf;
    return data;
  }

  Map<String, dynamic> toJsonEndPoint() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cep'] = cep;
    data['localidade'] = localidade;
    data['uf'] = uf;
    return data;
  }
}
