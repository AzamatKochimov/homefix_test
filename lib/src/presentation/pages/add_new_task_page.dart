import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:homefix_test/generated/l10n.dart';
import 'package:intl/intl.dart';

import '../../application/task/task_bloc.dart';
import '../../domain/entities/task.dart';

class AddNewPlanPage extends StatefulWidget {
  const AddNewPlanPage({super.key});

  @override
  _AddNewPlanPageState createState() => _AddNewPlanPageState();
}

class _AddNewPlanPageState extends State<AddNewPlanPage> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _planNameController = TextEditingController();

  void _onDateChanged(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'ru_RU';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add New Plan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                'Plan name',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _planNameController,
              decoration: InputDecoration(
                hintText: 'Plan name',
                filled: true,
                fillColor: const Color(0xffeeeeee),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${_getMonthName(selectedDate.month)}, ${selectedDate.year}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildCalendar(),
            const Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                       final task = Task(
                        title: _planNameController.text,
                        date: DateFormat('dd.MM.yyyy').format(selectedDate),
                        isCompleted: false,
                      );

                      context
                          .read<TaskBloc>()
                          .add(TaskEvent.toggleTaskCompletion(task));

                      Navigator.pop(context);
                      String planName = _planNameController.text;
                      print('Saving Plan: $planName on $selectedDate');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff26BDBE),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('Saqlash', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCalendar() {
    return Localizations(
      locale: const Locale('ru', 'RU'),
      delegates:const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate, 
        ],
      child: Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Color(0xff26BDBE),
          ),
        ),
        child: CalendarDatePicker(
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          onDateChanged: _onDateChanged,
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
