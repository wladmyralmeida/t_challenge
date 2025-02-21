import 'package:flutter/material.dart';
import 'package:tractian_challenge/core/services/api_service.dart';
import 'package:tractian_challenge/domain/models/asset_model.dart';
import 'package:tractian_challenge/domain/models/location_model.dart';
import 'package:tractian_challenge/domain/models/three_node_model.dart';

class AssetTreeProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  List<LocationModel> _locations = [];
  List<AssetModel> _assets = [];

  // Árvore completa
  List<TreeNode> _treeNodes = [];
  // Árvore filtrada
  List<TreeNode> _filteredTreeNodes = [];

  List<TreeNode> get treeNodes =>
      _filteredTreeNodes.isEmpty ? _treeNodes : _filteredTreeNodes;

  Future<void> loadTreeData(String companyId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch
      _locations = await _apiService.fetchLocations(companyId);
      _assets = await _apiService.fetchAssets(companyId);

      // Montar árvore
      _treeNodes = _buildTree();
      _filteredTreeNodes = []; // sem filtros no início
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<TreeNode> _buildTree() {
    // Passo 1: criar TreeNodes para cada Location
    final Map<String, TreeNode> locationMap = {};
    for (var loc in _locations) {
      locationMap[loc.id] = TreeNode(
        id: loc.id,
        name: loc.name,
        type: NodeType.location,
        parentId: loc.parentId,
        children: [],
      );
    }

    // Passo 2: organizar hierarquia de Locations
    // para saber quem é subloc de quem
    for (var loc in _locations) {
      if (loc.parentId != null && locationMap.containsKey(loc.parentId!)) {
        final parent = locationMap[loc.parentId!]!;
        final updatedChildren = List<TreeNode>.from(parent.children)
          ..add(locationMap[loc.id]!);
        locationMap[loc.parentId!] = parent.copyWith(children: updatedChildren);
      }
    }

    // Passo 3: criar TreeNodes para cada Asset (subativos ou componentes)
    final Map<String, TreeNode> assetMap = {};
    for (var asset in _assets) {
      final type = asset.isComponent ? NodeType.component : NodeType.asset;
      assetMap[asset.id] = TreeNode(
        id: asset.id,
        name: asset.name,
        type: type,
        parentId: asset.parentId ?? asset.locationId,
        sensorType: asset.sensorType,
        status: asset.status,
        children: [],
      );
    }

    // Passo 4: Montar hierarquia entre Assets
    // - subativos (parentId de outro asset)
    // - componentes (sensorType != null)
    for (var asset in _assets) {
      if (!asset.isComponent &&
          asset.parentId != null &&
          assetMap.containsKey(asset.parentId!)) {
        final parent = assetMap[asset.parentId!]!;
        final updatedChildren = List<TreeNode>.from(parent.children)
          ..add(assetMap[asset.id]!);
        assetMap[asset.parentId!] = parent.copyWith(children: updatedChildren);
      }
    }

    // Passo 5: inserir Assets nos Locais (se tiver locationId)
    for (var asset in _assets) {
      if (asset.locationId != null &&
          locationMap.containsKey(asset.locationId!)) {
        // significa que este Asset é filho de um Location
        final locParent = locationMap[asset.locationId!]!;
        final updatedChildren = List<TreeNode>.from(locParent.children)
          ..add(assetMap[asset.id]!);
        locationMap[asset.locationId!] =
            locParent.copyWith(children: updatedChildren);
      }
    }

    // Passo 6: detectar Assets sem parentId ou locationId => top-level
    //          (podem ser adicionados diretamente na raiz)
    List<TreeNode> rootNodes = [];
    for (var asset in _assets) {
      if (asset.isTopLevel) {
        rootNodes.add(assetMap[asset.id]!);
      }
    }

    // Passo 7: coletar todos os Locais de nível superior (parentId == null)
    final locationRoots =
        locationMap.values.where((loc) => loc.parentId == null).toList();

    // Combinar rootNodes + locationRoots numa lista
    // "ROOT" fictício não é necessário se preferir exibir direto
    List<TreeNode> finalRoots = [
      ...locationRoots,
      ...rootNodes,
    ];

    return finalRoots;
  }

  // ============ Filtros ============
  void applyFilters({
    String? searchText,
    bool? onlyEnergySensors,
    bool? onlyCriticalStatus,
  }) {
    // se todos filtros nulos, limpa filtra e retorna ao estado inicial
    if ((searchText == null || searchText.isEmpty) &&
        onlyEnergySensors == false &&
        onlyCriticalStatus == false) {
      _filteredTreeNodes = [];
      notifyListeners();
      return;
    }

    final filtered = <TreeNode>[];
    for (var root in _treeNodes) {
      final filteredNode = _filterNode(
        node: root,
        searchText: searchText,
        onlyEnergySensors: onlyEnergySensors ?? false,
        onlyCriticalStatus: onlyCriticalStatus ?? false,
      );
      if (filteredNode != null) {
        filtered.add(filteredNode);
      }
    }

    _filteredTreeNodes = filtered;
    notifyListeners();
  }

  // Retorna null se o nó (e seus filhos) não passar no filtro
  TreeNode? _filterNode({
    required TreeNode node,
    String? searchText,
    required bool onlyEnergySensors,
    required bool onlyCriticalStatus,
  }) {
    // filtrar filhos recursivamente
    List<TreeNode> filteredChildren = [];
    for (var child in node.children) {
      final fc = _filterNode(
        node: child,
        searchText: searchText,
        onlyEnergySensors: onlyEnergySensors,
        onlyCriticalStatus: onlyCriticalStatus,
      );
      if (fc != null) {
        filteredChildren.add(fc);
      }
    }

    // Verificar se o nó atual passa nos filtros
    final passesSearchText = searchText == null || searchText.isEmpty
        ? true
        : node.name.toLowerCase().contains(searchText.toLowerCase());

    final passesEnergyFilter =
        !onlyEnergySensors || (node.sensorType == 'energy');

    final passesStatusFilter =
        !onlyCriticalStatus || (node.status == 'critical');

    final passesAll =
        passesSearchText && passesEnergyFilter && passesStatusFilter;

    // Se o nó atual ou algum filho passa, retornamos o nó (com os filhos filtrados)
    if (passesAll || filteredChildren.isNotEmpty) {
      return node.copyWith(children: filteredChildren);
    }
    // se não passou, retorna null
    return null;
  }
}
