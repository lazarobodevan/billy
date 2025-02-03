import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../theme/colors.dart';

class SlideWidget extends StatelessWidget {
  final Widget child;
  final Function onUpdate;
  final Function onDelete;

  const SlideWidget(
      {super.key,
      required this.child,
      required this.onUpdate,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      closeOnScroll: true,
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              onUpdate();
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
            onDelete();
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
      child: child,
    );
  }
}
