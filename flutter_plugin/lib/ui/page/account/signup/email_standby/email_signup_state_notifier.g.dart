// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_signup_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$emailSignUpStateNotifierHash() =>
    r'473f554ce8d78507d30d862143bd6c48d62de327';

/// See also [EmailSignUpStateNotifier].
@ProviderFor(EmailSignUpStateNotifier)
final emailSignUpStateNotifierProvider = AutoDisposeNotifierProvider<
    EmailSignUpStateNotifier, EmailSignUpUiState>.internal(
  EmailSignUpStateNotifier.new,
  name: r'emailSignUpStateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$emailSignUpStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EmailSignUpStateNotifier = AutoDisposeNotifier<EmailSignUpUiState>;
String _$emailSignUpUiEventHash() =>
    r'9edc6c75fa579f6d8d7c9ce3f879c910f8de59d2';

/// See also [EmailSignUpUiEvent].
@ProviderFor(EmailSignUpUiEvent)
final emailSignUpUiEventProvider =
    AutoDisposeNotifierProvider<EmailSignUpUiEvent, CommonUIEvent>.internal(
  EmailSignUpUiEvent.new,
  name: r'emailSignUpUiEventProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$emailSignUpUiEventHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EmailSignUpUiEvent = AutoDisposeNotifier<CommonUIEvent>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
