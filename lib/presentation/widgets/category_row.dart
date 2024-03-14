import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_46/data/entity/idea_entity.dart';

class CategoryRow extends StatelessWidget {
  const CategoryRow(
      {super.key,
      required this.categories,
      required this.selectedCategory,
      required this.selectAction});

  final List<String> categories;
  final String selectedCategory;
  final Function(String category) selectAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        children: [
          CategoryContainer(
            name: 'Favorite',
            isSelected: selectedCategory == 'Favorite',
            selectAction: selectAction,
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width - 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...categories.map((e) => CategoryContainer(
                      name: e,
                      isSelected: selectedCategory == e,
                      selectAction: selectAction,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CategoryContainer extends StatelessWidget {
  const CategoryContainer(
      {super.key, required this.name, required this.isSelected, required this.selectAction});

  final String name;
  final bool isSelected;
  final Function(String category) selectAction;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => selectAction(name),
      child: Container(
        height: 24,
        margin: const EdgeInsets.only(right: 5),
        constraints: const BoxConstraints(
          minWidth: 66,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isSelected ? const Color(0xFF1B1B1B) : const Color(0xFF1B1B1B).withOpacity(0.5),
        ),
        child: Center(
          child: Text(
            name,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
