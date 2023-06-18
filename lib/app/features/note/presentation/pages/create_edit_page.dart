import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_note_app/app/features/note/domain/entities/note.dart';
import 'package:my_note_app/app/features/note/presentation/cubit/note_cubit.dart';

import 'home_page.dart';

class CreateEditPage extends StatefulWidget {
  final Note? note;
  CreateEditPage({
    super.key,
    this.note,
  });

  @override
  State<CreateEditPage> createState() => _CreateEditPageState();
}

class _CreateEditPageState extends State<CreateEditPage> {
  late TextEditingController _titleController;

  late TextEditingController _contentController;

  @override
  void initState() {
    if (widget.note != null) {
      _titleController = TextEditingController(text: widget.note?.title);
      _contentController = TextEditingController(text: widget.note?.content);
    } else {
      _titleController = TextEditingController();
      _contentController = TextEditingController();
    }

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_contentController.text != '') {
          FocusManager.instance.primaryFocus?.unfocus();
          if (widget.note == null) {
            context.read<NoteCubit>().create(
                  Note(
                    title: _titleController.text,
                    content: _contentController.text,
                  ),
                );
          } else {
            context.read<NoteCubit>().update(
                  Note(
                    id: widget.note!.id,
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
          title: Text(widget.note == null ? 'Create Note' : 'Edit Note'),
          actions: [
            if (widget.note != null)
              IconButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: const Text('Delete Note'),
                            content: const Text(
                                'Are you sure want to delete this note?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);

                                  context
                                      .read<NoteCubit>()
                                      .delete(widget.note!);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const HomePage()));
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ));
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(
                DateFormat('dd MMMM yyyy hh:mm:ss').format(DateTime.now()),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Content',
                  border: InputBorder.none,
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
