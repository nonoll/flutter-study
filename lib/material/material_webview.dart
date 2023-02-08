import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'material_menu.dart';
import 'material_navigation_controls.dart';
import 'material_web_view_stack.dart';

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

