import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tractian_challenge/domain/models/asset_model.dart';
import 'package:tractian_challenge/domain/models/company_model.dart';
import 'package:tractian_challenge/domain/models/location_model.dart';

class ApiService {
  static const baseUrl = 'https://fake-api.tractian.com';

  Future<List<Company>> fetchCompanies() async {
    final response = await http.get(Uri.parse('$baseUrl/companies'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Company.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar empresas');
    }
  }

  Future<List<LocationModel>> fetchLocations(String companyId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/companies/$companyId/locations'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => LocationModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar locais');
    }
  }

  Future<List<AssetModel>> fetchAssets(String companyId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/companies/$companyId/assets'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => AssetModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar ativos');
    }
  }
}
