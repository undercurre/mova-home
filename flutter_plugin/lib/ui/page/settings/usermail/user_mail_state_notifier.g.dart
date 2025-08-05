// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_mail_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userMailStateNotifierHash() =>
    r'4067124fe8127ae252777431cce2d18317d68632';

/// See also [UserMailStateNotifier].
@ProviderFor(UserMailStateNotifier)
final userMailStateNotifierProvider = AutoDisposeNotifierProvider<
    UserMailStateNotifier, UserMailUiState>.internal(
  UserMailStateNotifier.new,
  name: r'userMailStateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userMailStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserMailStateNotifier = AutoDisposeNotifier<UserMailUiState>;
String _$userMailUiEventHash() => r'cd2e284519bab76a52cc009c7d22bb3cba6bf72f';

/// See also [UserMailUiEvent].
@ProviderFor(UserMailUiEvent)
final userMailUiEventProvider =
    AutoDisposeNotifierProvider<UserMailUiEvent, CommonUIEvent>.internal(
  UserMailUiEvent.new,
  name: r'userMailUiEventProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userMailUiEventHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserMailUiEvent = AutoDisposeNotifier<CommonUIEvent>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
