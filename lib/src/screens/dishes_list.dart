import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_dishes/src/blocs/authentication.dart';
import 'package:food_dishes/src/blocs/dish.dart';
import 'package:food_dishes/src/blocs/favorite.dart';
import 'package:food_dishes/src/events/dish.dart';
import 'package:food_dishes/src/models/favorite/favorite.dart';
import 'package:food_dishes/src/models/role/role.dart';
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
                          onSelectChanged:
                              AuthenticationBloc().state!.role == Role.admin
                                  ? (value) {
                                      _bloc.switchSelect(e);
                                    }
                                  : null,
                          selected: e.selected &&
                              AuthenticationBloc().state!.role == Role.admin,
                          cells: <DataCell>[
                            DataCell(Text(e.id.toString())),
                            DataCell(Text(e.title.toString())),
                            DataCell(Text(e.description.toString())),
                            DataCell(Image.file(File(e.imagePath!))),
                            DataCell(
                              ButtonBar(
                                children: [
                                  if (AuthenticationBloc().state!.role ==
                                      Role.admin)
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
                                  if (AuthenticationBloc().state!.role ==
                                      Role.admin)
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
                                  if (AuthenticationBloc().state!.role ==
                                      Role.user)
                                    IconButton(
                                      onPressed: () {
                                        FavoriteBloc().add(Favorite(
                                          user: AuthenticationBloc().state,
                                          dish: e,
                                        ));
                                      },
                                      icon: Icon(Icons.favorite),
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
        if (_bloc.state!.isEmpty) {
          return Center(
            child: Text("No dishes has been added."),
          );
        }
        return ListView.builder(
          itemCount: _bloc.state!.length,
          padding: EdgeInsets.only(bottom: 80),
          itemBuilder: (context, index) => Slidable(
            child: ListTile(
              title: Text(_bloc.state![index].title!),
              subtitle: Text(
                _bloc.state![index].description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              leading: Image.file(
                File(_bloc.state![index].imagePath!),
                width: 76,
              ),
              selected: _bloc.state![index].selected &&
                  AuthenticationBloc().state!.role == Role.admin,
              selectedColor: Colors.pink,
              onTap: AuthenticationBloc().state!.role == Role.admin
                  ? () {
                      _bloc.switchSelect(_bloc.state![index]);
                    }
                  : null,
            ),
            endActionPane: ActionPane(
              children: [
                if (AuthenticationBloc().state!.role == Role.admin)
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
                if (AuthenticationBloc().state!.role == Role.admin)
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
                if (AuthenticationBloc().state!.role == Role.user)
                  SlidableAction(
                    icon: Icons.favorite,
                    label: "Like",
                    onPressed: (ctx) {
                      FavoriteBloc().add(
                        Favorite(
                          user: AuthenticationBloc().state,
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
