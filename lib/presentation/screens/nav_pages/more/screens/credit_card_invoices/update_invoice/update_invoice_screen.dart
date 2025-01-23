import 'package:billy/presentation/shared/components/date_picker.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/material.dart';

class UpdateInvoiceScreen extends StatelessWidget {
  const UpdateInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar fatura", style: TypographyStyles.headline3(),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(label: Text("Valor")),
            ),
            const SizedBox(height: 16,),
            Row(
              children: [
                Flexible(child: DatePicker(onSelect: (val){}, label: "Data de início",)),
                const SizedBox(width: 16,),
                Flexible(child: DatePicker(onSelect: (val){}, label: "Data de fechamento",))
              ],
            ),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(fit: FlexFit.tight, child: DatePicker(onSelect: (val){}, label: "Data do pagamento",)),
                Flexible(
                  child: Column(
                    children: [
                      Text("Pago?"),
                      Switch(value: true, onChanged: (val){})
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
