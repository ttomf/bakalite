import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({
    super.key,
    required this.title,
    required this.tabs,
    required this.children,
  });

  final String title;
  final List<String> tabs;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: children.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: TabBar(tabs: [for (final tab in tabs) Tab(child: Text(tab))]),
        ),
        body: SafeArea(
          child: Center(
            child: TabBarView(
              children: [
                for (final child in children)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: child,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
