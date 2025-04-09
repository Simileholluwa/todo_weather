import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/task_provider.dart';
import '../../../main.dart';
import '../../../core/navigation/app_router.dart';
import '../../widgets/task_card.dart';
import '../../widgets/offline_banner.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final themeMode = ref.watch(themeModeProvider);
    final themeModeNotifier = ref.watch(themeModeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () {
              themeModeNotifier.toggle();
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () async {
            await ref.read(taskProvider.notifier).refreshWeather();
          },
        ),
        child: Column(
          children: [
            StreamBuilder(
              stream: Connectivity().onConnectivityChanged,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }
                if (snapshot.hasData) {
                  for (ConnectivityResult data in snapshot.data!) {
                    if (data == ConnectivityResult.none) {
                      return OfflineBanner();
                    } else {
                      return const SizedBox();
                    }
                  }
                } else if (snapshot.hasError) {
                  return const OfflineBanner();
                }
                return const SizedBox();
              },
            ),
            Expanded(
              child: tasks.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder_open, size: 35,),
                            Text(
                              'No tasks available. Use the button below to add a new task.',
                              
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: tasks.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskCard(
                          task: task,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRouter.addTask),
        child: const Icon(Icons.add),
      ),
    );
  }
}
