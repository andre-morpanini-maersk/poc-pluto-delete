import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<PlutoColumn> columns = [];
  final List<PlutoRow> rows = [];
  final List<PlutoRow> selectedRows = [];

  late PlutoGridStateManager stateManager;
  late bool showCheckbox = false;

  void removeCurrentRow() {
    stateManager.removeCurrentRow();
  }

  void handleShowCheckboxButton() {
    setState(() {
      showCheckbox = !showCheckbox;
    });
  }

  void handleRowChecked(PlutoRow row) {
    setState(() {
      if (selectedRows.contains(row)) {
        selectedRows.remove(row);
      } else {
        selectedRows.add(row);
      }
    });
  }

  void handleRemoveSelectedRowsButton() {
    setState(() {
      if (selectedRows.isNotEmpty) {
        rows.removeWhere((row) => !selectedRows.contains(row));
        selectedRows.clear();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    columns.addAll([
      PlutoColumn(
        title: '',
        field: 'actions',
        enableColumnDrag: false,
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        enableSorting: false,
        enableContextMenu: false,
        enableDropToResize: false,
        titleSpan: TextSpan(
          children: [
            WidgetSpan(
              child: CheckboxHeaderWidget(
                  value: showCheckbox,
                  onChanged: handleShowCheckboxButton,
                  onSelectAll: handleSelectAll),
            )
          ],
        ),
        renderer: (rendererContext) {
          return Row(
            children: [
              showCheckbox
                  ? CheckboxWidget(
                      row: rendererContext.row,
                      onRowChecked: handleRowChecked,
                    )
                  : IconButton(
                      icon: const Icon(
                        Icons.cancel_outlined,
                      ),
                      onPressed: () {
                        rendererContext.stateManager
                            .removeRows([rendererContext.row]);
                      },
                      iconSize: 20,
                    ),
            ],
          );
        },
      ),
      PlutoColumn(
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        enableSorting: false,
        enableContextMenu: false,
        enableDropToResize: false,
      ),
      PlutoColumn(
        title: 'Age',
        field: 'age',
        type: PlutoColumnType.number(),
        enableEditingMode: false,
        enableSorting: false,
        enableContextMenu: false,
        enableDropToResize: false,
      ),
    ]);

    rows.addAll([
      PlutoRow(cells: {
        'actions': PlutoCell(value: ''),
        'name': PlutoCell(value: 'Alice'),
        'age': PlutoCell(value: 30),
      }),
      PlutoRow(cells: {
        'actions': PlutoCell(value: ''),
        'name': PlutoCell(value: 'Bob'),
        'age': PlutoCell(value: 25),
      }),
      PlutoRow(cells: {
        'actions': PlutoCell(value: ''),
        'name': PlutoCell(value: 'Charlie'),
        'age': PlutoCell(value: 40),
      }),
      PlutoRow(cells: {
        'actions': PlutoCell(value: ''),
        'name': PlutoCell(value: 'David'),
        'age': PlutoCell(value: 45),
      }),
      PlutoRow(cells: {
        'actions': PlutoCell(value: ''),
        'name': PlutoCell(value: 'Eve'),
        'age': PlutoCell(value: 50),
      }),
    ]);
  }

  void handleSelectAll() {
    setState(() {
      if (showCheckbox) {
        selectedRows.clear();
        selectedRows.addAll(rows);
      } else {
        selectedRows.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Stack(
                children: [
                  PlutoGrid(
                    columns: columns,
                    rows: rows,
                    onLoaded: (event) {
                      event.stateManager
                          .setSelectingMode(PlutoGridSelectingMode.row);
                      stateManager = event.stateManager;
                    },
                    configuration: const PlutoGridConfiguration(),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        handleRemoveSelectedRowsButton();
                      },
                      icon: const Icon(Icons.delete_forever_rounded),
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckboxHeaderWidget extends StatefulWidget {
  final bool value;
  final VoidCallback onChanged;
  final VoidCallback onSelectAll;

  const CheckboxHeaderWidget({
    required this.value,
    required this.onChanged,
    required this.onSelectAll,
    super.key,
  });

  @override
  State<CheckboxHeaderWidget> createState() => _CheckboxHeaderWidgetState();
}

class _CheckboxHeaderWidgetState extends State<CheckboxHeaderWidget> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: (newValue) {
        setState(() {
          value = newValue!;
        });
        widget.onChanged();
        widget.onSelectAll();
      },
    );
  }
}

class CheckboxWidget extends StatefulWidget {
  final PlutoRow row;
  final ValueChanged<PlutoRow> onRowChecked;

  const CheckboxWidget({
    required this.row,
    required this.onRowChecked,
    super.key,
  });

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: (newValue) {
        setState(() {
          value = newValue!;
        });
        widget.onRowChecked(widget.row);
      },
    );
  }
}
