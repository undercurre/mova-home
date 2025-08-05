// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_guide_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customGuideStateNotifierHash() =>
    r'3d9ee570560595ab1094534fc6f512ba2b093fb2';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$CustomGuideStateNotifier
    extends BuildlessAutoDisposeNotifier<CustomGuideUiState> {
  late final String? guideId;

  CustomGuideUiState build(
    String? guideId,
  );
}

/// See also [CustomGuideStateNotifier].
@ProviderFor(CustomGuideStateNotifier)
const customGuideStateNotifierProvider = CustomGuideStateNotifierFamily();

/// See also [CustomGuideStateNotifier].
class CustomGuideStateNotifierFamily extends Family<CustomGuideUiState> {
  /// See also [CustomGuideStateNotifier].
  const CustomGuideStateNotifierFamily();

  /// See also [CustomGuideStateNotifier].
  CustomGuideStateNotifierProvider call(
    String? guideId,
  ) {
    return CustomGuideStateNotifierProvider(
      guideId,
    );
  }

  @override
  CustomGuideStateNotifierProvider getProviderOverride(
    covariant CustomGuideStateNotifierProvider provider,
  ) {
    return call(
      provider.guideId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'customGuideStateNotifierProvider';
}

/// See also [CustomGuideStateNotifier].
class CustomGuideStateNotifierProvider extends AutoDisposeNotifierProviderImpl<
    CustomGuideStateNotifier, CustomGuideUiState> {
  /// See also [CustomGuideStateNotifier].
  CustomGuideStateNotifierProvider(
    String? guideId,
  ) : this._internal(
          () => CustomGuideStateNotifier()..guideId = guideId,
          from: customGuideStateNotifierProvider,
          name: r'customGuideStateNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customGuideStateNotifierHash,
          dependencies: CustomGuideStateNotifierFamily._dependencies,
          allTransitiveDependencies:
              CustomGuideStateNotifierFamily._allTransitiveDependencies,
          guideId: guideId,
        );

  CustomGuideStateNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.guideId,
  }) : super.internal();

  final String? guideId;

  @override
  CustomGuideUiState runNotifierBuild(
    covariant CustomGuideStateNotifier notifier,
  ) {
    return notifier.build(
      guideId,
    );
  }

  @override
  Override overrideWith(CustomGuideStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: CustomGuideStateNotifierProvider._internal(
        () => create()..guideId = guideId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        guideId: guideId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<CustomGuideStateNotifier,
      CustomGuideUiState> createElement() {
    return _CustomGuideStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomGuideStateNotifierProvider &&
        other.guideId == guideId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, guideId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CustomGuideStateNotifierRef
    on AutoDisposeNotifierProviderRef<CustomGuideUiState> {
  /// The parameter `guideId` of this provider.
  String? get guideId;
}

class _CustomGuideStateNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<CustomGuideStateNotifier,
        CustomGuideUiState> with CustomGuideStateNotifierRef {
  _CustomGuideStateNotifierProviderElement(super.provider);

  @override
  String? get guideId => (origin as CustomGuideStateNotifierProvider).guideId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
