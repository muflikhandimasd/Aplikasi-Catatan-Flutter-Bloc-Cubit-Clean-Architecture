import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_note_app/app/core/service_locator/service_locator.dart';
import 'package:my_note_app/app/features/note/domain/entities/note.dart';
import 'package:my_note_app/app/features/note/presentation/cubit/note_cubit.dart';

import 'home_page.dart';

class CreateEditPage extends StatelessWidget {
  final Note? note;
  CreateEditPage({
    super.key,
    this.note,
  });

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (note != null) {
      _titleController.text = note?.title ?? '';
      _contentController.text = note!.content;
    }
    return WillPopScope(
      onWillPop: () async {
        if (_contentController.text != '') {
          FocusManager.instance.primaryFocus?.unfocus();
          if (note == null) {
            context.read<NoteCubit>().create(
                  Note(
                    title: _titleController.text,
                    content: _contentController.text,
                  ),
                );
          } else {
            context.read<NoteCubit>().update(
                  Note(
                    id: note!.id,
                    title: _titleController.text,
                    content: _contentController.text,
                  ),
                );
          }
        }
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomePage()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(note == null ? 'Create Note' : 'Edit Note'),
          actions: [
            if (note != null)
              IconButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context.read<NoteCubit>().delete(note!);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const HomePage()));
                },
                icon: const Icon(Icons.delete),
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(
                DateFormat('dd MMMM yyyy hh:mm:ss').format(DateTime.now()),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Content',
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                ),
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
