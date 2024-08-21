import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/components/transaction_item.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/typography.dart';
import '../bloc/home_bloc.dart';

class DraggableTransactionsContainer extends StatefulWidget {
  final VoidCallback onHide;
  final ValueChanged<double> onSizeChanged;
  const DraggableTransactionsContainer({super.key, required this.onHide, required this.onSizeChanged});

  @override
  State<DraggableTransactionsContainer> createState() => _DraggableTransactionsContainerState();
}

class _DraggableTransactionsContainerState extends State<DraggableTransactionsContainer> {
  double _currentChildSize = 1.0;
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          _currentChildSize -= details.primaryDelta! / MediaQuery.of(context).size.height;
          if (_currentChildSize < 0.0) {
            _currentChildSize = 0.0;
          } else if (_currentChildSize > 1.0) {
            _currentChildSize = 1.0;
          }
          print('Current size: $_currentChildSize');
          widget.onSizeChanged(_currentChildSize);
        });
      },
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! > 500) {
          widget.onHide();
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: _currentChildSize,
        minChildSize: 0.0,
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              setState(() {
                _currentChildSize = notification.extent;
                widget.onSizeChanged(_currentChildSize);
                if (_currentChildSize < 0.7) {
                  widget.onHide();
                }
                print(_currentChildSize);
              });
              return true;
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: ThemeColors.primary3,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, -2),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Operações", style: TypographyStyles.label2()),
                      Text(
                        "Ver todas",
                        style: TypographyStyles.label2()
                            .copyWith(color: ThemeColors.secondary1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        if (state is LoadingHomeState) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: ThemeColors.primary1,
                            ),
                          );
                        }
                        if (state is LoadedHomeState) {
                          if (state.transactions.isEmpty) {
                            return Center(
                              child: Text(
                                "Sem transações",
                                style: TypographyStyles.paragraph3(),
                              ),
                            );
                          }
                          return ListView.builder(
                            controller: scrollController,
                            itemCount: state.transactions.length,
                            itemBuilder: (context, index) {
                              return TransactionItem(
                                  transaction: state.transactions[index]);
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}