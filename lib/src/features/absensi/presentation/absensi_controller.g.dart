// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absensi_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$absensiControllerHash() => r'd76ff7105c69119fc6ea54c832ef314cdb39da97';

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

abstract class _$AbsensiController
    extends BuildlessAutoDisposeAsyncNotifier<List<dynamic>> {
  late final String clusterType;

  FutureOr<List<dynamic>> build({
    required String clusterType,
  });
}

/// See also [AbsensiController].
@ProviderFor(AbsensiController)
const absensiControllerProvider = AbsensiControllerFamily();

/// See also [AbsensiController].
class AbsensiControllerFamily extends Family<AsyncValue<List<dynamic>>> {
  /// See also [AbsensiController].
  const AbsensiControllerFamily();

  /// See also [AbsensiController].
  AbsensiControllerProvider call({
    required String clusterType,
  }) {
    return AbsensiControllerProvider(
      clusterType: clusterType,
    );
  }

  @override
  AbsensiControllerProvider getProviderOverride(
    covariant AbsensiControllerProvider provider,
  ) {
    return call(
      clusterType: provider.clusterType,
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
  String? get name => r'absensiControllerProvider';
}

/// See also [AbsensiController].
class AbsensiControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    AbsensiController, List<dynamic>> {
  /// See also [AbsensiController].
  AbsensiControllerProvider({
    required String clusterType,
  }) : this._internal(
          () => AbsensiController()..clusterType = clusterType,
          from: absensiControllerProvider,
          name: r'absensiControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$absensiControllerHash,
          dependencies: AbsensiControllerFamily._dependencies,
          allTransitiveDependencies:
              AbsensiControllerFamily._allTransitiveDependencies,
          clusterType: clusterType,
        );

  AbsensiControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.clusterType,
  }) : super.internal();

  final String clusterType;

  @override
  FutureOr<List<dynamic>> runNotifierBuild(
    covariant AbsensiController notifier,
  ) {
    return notifier.build(
      clusterType: clusterType,
    );
  }

  @override
  Override overrideWith(AbsensiController Function() create) {
    return ProviderOverride(
      origin: this,
      override: AbsensiControllerProvider._internal(
        () => create()..clusterType = clusterType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        clusterType: clusterType,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<AbsensiController, List<dynamic>>
      createElement() {
    return _AbsensiControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AbsensiControllerProvider &&
        other.clusterType == clusterType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, clusterType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AbsensiControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<dynamic>> {
  /// The parameter `clusterType` of this provider.
  String get clusterType;
}

class _AbsensiControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<AbsensiController,
        List<dynamic>> with AbsensiControllerRef {
  _AbsensiControllerProviderElement(super.provider);

  @override
  String get clusterType => (origin as AbsensiControllerProvider).clusterType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
