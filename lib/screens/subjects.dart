import 'package:bakalite/data/data.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/screens/wrapper.dart';
import 'package:bakalite/utils.dart';
import 'package:bakalite/widgets/subject_card.dart';
import 'package:material_ui/material_ui.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  @override
  void initState() {
    super.initState();
    Data.loadSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Data.subjectsRes,
      builder: (context, _) {
        return Wrapper(
          title: AppLocalizations.of(context)!.subjects,
          subtitle: getCacheInfo(
            context,
            Data.subjectsRes.cacheTimestamp['subjects'],
            Data.subjectsRes.loaded['subjects'] != null,
            Data.subjectsRes.error['subjects'] != null,
          ),
          onRefresh: () {
            Data.loadSubjects(force: true);
          },
          children: [
            Data.subjects != null
                ? ListView(
                    children: [
                      for (final subject in Data.subjects!.subjects.values)
                        SubjectCard(subject),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
}
