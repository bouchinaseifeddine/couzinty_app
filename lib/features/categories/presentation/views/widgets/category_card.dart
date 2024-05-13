import 'package:couzinty/features/categories/data/models/category_model.dart';
import 'package:couzinty/features/categories/presentation/views/category_list_view.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => CategoryListView(category: category))));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(category.image!),
            fit: BoxFit.cover,
          ),
          // color: kMainGreen,
        ),
        child: Center(
            child: Text(
          category.name,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 32),
        )),
      ),
    );
  }
}
