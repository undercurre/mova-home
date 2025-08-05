import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Useful to log state change in our application
/// Read the logs and you'll better understand what's going on under the hood
class StateNotifierProviderObserver extends ProviderObserver {
  const StateNotifierProviderObserver();

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    LogUtils.d('''
{
  provider didUpdateProvider : ${provider.name ?? provider.runtimeType},
  oldValue: $previousValue,
  newValue: $newValue
}
''');
  }

  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value, ProviderContainer container) {
    super.didAddProvider(provider, value, container);
    LogUtils.d('''
{
   provider didAddProvider : ${provider.name ?? provider.runtimeType},
}
''');
  }

  @override
  void didDisposeProvider(ProviderBase<Object?> provider, ProviderContainer container) {
    super.didDisposeProvider(provider, container);
    LogUtils.d('''
{
   provider didDisposeProvider : ${provider.name ?? provider.runtimeType},
}
''');
  }
}
