import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({
    super.key,
    required this.title,
    this.subtitle,
    this.tabs = const [],
    required this.children,
  });

  final String title;
  final String? subtitle;
  final List<String> tabs;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: children.length,
      child: Scaffold(
        appBar: AppBar(
          title: subtitle == null
              ? Text(title)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title),
                    SelectableText(
                      subtitle!,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
          bottom: tabs.isNotEmpty
              ? TabBar(tabs: [for (final tab in tabs) Tab(child: Text(tab))])
              : null,
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
