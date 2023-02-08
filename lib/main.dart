import 'package:flutter/material.dart';
import 'cupertino/cupertino_app.dart';

import 'package:provider/provider.dart';
import 'model/app_state_model.dart';

void main() {
  // Be sure to add this line if `PackageInfo.fromPlatform()` is called before runApp()
  // WidgetsFlutterBinding.ensureInitialized();

  // if (Platform.isAndroid) {
  //   return runApp(const MyMaterialApp());
  // }

  runApp(
    ChangeNotifierProvider<AppStateModel>(
      create: (_) => AppStateModel()..loadProducts(),
      child: const CupertinoStoreApp(),
    ),
  );
}
