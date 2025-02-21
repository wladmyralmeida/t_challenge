import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tractian_challenge/presentation/pages/asset_three/asset_three_page.dart';
import 'package:tractian_challenge/providers/company/company_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<CompanyProvider>(context, listen: false).loadCompanies();
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanyProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Empresas')),
      body: Center(
        child: companyProvider.isLoading
            ? CircularProgressIndicator()
            : companyProvider.error != null
                ? Text('Erro: ${companyProvider.error}')
                : ListView.builder(
                    itemCount: companyProvider.companies.length,
                    itemBuilder: (context, index) {
                      final company = companyProvider.companies[index];
                      return ListTile(
                        title: Text(company.name),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AssetTreePage(companyId: company.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
      ),
    );
  }
}
