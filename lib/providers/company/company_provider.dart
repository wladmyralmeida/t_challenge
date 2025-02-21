import 'package:flutter/material.dart';
import 'package:tractian_challenge/core/services/api_service.dart';
import 'package:tractian_challenge/domain/models/company_model.dart';

class CompanyProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Company> _companies = [];
  bool _isLoading = false;
  String? _error;

  List<Company> get companies => _companies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCompanies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _companies = await _apiService.fetchCompanies();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
