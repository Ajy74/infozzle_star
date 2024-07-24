import 'package:breathpacer/theme/app_theme.dart';
import 'package:flutter/material.dart';

class FilterOptions extends StatefulWidget {
  final Function(List<String>) onSelected;
  final List<String> initialSelectedFilters;

  const FilterOptions({
    super.key,
    required this.onSelected,
    required this.initialSelectedFilters,
  });

  @override
  _FilterOptionsState createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  late List<String> selectedFilters;

  @override
  void initState() {
    super.initState();
    selectedFilters = List.from(widget.initialSelectedFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(
          children: [
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                buildFilterChip('All'),
                buildFilterChip('0-10 mins'),
                buildFilterChip('10-20 mins'),
                buildFilterChip('20-30 mins'),
                buildFilterChip('30-40 mins'),
                buildFilterChip('40-50 mins'),
                buildFilterChip('50 mins - 1 hour'),
                buildFilterChip('1 - 2 hours'),
                buildFilterChip('More than 2 hours'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 150,
                    child: buildFilterButton(context, Colors.white, "Cancel"),
                  ),
                  SizedBox(
                    width: 150,
                    child: buildFilterButton(context, AppTheme.colors.pinkButton, "Apply"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildFilterChip(String label) {
    bool isSelected = selectedFilters.contains(label);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      showCheckmark: false,
      onSelected: (bool selected) {
        setState(() {
          if (label == 'All') {
            selectedFilters = ['All'];
          } else {
            selectedFilters.remove('All');
            if (selected) {
              selectedFilters.add(label);
            } else {
              selectedFilters.remove(label);
            }
          }
        });
      },
      selectedColor: isSelected ? Colors.grey[300] : Colors.white,
    );
  }

  Widget buildFilterButton(BuildContext context, Color color, String text) {
    return Container(
      width: 50,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: text == "Cancel" ? Border.all(color: Colors.grey) : Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.all(15),
          elevation: 2, // No elevation
        ),
        onPressed: () {
          if (text == "Apply") {
            widget.onSelected(selectedFilters);
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }
        },
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: color == Colors.white ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
