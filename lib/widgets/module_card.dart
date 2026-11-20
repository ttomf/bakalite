import 'package:flutter/material.dart';

class ModuleCard extends StatelessWidget {
  const ModuleCard({
    required this.route,
    required this.label,
    required this.icon,
    this.color = false,
    super.key,
  });

  final String route;
  final String label;
  final IconData icon;
  final bool color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(
                      icon,
                      size: 50,
                      color: color
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
                ),
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
