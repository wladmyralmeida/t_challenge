import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tractian_challenge/presentation/pages/asset_three/widgets/three_view_widget.dart';
import 'package:tractian_challenge/providers/asset_three/asset_three_provider.dart';

class AssetTreePage extends StatefulWidget {
  final String companyId;
  const AssetTreePage({Key? key, required this.companyId}) : super(key: key);

  @override
  _AssetTreePageState createState() => _AssetTreePageState();
}

class _AssetTreePageState extends State<AssetTreePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _onlyEnergySensors = false;
  bool _onlyCriticalStatus = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AssetTreeProvider>(context, listen: false)
          .loadTreeData(widget.companyId);
    });
  }

  void _applyFilters() {
    final text = _searchController.text;
    Provider.of<AssetTreeProvider>(context, listen: false).applyFilters(
      searchText: text.isEmpty ? null : text,
      onlyEnergySensors: _onlyEnergySensors,
      onlyCriticalStatus: _onlyCriticalStatus,
    );
  }

  @override
  Widget build(BuildContext context) {
    final assetTreeProvider = Provider.of<AssetTreeProvider>(context);
    final treeNodes = assetTreeProvider.treeNodes;

    return Scaffold(
      appBar: AppBar(
        title: Text('Árvore de Ativos'),
      ),
      body: assetTreeProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : assetTreeProvider.error != null
              ? Center(child: Text('Erro: ${assetTreeProvider.error}'))
              : Column(
                  children: [
                    // Filtros
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Pesquisar...',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _applyFilters();
                            },
                          ),
                        ),
                        onChanged: (value) => _applyFilters(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _onlyEnergySensors,
                          onChanged: (val) {
                            setState(() => _onlyEnergySensors = val!);
                            _applyFilters();
                          },
                        ),
                        Text('Sensores de Energia'),
                        SizedBox(width: 20),
                        Checkbox(
                          value: _onlyCriticalStatus,
                          onChanged: (val) {
                            setState(() => _onlyCriticalStatus = val!);
                            _applyFilters();
                          },
                        ),
                        Text('Status Crítico'),
                      ],
                    ),
                    Expanded(
                      child: treeNodes.isEmpty
                          ? Center(child: Text('Nenhum dado encontrado'))
                          : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: treeNodes
                                    .map((node) => TreeViewWidget(node: node))
                                    .toList(),
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }
}
