import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_note_app/app/core/service_locator/service_locator.dart';

import '../cubit/note_cubit.dart';
import 'create_edit_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => CreateEditPage()));
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Search',
                ),
                onChanged: (value) => sl<NoteCubit>().search(value),
              ),
              const SizedBox(
                height: 8,
              ),
              BlocBuilder<NoteCubit, NoteState>(
                builder: (context, state) {
                  if (state is NoteLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is NoteLoaded) {
                    if (state.notes.isEmpty) {
                      return const Center(
                        child: Text('No notes'),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.notes.length,
                        itemBuilder: (context, index) {
                          final note = state.notes[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CreateEditPage(
                                            note: note,
                                          )));
                            },
                            child: Dismissible(
                              key: ValueKey<int>(note.id),
                              child: Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(note.title ?? note.content),
                                      Text(note.content),
                                      Text(note.lastEditedTime.toString()),
                                    ],
                                  )),
                            ),
                          );
                        },
                      ),
                    );
                  }

                  if (state is NoteError) {
                    return Center(
                      child: Text(state.message),
                    );
                  }
                  return const SizedBox.shrink();
                },
              )
            ],
          ),
        ));
  }
}
