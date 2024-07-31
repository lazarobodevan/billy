import 'package:billy/theme/colors.dart';
import 'package:billy/theme/typography.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatefulWidget {
  const CategoryTile({super.key});

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  bool _isExpanded = false;

  void toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubicEmphasized,
      width: MediaQuery.of(context).size.width,
      height: _isExpanded ? 160 : 80,
      decoration: const BoxDecoration(
        color: ThemeColors.primary3,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 79,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: ThemeColors.secondary1,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.star_border_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Minha categoria bonitinha e xerozinha",
                          style: TypographyStyles.label3(),
                        ),
                      ],
                    ),
                  ),
                  Material(
                    child: InkWell(
                      onTap: toggleExpansion,
                      child: Ink(
                        width: 30,
                        height: double.maxFinite,
                        color: Colors.white,
                        child: Icon(
                          _isExpanded
                              ? Icons.arrow_drop_up_rounded
                              : Icons.arrow_drop_down_rounded,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _isExpanded ? Padding(
                padding: const EdgeInsets.only(left: 45),
                child: Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: ThemeColors.secondary1,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.star_border_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Minha categoria bonitinha e xerozinha",
                      style: TypographyStyles.label3(),
                    ),
                  ],
                ),
              ) : const SizedBox.shrink()
            ),
          ],
        ),
      ),
    );
  }
}