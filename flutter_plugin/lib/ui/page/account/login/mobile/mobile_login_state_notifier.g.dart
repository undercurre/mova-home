// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_login_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mobileLoginControllerHash() =>
    r'56e5ef7330faecdb29b2eeb1b90ac9d117ddb067';

/// See also [MobileLoginController].
@ProviderFor(MobileLoginController)
final mobileLoginControllerProvider = AutoDisposeNotifierProvider<
    MobileLoginController, MobileLoginUiState>.internal(
  MobileLoginController.new,
  name: r'mobileLoginControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mobileLoginControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MobileLoginController = AutoDisposeNotifier<MobileLoginUiState>;
String _$mobileLoginEventHash() => r'1d63b57a26d7fb542cef4c3850c36fddc398ec9f';

/// See also [MobileLoginEvent].
@ProviderFor(MobileLoginEvent)
final mobileLoginEventProvider =
    AutoDisposeNotifierProvider<MobileLoginEvent, CommonUIEvent>.internal(
  MobileLoginEvent.new,
  name: r'mobileLoginEventProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mobileLoginEventHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MobileLoginEvent = AutoDisposeNotifier<CommonUIEvent>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
