import 'package:billy/presentation/screens/nav_pages/home/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/typography.dart';
import '../bloc/home_bloc.dart';

class DraggableTransactionsContainer extends StatefulWidget {
  final VoidCallback onHide;
  final ValueChanged<double> onSizeChanged;

  const DraggableTransactionsContainer(
      {super.key, required this.onHide, required this.onSizeChanged});

  @override
  State<DraggableTransactionsContainer> createState() =>
      _DraggableTransactionsContainerState();
}

class _DraggableTransactionsContainerState
    extends State<DraggableTransactionsContainer> {
  double _currentChildSize = 1.0;
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();

  void _animateToSize(double size) {
    _draggableController
        .animateTo(
      size,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    )
        .then((_) {
      // Atualiza o tamanho atual após a animação
      setState(() {
        _currentChildSize = size;
        widget.onSizeChanged(_currentChildSize);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragUpdate: (details) {
          // Atualiza o tamanho durante o arraste
          setState(() {
            _currentChildSize -=
                details.primaryDelta! / MediaQuery.of(context).size.height;
            _currentChildSize = _currentChildSize.clamp(0.0, 1.0);

            // Limite para iniciar a animação
            if (_currentChildSize < 0.5) {
              _animateToSize(0.0); // Ocultar
            } else {
              widget.onSizeChanged(_currentChildSize);
            }
          });
        },
        onVerticalDragEnd: (details) {
          // Verifica se a velocidade de arraste é suficiente para ocultar
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 500) {
            widget.onHide();
          } else {
            _animateToSize(1.0); // Voltar ao tamanho completo
          }
        },
        child: NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            if (notification.extent < 0.4) {
              widget.onHide();
            }
            return true;
          },
          child: DraggableScrollableSheet(
            initialChildSize: _currentChildSize,
            minChildSize: 0.0,
            maxChildSize: 1.0,
            controller: _draggableController,
            builder: (context, scrollController) {
              return Container(
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
              );
            },
          ),
        ));
  }
}
