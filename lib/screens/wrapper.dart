import 'package:bakalite/lang/app_localizations.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({
    super.key,
    required this.title,
    this.subtitle,
    this.onRefresh,
    this.cached,
    this.tabs = const [],
    required this.children,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onRefresh;
  final DateTime? cached;
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
                SelectableText(
                  subtitle!,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.normal),
                ),
            ],
          ),
          actions: [
            if (onRefresh != null)
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: onRefresh,
                style: cached != null
                    ? ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.errorContainer,
                        ),
                        foregroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      )
                    : null,
              ),
          ],
          bottom: tabs.isNotEmpty
              ? TabBar(tabs: [for (final tab in tabs) Tab(child: Text(tab))])
              : null,
        ),
        body: Column(
          children: [
            if (cached != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Row(
                  children: [
                    Icon(
                      Icons.storage,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.cached,
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: SafeArea(
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
          ],
        ),
      ),
    );
  }
}
