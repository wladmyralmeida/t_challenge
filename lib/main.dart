import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tractian_challenge/presentation/pages/home/home_page.dart';
import 'package:tractian_challenge/providers/asset_three/asset_three_provider.dart';
import 'package:tractian_challenge/providers/company/company_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
        ChangeNotifierProvider(create: (_) => AssetTreeProvider()),
      ],
      child: MaterialApp(
        title: 'Tree View Challenge Tractian',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomePage(),
      ),
    );
  }
}
