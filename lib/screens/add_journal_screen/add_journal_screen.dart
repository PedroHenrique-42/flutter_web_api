import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';

import '../../models/journal.dart';

class AddJournalScreen extends StatelessWidget {
  final Journal journal;
  final bool isEditing;

  AddJournalScreen({
    Key? key,
    required this.journal,
    required this.isEditing,
  }) : super(key: key);

  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _contentController.text = journal.content;

    return Scaffold(
      appBar: AppBar(
        title: Text(WeekDay(journal.createdAt).toString()),
        actions: [
          IconButton(
              onPressed: () {
                registerJournal(context);
              },
              icon: const Icon(Icons.check)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _contentController,
          keyboardType: TextInputType.multiline,
          expands: true,
          maxLines: null,
          minLines: null,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  registerJournal(BuildContext context) {
    String content = _contentController.text;
    journal.content = content;

    if (isEditing) {
      JournalService service = JournalService();
      service.register(journal).then((value) {
        Navigator.pop(context, value);
      });
    } else {
      JournalService service = JournalService();
      service.edit(journal.id, journal).then((value) {
        Navigator.pop(context, value);
      });
    }

  }
}
