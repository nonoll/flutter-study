import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:flutter_study/model/app_state_model.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() {
    return _SettingsTabState();
  }
}

class _SettingsTabState extends State<SettingsTab> {
  final String _storeVersion = '1.1.0';

  PackageInfo _packageInfo = PackageInfo(
      appName: 'Unknown',
      packageName: 'Unknown',
      version: 'Unknown',
      buildNumber: 'Unknown',
      buildSignature: 'Unknown'
  );

  @override
  void initState() {
    super.initState();

    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    // package_info_plus - package 정보 조회를 위한 package 사용
    final info = await PackageInfo.fromPlatform();

    setState(() {
      _packageInfo = info;
    });
  }

  Widget _infoTile(String title, String subtitle) {
    return CupertinoListTile(
      title: Text(title),
      subtitle: Text(subtitle.isEmpty ? 'Not set' : subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    // @see https://it-banlim.tistory.com/32
    bool needUpdate = _storeVersion.compareTo(_packageInfo.version) != 0;

    print('store version : $_storeVersion');
    print('my device version : ${_packageInfo.version}');
    print('compare version: ${_storeVersion.compareTo(_packageInfo.version)}');

    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        return const CustomScrollView(
          slivers: <Widget>[
            const CupertinoSliverNavigationBar(
              largeTitle: Text('Settings'),
            ),
            // CupertinoListTile(
            //   title: Text('title'),
            //   subtitle: Text('subtitle'),
            // )
          ],
        );
      },
    );
  }
}
