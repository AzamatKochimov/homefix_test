import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/task/task_bloc.dart';
import '../../domain/entities/task.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 22),
          child: Text('My Plans List'),
        ),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskState.loaded) {
            final pendingTasks =
                state.tasks.where((task) => !task.isCompleted).toList();
            final completedTasks =
                state.tasks.where((task) => task.isCompleted).toList();

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
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, String title, List<Task> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tasks.map((task) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: ListTile(
            title: Text(task.title),
            subtitle: Text(task.date),
            trailing: Checkbox(
              value: task.isCompleted,
              onChanged: (value) {
                context
                    .read<TaskBloc>()
                    .add(TaskEvent.toggleTaskCompletion(task));
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCompletedTasks(List<Task> tasks, BuildContext context) {
    return ExpansionTile(
      title: Text('${tasks.length} Completed Tasks'),
      children: tasks.map((task) {
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.date),
        );
      }).toList(),
    );
  }
}
