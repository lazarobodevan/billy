import 'package:billy/presentation/shared/components/action_button.dart';
import 'package:billy/presentation/shared/components/transaction_item.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary2,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: ThemeColors.primary1),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Lázaro Bodevan",
                            style: TypographyStyles.label3(),
                          )
                        ],
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: ThemeColors.primary3,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  offset: const Offset(0, 4),
                                  blurRadius: 4),
                            ]),
                        child: const Icon(Icons.notifications_none),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Text(
                    "Disponível na conta",
                    style: TypographyStyles.paragraph3(),
                  ),
                  Text(
                    "R\$9.999,99",
                    style: TypographyStyles.headline3(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Limite no cartão",
                        style: TypographyStyles.label2(),
                      ),
                      Text(
                        "R\$9.999,99",
                        style: TypographyStyles.paragraph3(),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: Colors.black12,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 1,
                        color: Colors.black,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text("Fatura: R\$999,99"),
                  const SizedBox(
                    height: 22,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: ActionButton(
                        text: "Pagar",
                        icon: Icons.payments_sharp,
                        onTap: () {
                          Navigator.of(context).pushNamed("/transaction");
                        },
                      )),
                      const SizedBox(
                        width: 40,
                      ),
                      Flexible(
                          child: ActionButton(
                        text: "Receber",
                        icon: Icons.add_circle,
                        onTap: () {
                          Navigator.of(context).pushNamed("/transaction");
                        },
                      )),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: ThemeColors.primary3,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50)),
                    boxShadow: [BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0,-2),
                      blurRadius: 10
                    )]),
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
                    const SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Operações", style: TypographyStyles.label2(),),
                        Text("Ver todas", style: TypographyStyles.label2().copyWith(color: ThemeColors.secondary1),),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: ScrollController(),
                        child: Column(
                          children: [
                            TransactionItem(),
                            const SizedBox(height: 10,),
                            TransactionItem(),
                            const SizedBox(height: 10,),
                            TransactionItem(),
                            const SizedBox(height: 10,),
                            TransactionItem(),
                            const SizedBox(height: 10,),
                            TransactionItem(),
                            const SizedBox(height: 10,),
                            TransactionItem(),
                            const SizedBox(height: 10,),
                            TransactionItem(),
                            const SizedBox(height: 10,),
                            TransactionItem(),
                            const SizedBox(height: 10,),
                          ]
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
