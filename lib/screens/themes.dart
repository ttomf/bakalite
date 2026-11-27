import 'package:bakalite/data/data.dart';
import 'package:bakalite/data/models/entity.dart';
import 'package:bakalite/screens/wrapper.dart';
import 'package:bakalite/utils.dart';
import 'package:bakalite/widgets/theme_card.dart';
import 'package:material_ui/material_ui.dart';

class ThemesScreen extends StatefulWidget {
  const ThemesScreen({super.key});

  @override
  State<ThemesScreen> createState() => _ThemesScreenState();
}

class _ThemesScreenState extends State<ThemesScreen> {
  late Entity subject;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    subject = ModalRoute.of(context)!.settings.arguments as Entity;
    Data.loadThemes(subject.id);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Data.themesRes,
      builder: (context, _) {
        return Wrapper(
          title: subject.name,
          subtitle: getCacheInfo(
            context,
            Data.themesRes.cacheTimestamp['subjects/themes/${subject.id}'],
            Data.themesRes.loaded['subjects/themes/${subject.id}'] != null,
            Data.themesRes.error['subjects/themes/${subject.id}'] != null,
          ),
          onRefresh: () {
            Data.loadThemes(subject.id, force: true);
          },
          children: [
            Data.themes(subject.id) != null
                ? ListView(
                    children: [
                      for (final theme in Data.themes(subject.id)!.themes)
                        ThemeCard(theme),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
}
