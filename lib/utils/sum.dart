
import 'package:intl/intl.dart';
import 'package:tech_haven_admin/core/model/product_order_model.dart';

String formatDateTime(DateTime dateTime) {
  return DateFormat('dd/MM/yyyy').format(dateTime);
} 

calculateTotalPrizeForVendorOrdrer(
      {required List<ProductOrderModel> productOrderModel}) {
    double sum = 0;
    for (var element in productOrderModel) {
      sum += (element.quantity * element.price) + element.shippingCharge;
      // sum = sum + element.shippingCharge;
    }
    return sum;
  }
  
