part of 'task_bloc.dart';

@freezed
class TaskEvent with _$TaskEvent {
  const factory TaskEvent.loadTasks() = _LoadTasks;
  const factory TaskEvent.toggleTaskCompletion(Task task) = _ToggleTaskCompletion;
  const factory TaskEvent.addTask(Task task) = _AddTask; // New event
}