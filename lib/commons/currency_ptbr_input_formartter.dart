import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyPtBrInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);
    final formatter = NumberFormat("#,##0.00", "pt_BR");
    String newText = "R\$ ${formatter.format(value / 100)}";

    return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
  }
}

// how to use
// Widget _fieldValues() {
//     return Padding(
//       padding: EdgeInsets.only(top: 10, bottom: 60),
//       child:  TextFormField(
//               decoration: InputDecoration(
//                 icon: Icon(Icons.monetization_on),
//                 labelText: 'Valor *',
//               ),
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 CurrencyPtBrInputFormatter()
//               ]
//        );
//  }
          