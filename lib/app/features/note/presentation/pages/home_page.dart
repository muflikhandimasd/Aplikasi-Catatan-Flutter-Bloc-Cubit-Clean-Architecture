import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'My Notes',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    hintText: 'Search',
                  ),
                  onChanged: (value) => context.read<NoteCubit>().search(value),
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
                              child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.purple[50],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          note.title == ''
                                              ? note.content
                                              : note.title!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      if (note.title != '')
                                        const SizedBox(
                                          height: 4,
                                        ),
                                      if (note.title != '') Text(note.content),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(DateFormat('dd MMMM yyyy hh:mm:ss')
                                          .format(note.lastEditedTime!)),
                                    ],
                                  )),
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
          ),
        ));
  }
}
