// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_phone_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userPhoneStateNotifierHash() =>
    r'1b50f4c8501a76f65fd016c9238f5e56a0244f2a';

/// See also [UserPhoneStateNotifier].
@ProviderFor(UserPhoneStateNotifier)
final userPhoneStateNotifierProvider = AutoDisposeNotifierProvider<
    UserPhoneStateNotifier, UserPhoneUiState>.internal(
  UserPhoneStateNotifier.new,
  name: r'userPhoneStateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userPhoneStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserPhoneStateNotifier = AutoDisposeNotifier<UserPhoneUiState>;
String _$userPhoneEventHash() => r'6f4c8424137e6eb078b589a05886f39fff03a911';

/// See also [UserPhoneEvent].
@ProviderFor(UserPhoneEvent)
final userPhoneEventProvider =
    AutoDisposeNotifierProvider<UserPhoneEvent, CommonUIEvent>.internal(
  UserPhoneEvent.new,
  name: r'userPhoneEventProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userPhoneEventHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserPhoneEvent = AutoDisposeNotifier<CommonUIEvent>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
