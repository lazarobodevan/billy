import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/presentation/shared/components/category_editor_dialog.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../models/subcategory/subcategory.dart';
import '../../screens/categories/category_bloc/category_bloc.dart';

class CategoryTile extends StatefulWidget {
  final bool? isClickable;
  final Function(TransactionCategory category) onSelectCategory;
  final TransactionCategory category;

  const CategoryTile(
      {super.key,
      required this.category,
      this.isClickable = true,
      required this.onSelectCategory});

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

  double getWidgetHeigth() {
    var subcategories = widget.category.subcategories;
    const retractedHeigth = 80.0;
    double numberOfItems = subcategories?.length.toDouble() ?? 0;
    const heigthSpaceBetween = 10;
    double itemHeight = retractedHeigth + heigthSpaceBetween;

    if (_isExpanded) {
      if (numberOfItems == 0) {
        return retractedHeigth * 2;
      } else if (numberOfItems == 1) {
        return itemHeight * 3 - heigthSpaceBetween;
      } else {
        return itemHeight * numberOfItems + retractedHeigth;
      }
    }
    return 80;
  }

  void onDelete(CategoryBloc bloc) {
    if (widget.category.id == null) return;
    bloc.add(DeleteCategoryEvent(id: widget.category.id!));
  }

  void onSelectCategory({Subcategory? subcategory}) {
    final categoryCopy = widget.category.copyWith(
      subcategories: subcategory != null ? [subcategory] : [],
    );

    widget.onSelectCategory(categoryCopy);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        var bloc = BlocProvider.of<CategoryBloc>(context);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubicEmphasized,
          width: MediaQuery.of(context).size.width,
          height: getWidgetHeigth(),
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
                Slidable(
                  key: const ValueKey(1),
                  closeOnScroll: true,
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          CategoryEditorDialog.showCategoryEditorDialog(
                            context,
                            category: TransactionCategory(
                              id: widget.category.id,
                              name: widget.category.name,
                              color: widget.category.color,
                              icon: widget.category.icon,
                            ),
                          );
                        },
                        icon: Icons.edit_outlined,
                        backgroundColor: ThemeColors.semanticYellow,
                        foregroundColor: Colors.white,
                      )
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    dismissible: DismissiblePane(
                      closeOnCancel: true,
                      confirmDismiss: () async {
                        return true;
                      },
                      onDismissed: () {
                        onDelete(bloc);
                      },
                    ),
                    children: [
                      SlidableAction(
                        onPressed: (context) {},
                        icon: Icons.delete_forever_rounded,
                        backgroundColor: ThemeColors.semanticRed,
                        foregroundColor: ThemeColors.primary3,
                      )
                    ],
                  ),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        if (widget.isClickable == false) return;
                        onSelectCategory();
                      },
                      child: Ink(
                        color: ThemeColors.primary3,
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
                                        color: ThemeColors.primary1,
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: widget.category.color,
                                            width: 4)),
                                    child: Center(
                                      child: Icon(
                                        widget.category.icon,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    widget.category.name,
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
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isExpanded
                      ? Padding(
                          padding: const EdgeInsets.only(left: 45),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.category.subcategories != null)
                                ...widget.category.subcategories!.map((subcat) {
                                  return Material(
                                    child: InkWell(
                                      onTap: () {
                                        if (widget.isClickable == false) return;
                                        onSelectCategory(subcategory: subcat);
                                      },
                                      child: Ink(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 45,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                color: ThemeColors.secondary1,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  subcat.icon,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              subcat.name,
                                              style: TypographyStyles.label3(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              const SizedBox(
                                height: 10,
                              ),
                              _buildAddSubcategoryButton(
                                  context, widget.category.id!)
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _buildAddSubcategoryButton(BuildContext context, int parentId) {
  return Material(
    child: InkWell(
      onTap: () {
        CategoryEditorDialog.showCategoryEditorDialog(context,
            isCategory: false, parentId: parentId);
      },
      child: Ink(
        width: 250,
        height: 50,
        decoration: BoxDecoration(
            color: ThemeColors.primary3,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ThemeColors.primary1, width: 2)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_circle_outline,
                color: Colors.green,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Adicionar subcategoria",
                style: TypographyStyles.label3(),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
