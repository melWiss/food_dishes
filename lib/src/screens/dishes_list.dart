import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_dishes/src/blocs/dish.dart';
import 'package:food_dishes/src/events/dish.dart';
import 'package:food_dishes/src/screens/add_dish_dialog.dart';
import 'package:food_dishes/src/screens/delete_dialog.dart';
import 'package:food_dishes/src/widgets/stream.dart';

class DishesListDesktop extends StatelessWidget {
  const DishesListDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final _bloc = DishBloc();
    return StreamWidget<DishEvent>(
        stream: _bloc.stream,
        widget: (context, event) {
          return SingleChildScrollView(
            child: DataTable(
              columns: <DataColumn>[
                DataColumn(label: Text("ID"), numeric: true),
                DataColumn(label: Text("TITLE"), numeric: true),
                DataColumn(label: Text("DESCRIPTION"), numeric: true),
                DataColumn(label: Text("IMAGE"), numeric: true),
                DataColumn(label: Text("ACTIONS")),
              ],
              rows: _bloc.state
                      ?.map<DataRow>(
                        (e) => DataRow(
                          onSelectChanged: (value) {
                            _bloc.switchSelect(e);
                          },
                          selected: e.selected,
                          cells: <DataCell>[
                            DataCell(Text(e.id.toString())),
                            DataCell(Text(e.title.toString())),
                            DataCell(Text(e.description.toString())),
                            DataCell(Image.file(File(e.imagePath!))),
                            DataCell(
                              ButtonBar(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AddDishDialog(
                                          dish: e,
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => DeleteDialog(
                                            onDelete: () => _bloc.delete(e)),
                                      );
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList() ??
                  [],
            ),
          );
        });
  }
}

class DishesListMobile extends StatelessWidget {
  const DishesListMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final _bloc = DishBloc();
    return StreamWidget<DishEvent>(
      stream: _bloc.stream,
      widget: (context, event) {
        return ListView.builder(
          itemCount: _bloc.state!.length,
          itemBuilder: (context, index) => Slidable(
            child: ListTile(
              title: Text(_bloc.state![index].title!),
              subtitle: Text(_bloc.state![index].description!),
              leading: Image.file(
                File(_bloc.state![index].imagePath!),
                width: 76,
              ),
            ),
            endActionPane: ActionPane(
              children: [
                SlidableAction(
                  icon: Icons.delete,
                  label: "Delete",
                  onPressed: (ctx) {
                    showDialog(
                      context: context,
                      builder: (context) => DeleteDialog(
                        onDelete: () => _bloc.delete(
                          _bloc.state![index],
                        ),
                      ),
                    );
                  },
                  backgroundColor: Colors.red,
                ),
                SlidableAction(
                  icon: Icons.edit,
                  label: "Update",
                  onPressed: (ctx) {
                    showDialog(
                      context: context,
                      builder: (context) => AddDishDialog(
                        dish: _bloc.state![index],
                      ),
                    );
                  },
                  backgroundColor: Colors.green,
                ),
              ],
              motion: ScrollMotion(),
            ),
          ),
        );
      },
    );
  }
}
