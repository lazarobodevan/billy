import 'package:billy/presentation/screens/categories/categories.dart';
import 'package:billy/presentation/screens/nav_pages/more/widgets/more_item.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:flutter/material.dart';

class More extends StatelessWidget {
  const More({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ThemeColors.primary3,
      ),
      backgroundColor: ThemeColors.primary3,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ThemeColors.primary1),
              ),
              const SizedBox(
                height: 36,
              ),
              MoreItem(
                  text: "Categorias",
                  icon: Icons.add,
                  onClick: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Categories(
                        onSelect: (val) {},
                        isSelectableCategories: false,
                      ),
                    ));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
