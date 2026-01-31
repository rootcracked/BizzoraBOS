import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'productNotifier.dart';
import 'productState.dart';

final productProvider = NotifierProvider<ProductNotifier, ProductState>(
  () => ProductNotifier(),
);
