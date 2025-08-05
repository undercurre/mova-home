// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountInfoHash() => r'10f860942c8fbb0da65b2205ca3d093cecd25d78';

/// 保存登录信息的provider
///
/// Copied from [AccountInfo].
@ProviderFor(AccountInfo)
final accountInfoProvider = NotifierProvider<AccountInfo, OAuthModel?>.internal(
  AccountInfo.new,
  name: r'accountInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$accountInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccountInfo = Notifier<OAuthModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
