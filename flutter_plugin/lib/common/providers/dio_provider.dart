import 'package:dreame_flutter_base_network/dreame_flutter_base_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(DioRef ref) {
  return DMHttpManager().dio;
}