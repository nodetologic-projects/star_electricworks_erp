import 'package:flutter/material.dart';
import 'package:starelectricerp/core/widgets/app_text_field.dart';

class AppDataTable<T> extends StatelessWidget {
  final List<String> columns;
  final List<T> data;
  final List<Widget> Function(T item) buildRow;
  final ValueChanged<String>? onSearchChanged;
  final String searchHint;
  final String emptyMessage;

  const AppDataTable({
    super.key,
    required this.columns,
    required this.data,
    required this.buildRow,
    this.onSearchChanged,
    this.searchHint = 'Search...',
    this.emptyMessage = 'No records found.',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (onSearchChanged != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppTextField(
              label: 'Search',
              hintText: searchHint,
              onChanged: onSearchChanged,
            ),
          ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tableWidth = constraints.maxWidth > 800 ? constraints.maxWidth : 800.0;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: tableWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Row
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: columns
                            .map((c) => Expanded(
                                  child: Text(
                                    c,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    const Divider(height: 1),
                    // Lazy List
                    Expanded(
                      child: data.isEmpty
                          ? Center(child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Text(emptyMessage, style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                            ))
                          : ListView.separated(
                              itemCount: data.length,
                              separatorBuilder: (context, index) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final item = data[index];
                                final cells = buildRow(item);
                                return Container(
                                  color: index.isEven ? Colors.white : Colors.grey.shade50,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: cells
                                        .map((w) => Expanded(
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: w,
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
            },
          ),
        ),
      ),
      ],
    );
  }
}
