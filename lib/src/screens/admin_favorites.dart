import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_dishes/src/blocs/authentication.dart';
import 'package:food_dishes/src/blocs/dish.dart';
import 'package:food_dishes/src/blocs/favorite.dart';
import 'package:food_dishes/src/events/dish.dart';
import 'package:food_dishes/src/events/favorite.dart';
import 'package:food_dishes/src/models/role/role.dart';
import 'package:food_dishes/src/screens/add_favorite_dialog.dart';
import 'package:food_dishes/src/screens/delete_dialog.dart';
import 'package:food_dishes/src/widgets/stream.dart';

class AdminFavoritesListDesktop extends StatelessWidget {
  const AdminFavoritesListDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final _bloc = FavoriteBloc();
    return StreamWidget<FavoriteEvent>(
        stream: _bloc.stream,
        widget: (context, event) {
          return SingleChildScrollView(
            child: DataTable(
              columns: <DataColumn>[
                DataColumn(label: Text("ID"), numeric: true),
                DataColumn(label: Text("USER"), numeric: true),
                DataColumn(label: Text("DISH"), numeric: true),
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
                            DataCell(Text(e.user!.email.toString())),
                            DataCell(Text(e.dish!.title.toString())),
                            DataCell(
                              ButtonBar(
                                children: [
                                  if (AuthenticationBloc().state!.role ==
                                      Role.admin)
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              AddFavoriteDialog(
                                            favorite: e,
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
                                        FavoriteBloc().delete(e);
                                      },
                                      icon:
                                          Icon(Icons.favorite_outline_outlined),
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

class AdminFavoritesListMobile extends StatelessWidget {
  const AdminFavoritesListMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final _bloc = FavoriteBloc();
    return StreamWidget<FavoriteEvent>(
      stream: _bloc.stream,
      widget: (context, event) {
        if (_bloc.state!.isEmpty) {
          return Center(
            child: Text("No Favorite items has been added."),
          );
        }
        return ListView.builder(
          itemCount: _bloc.state!.length,
          padding: EdgeInsets.only(bottom: 80),
          itemBuilder: (context, index) => Slidable(
            child: ListTile(
              title: Text(_bloc.state![index].user!.email!),
              leading: Text(_bloc.state![index].dish!.title!),
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
                        builder: (context) => AddFavoriteDialog(
                          favorite: _bloc.state![index],
                        ),
                      );
                    },
                    backgroundColor: Colors.green,
                  ),
                if (AuthenticationBloc().state!.role == Role.user)
                  SlidableAction(
                    icon: Icons.favorite_outline,
                    label: "Dislike",
                    onPressed: (ctx) {
                      FavoriteBloc().delete(
                        _bloc.state![index],
                      );
                    },
                    backgroundColor: Colors.redAccent,
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
