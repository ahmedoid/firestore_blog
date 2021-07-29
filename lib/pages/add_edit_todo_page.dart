import 'package:firestore_blog/model/todo.dart';
import 'package:firestore_blog/repository/firebase_todos_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddEditTodoPage extends StatefulWidget {
  final FirebaseTodosRepository todosRepository;
  final isEditing;
  final Todo? todo;

  const AddEditTodoPage(
      {Key? key,
      required this.todosRepository,
      this.isEditing = false,
      this.todo})
      : super(key: key);

  @override
  _AddEditTodoPageState createState() => _AddEditTodoPageState();
}

class _AddEditTodoPageState extends State<AddEditTodoPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    _titleController =
        TextEditingController(text: widget.isEditing ? widget.todo!.note : '');
    _descriptionController = TextEditingController(
        text: widget.isEditing ? widget.todo!.description : '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () {
        _titleFocusNode.unfocus();
        _descriptionFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(t!.createNote),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: Form(
              key: _addItemFormKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      bottom: 24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24.0),
                        Text(
                          t.note,
                          style: TextStyle(
                            fontSize: 22.0,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: t.noteTitle,
                          ),
                          validator: (String? value) {
                            return (value != null && value.length < 3)
                                ? t.noteIsShort
                                : null;
                          },
                        ),
                        SizedBox(height: 24.0),
                        Text(
                          t.description,
                          style: TextStyle(
                            fontSize: 22.0,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: _descriptionController,
                          minLines: 10,
                          maxLines: 12,
                          decoration: InputDecoration(
                            hintText: t.writeDescription,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () async {
                        _titleFocusNode.unfocus();
                        _descriptionFocusNode.unfocus();

                        if (_addItemFormKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          if (widget.isEditing) {
                            await widget.todosRepository.updateTodo(Todo(
                                id: widget.todo!.id,
                                description: _descriptionController.text,
                                note: _titleController.text));
                          } else {
                            await widget.todosRepository.addNewTodo(Todo(
                                description: _descriptionController.text,
                                note: _titleController.text));
                          }

                          setState(() {
                            _isLoading = false;
                          });

                          Navigator.of(context).pop();
                        }
                      },
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          if (_isLoading)
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).scaffoldBackgroundColor),
                            ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                widget.isEditing ? t.update : t.create,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
