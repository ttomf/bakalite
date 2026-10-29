import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({
    super.key,
    required this.title,
    this.subtitle,
    this.onRefresh,
    this.tabs = const [],
    required this.children,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onRefresh;
  final List<String> tabs;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: children.length,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              if (subtitle != null)
                Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          actions: [
            if (onRefresh != null)
              IconButton(icon: const Icon(Icons.refresh), onPressed: onRefresh),
          ],
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
