import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_dishes/src/blocs/account.dart';
import 'package:food_dishes/src/events/account.dart';
import 'package:food_dishes/src/models/role/role.dart';
import 'package:food_dishes/src/screens/add_user_dialog.dart';
import 'package:food_dishes/src/screens/delete_dialog.dart';
import 'package:food_dishes/src/widgets/stream.dart';

class UsersListDesktop extends StatelessWidget {
  const UsersListDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final _bloc = AccountBloc();
    return StreamWidget<AccountEvent>(
        stream: _bloc.stream,
        widget: (context, event) {
          return SingleChildScrollView(
            child: DataTable(
              columns: <DataColumn>[
                DataColumn(label: Text("ID"), numeric: true),
                DataColumn(label: Text("EMAIL")),
                DataColumn(label: Text("ROLE")),
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
                            DataCell(Text(e.email.toString())),
                            DataCell(Text(Role.values[e.role!.index].name)),
                            DataCell(
                              ButtonBar(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AddUserDialog(
                                          account: e,
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

class UsersListMobile extends StatelessWidget {
  const UsersListMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final _bloc = AccountBloc();
    return StreamWidget<AccountEvent>(
      stream: _bloc.stream,
      widget: (context, event) {
        if (_bloc.state!.isEmpty) {
          return Center(
            child: Text("No user has been added."),
          );
        }
        return ListView.builder(
          itemCount: _bloc.state!.length,
          padding: EdgeInsets.only(bottom: 80),
          itemBuilder: (context, index) => Slidable(
            child: ListTile(
              title: Text(_bloc.state![index].email!),
              leading: Text(_bloc.state![index].id.toString()),
              selected: _bloc.state![index].selected,
              selectedColor: Colors.pink,
              onTap: () {
                _bloc.switchSelect(_bloc.state![index]);
              },
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
                      builder: (context) => AddUserDialog(
                        account: _bloc.state![index],
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
