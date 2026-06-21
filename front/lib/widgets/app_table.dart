import 'package:flutter/material.dart';
import '../app_theme.dart';

class AppTable<T> extends StatelessWidget {
  final List<String> columns;
  final List<T> items;
  final List<DataCell> Function(T item) rowBuilder;
  final void Function(T item)? onTap;
  final double minWidth;

  const AppTable({
    super.key,
    required this.columns,
    required this.items,
    required this.rowBuilder,
    this.onTap,
    this.minWidth = 600,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.1)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  DefaultColors.primary.withOpacity(isDark ? 0.15 : 0.05),
                ),
                dataRowMinHeight: 56,
                dataRowMaxHeight: 80,

                horizontalMargin: 24,
                columnSpacing: 20,
                showCheckboxColumn: false,
                columns: columns.map((String col) {
                  return DataColumn(
                    label: Expanded(
                      child: Text(
                        col.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 1.1,
                          color: DefaultColors.primary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                rows: items.map((T item) {
                  return DataRow(
                    onSelectChanged: onTap != null ? (_) => onTap!(item) : null,
                    cells: rowBuilder(item),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
