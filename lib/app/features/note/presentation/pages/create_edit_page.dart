import 'package:flutter/material.dart';
import 'package:my_note_app/app/core/service_locator/service_locator.dart';
import 'package:my_note_app/app/features/note/domain/entities/note.dart';
import 'package:my_note_app/app/features/note/presentation/cubit/note_cubit.dart';

class CreateEditPage extends StatelessWidget {
  final Note? note;
  CreateEditPage({
    super.key,
    this.note,
  });

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (note != null) {
      _titleController.text = note?.title ?? '';
      _contentController.text = note!.content;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(note == null ? 'Create Note' : 'Edit Note'),
        actions: [
          IconButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final cubit = sl<NoteCubit>();
                if (note == null) {
                  cubit.create(
                    Note(
                      title: _titleController.text,
                      content: _contentController.text,
                    ),
                  );
                } else {
                  cubit.update(
                    Note(
                      id: note!.id,
                      title: _titleController.text,
                      content: _contentController.text,
                    ),
                  );
                }
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: 'Content',
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                ),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Content cannot be empty';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
