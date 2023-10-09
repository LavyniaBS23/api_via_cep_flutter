import 'dart:convert';

import 'package:api_via_cep_flutter/models/via_cep_model.dart';
import 'package:api_via_cep_flutter/repositories/custom_dio.dart';
import 'package:flutter/material.dart';

class CepsRepository {
  final _customDio = CustomDio();

  CepsRepository();
  Future<ViaCepsModel> obterCeps() async {
    var url = "/Ceps";
    var result = await _customDio.dio.get(url);
    return ViaCepsModel.fromJson(result.data);
  }

  Future<void> criar(ViaCepModel viaCepModel) async {
    try {
      var response = await _customDio.dio
          .post("/Ceps", data: viaCepModel.toJsonEndPoint());
    } catch (e) {
      throw e;
    }
  }

  Future<void> atualizar(ViaCepModel viaCepModel) async {
    try {
      var response = await _customDio.dio.put("/Ceps/${viaCepModel.objectId}",
          data: viaCepModel.toJsonEndPoint());
    } catch (e) {
      throw e;
    }
  }

  Future<void> remover(String objectId) async {
    try {
      var response = await _customDio.dio.delete("/Ceps/$objectId");
    } catch (e) {
      throw e;
    }
  }

  Future<bool> buscaCep(ViaCepModel viaCepModel) async {
    var params = {
      'where': jsonEncode({
        'cep': viaCepModel.cep,
        'localidade': viaCepModel.localidade,
        'uf': viaCepModel.uf,
      }),
    };
    try {
      var response = await _customDio.dio.get("/Ceps/", queryParameters: params);
      if(response.data["results"].isNotEmpty){
        return true;
      }
      return false;
    } catch (e) {
      throw e;
    }
  }

  /*consulta no viacep*/
  Future<ViaCepModel> consultarCep(String cep) async {
    var response =
        await _customDio.dio.get("https://viacep.com.br/ws/$cep/json");
    if (response.statusCode == 200) {
      //var json = jsonDecode(response.data);
      return ViaCepModel.fromJsonViaCep(response.data);
    }
    return ViaCepModel.vazio();
  }
}
