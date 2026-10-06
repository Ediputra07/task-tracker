import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/task_provider.dart';
import '../../widgets/task_card.dart';
import '../tasks/task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<TaskViewMode> _viewModes = [
    TaskViewMode.today,
    TaskViewMode.upcoming,
    TaskViewMode.all,
    TaskViewMode.done,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskNotifier>(context, listen: false).fetchTasks();
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Provider.of<TaskNotifier>(context, listen: false).setViewMode(_viewModes[index]);
  }

  void _openTaskForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => const TaskFormScreen(),
    );
  }

  String _getViewTitle(TaskViewMode mode) {
    switch (mode) {
      case TaskViewMode.today:
        return 'Today';
      case TaskViewMode.upcoming:
        return 'Upcoming (7 Hari)';
      case TaskViewMode.all:
        return 'Semua Tugas';
      case TaskViewMode.done:
        return 'Tugas Selesai';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authNotifier = Provider.of<AuthNotifier>(context);
    final taskNotifier = Provider.of<TaskNotifier>(context);
    final isDesktop = MediaQuery.of(context).size.width >= 600;

    final bodyContent = RefreshIndicator(
      onRefresh: () => taskNotifier.fetchTasks(),
      child: taskNotifier.isLoading
          ? const Center(child: CircularProgressIndicator())
          : taskNotifier.tasks.isEmpty
              ? LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _selectedIndex == 3
                                  ? Icons.task_alt
                                  : Icons.inbox_outlined,
                              size: 64,
                              color: theme.hintColor.withAlpha(100),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _selectedIndex == 3
                                  ? 'Belum ada tugas yang selesai'
                                  : 'Tidak ada tugas',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Ketuk + untuk membuat tugas baru',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: taskNotifier.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskNotifier.tasks[index];
                    return TaskCard(task: task);
                  },
                ),
    );

    if (isDesktop) {
      // Desktop / Web Wide Screen Layout (NavigationRail)
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onTabSelected,
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: FloatingActionButton(
                  onPressed: _openTaskForm,
                  tooltip: 'Tugas Baru',
                  child: const Icon(Icons.add),
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.today_outlined),
                  selectedIcon: Icon(Icons.today),
                  label: Text('Today'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.date_range_outlined),
                  selectedIcon: Icon(Icons.date_range),
                  label: Text('Upcoming'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.list_alt_outlined),
                  selectedIcon: Icon(Icons.list_alt),
                  label: Text('All'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.check_circle_outline),
                  selectedIcon: Icon(Icons.check_circle),
                  label: Text('Done'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(_getViewTitle(_viewModes[_selectedIndex])),
                  actions: [
                    Text(
                      authNotifier.user?.email ?? '',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.logout_outlined),
                      tooltip: 'Keluar',
                      onPressed: () => authNotifier.signOut(),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
                body: bodyContent,
              ),
            ),
          ],
        ),
      );
    }

    // Mobile Phone Layout (BottomNavigationBar)
    return Scaffold(
      appBar: AppBar(
        title: Text(_getViewTitle(_viewModes[_selectedIndex])),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Keluar',
            onPressed: () => authNotifier.signOut(),
          ),
        ],
      ),
      body: bodyContent,
      floatingActionButton: FloatingActionButton(
        onPressed: _openTaskForm,
        tooltip: 'Tugas Baru',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onTabSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.today_outlined),
            selectedIcon: Icon(Icons.today),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.date_range_outlined),
            selectedIcon: Icon(Icons.date_range),
            label: 'Upcoming',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'All',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: 'Done',
          ),
        ],
      ),
    );
  }
}
