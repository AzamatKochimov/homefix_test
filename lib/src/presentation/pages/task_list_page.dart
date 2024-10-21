import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homefix_test/src/presentation/pages/add_new_task_page.dart';
import '../../application/task/task_bloc.dart';
import '../../domain/entities/task.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {

  @override
  void initState() {
    context.read<TaskBloc>().add(const TaskEvent.loadTasks());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 22),
            child: Text('My Plans List'),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 22),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const AddNewPlanPage(),
                    ),
                  );
                },
                icon: SvgPicture.asset("assets/icons/add.svg"),
              ),
            ),
          ],
        ),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loaded: (tasks) {
                final pendingTasks =
                    tasks.where((task) => !task.isCompleted).toList();
                final completedTasks =
                    tasks.where((task) => task.isCompleted).toList();

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      children: [
                        _buildTaskList(context, 'Pending Tasks', pendingTasks),
                        _buildCompletedTasks(completedTasks, context),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
    );
  }

  Widget _buildTaskList(BuildContext context, String title, List<Task> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 8.0),
        //   child: Text(
        //     title,
        //     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        //   ),
        // ),
        Column(
          children: tasks.map((task) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffEEEEEE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8.0,
                  ),
                  leading: IconButton(
                    icon: SvgPicture.asset("assets/icons/circle.svg"),
                    onPressed: () {
                      context
                          .read<TaskBloc>()
                          .add(TaskEvent.toggleTaskCompletion(task));
                    },
                  ),
                  title: Text(
                    task.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    task.date,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCompletedTasks(List<Task> tasks, BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
        title: Text(
          '${tasks.length} Completed Tasks',
          style: const TextStyle(
            color: Color(0xff26BDBE),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconColor: const Color(0xff26BDBE),
        children: tasks.map((task) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffEEEEEE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
                leading: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SvgPicture.asset("assets/icons/done.svg"),
                ),
                title: Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  task.date,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
