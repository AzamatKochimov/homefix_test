import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/task.dart';
import '../../infrastructure/repositories/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';
part 'task_bloc.freezed.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc(this.taskRepository) : super(const TaskState.initial()) {
    on<_LoadTasks>((event, emit) async {
      final tasks = await taskRepository.getTasks();
      emit(TaskState.loaded(tasks));
    });

    on<_ToggleTaskCompletion>((event, emit) async {
      await taskRepository.toggleTaskCompletion(event.task);
      add(const TaskEvent.loadTasks());
    });
  }
}

