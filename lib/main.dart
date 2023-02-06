import 'dart:async';
import 'dart:io' show Platform, exit;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'menu.dart';
import 'navigation_controls.dart';
import 'web_view_stack.dart';

void main() {
  // Be sure to add this line if `PackageInfo.fromPlatform()` is called before runApp()
  // WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(
      home: WebViewApp(),
    ),
  );
  // runApp(const MyApp());
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({Key? key}) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  final controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView'),
        // Add from here ...
        actions: [
          NavigationControls(controller: controller),
          Menu(controller: controller),
        ],
        // ... to here.
      ),
      body: Stack(
        children: [
          WebViewStack(controller: controller),
          // const MyHomePage(title: 'PackageInfo example app'),
        ]
      )
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PackageInfo Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'PackageInfo example app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// @see https://github.com/fluttercommunity/plus_plugins/blob/main/packages/package_info_plus/package_info_plus/example/lib/main.dart
class _MyHomePageState extends State<MyHomePage> {
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
    return ListTile(
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _infoTile('App name', _packageInfo.appName),
          _infoTile('Package name', _packageInfo.packageName),
          _infoTile('App version', _packageInfo.version),
          _infoTile('Build number', _packageInfo.buildNumber),
          _infoTile('Build signature', _packageInfo.buildSignature),
          ListTile(
            title: const Text('Need update'),
            subtitle: Text(needUpdate ? 'Y' : 'N'),
            onTap: () async {
              if (!needUpdate) {
                return;
              }

              // confirm_dialog - confirm dialog 도 package 를 쓰거나 직접 구성해야 함
              if (
                await confirm(
                  context,
                  title: const Text('알림'),
                  content: const Text('업데이트가 필요합니다.\n스토어로 이동하시겠습니까?'),
                  textOK: const Text('네'),
                  textCancel: const Text('아니오')
                )
              ) {
                // url_launcher - https://pub.dev/packages/url_launcher
                await launchUrl(Uri.parse('https://flutter.dev'), mode: LaunchMode.externalApplication);

                // 앱 강제 종료
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isIOS) {
                  exit(0);
                }
                return;
              }
            },
          ),
        ],
      ),
    );
  }
}
