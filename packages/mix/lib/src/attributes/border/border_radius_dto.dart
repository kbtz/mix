// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../internal/diagnostic_properties_builder_ext.dart';

part 'border_radius_dto.g.dart';

/// Represents a [Dto] Data transfer object of [BorderRadiusGeometry]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a [BorderRadiusGeometry]
///
/// This Dto implements `BorderRadius` and `BorderRadiusDirectional` Flutter classes to allow for
/// better merging support, and cleaner API for the utilities
///
/// See also:
/// - [BorderRadiusGeometry], which is the Flutter counterpart of this class.
@immutable
sealed class BorderRadiusGeometryDto<T extends BorderRadiusGeometry>
    extends Dto<T> with Diagnosticable {
  const BorderRadiusGeometryDto();

  Radius? get topLeft;
  Radius? get topRight;
  Radius? get bottomLeft;
  Radius? get bottomRight;
  Radius? get topStart;
  Radius? get topEnd;
  Radius? get bottomStart;
  Radius? get bottomEnd;
  @visibleForTesting
  Radius getRadiusValue(MixData mix, Radius? radius) {
    if (radius == null) return Radius.zero;

    return radius is RadiusRef ? mix.tokens.radiiRef(radius) : radius;
  }

  @override
  BorderRadiusGeometryDto<T> merge(covariant BorderRadiusGeometryDto<T>? other);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.addUsingDefault('topLeft', topLeft);
    properties.addUsingDefault('topRight', topRight);
    properties.addUsingDefault('bottomLeft', bottomLeft);
    properties.addUsingDefault('bottomRight', bottomRight);
    properties.addUsingDefault('topStart', topStart);
    properties.addUsingDefault('topEnd', topEnd);
    properties.addUsingDefault('bottomStart', bottomStart);
    properties.addUsingDefault('bottomEnd', bottomEnd);
  }

  @override
  T resolve(MixData mix);
}

@MixableDto(generateUtility: false)
final class BorderRadiusDto extends BorderRadiusGeometryDto<BorderRadius>
    with _$BorderRadiusDto {
  @override
  final Radius? topLeft;
  @override
  final Radius? topRight;
  @override
  final Radius? bottomLeft;
  @override
  final Radius? bottomRight;

  const BorderRadiusDto({
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight,
  });

  @override
  BorderRadius resolve(MixData mix) {
    return BorderRadius.only(
      topLeft: getRadiusValue(mix, topLeft),
      topRight: getRadiusValue(mix, topRight),
      bottomLeft: getRadiusValue(mix, bottomLeft),
      bottomRight: getRadiusValue(mix, bottomRight),
    );
  }

  @override
  Radius? get topStart => null;
  @override
  Radius? get topEnd => null;
  @override
  Radius? get bottomStart => null;
  @override
  Radius? get bottomEnd => null;

  @override
  BorderRadius get defaultValue => BorderRadius.zero;
}

@MixableDto(generateUtility: false)
final class BorderRadiusDirectionalDto
    extends BorderRadiusGeometryDto<BorderRadiusDirectional>
    with _$BorderRadiusDirectionalDto {
  @override
  final Radius? topStart;
  @override
  final Radius? topEnd;
  @override
  final Radius? bottomStart;
  @override
  final Radius? bottomEnd;

  const BorderRadiusDirectionalDto({
    this.topStart,
    this.topEnd,
    this.bottomStart,
    this.bottomEnd,
  });

  @override
  BorderRadiusDirectional resolve(MixData mix) {
    return BorderRadiusDirectional.only(
      topStart: getRadiusValue(mix, topStart),
      topEnd: getRadiusValue(mix, topEnd),
      bottomStart: getRadiusValue(mix, bottomStart),
      bottomEnd: getRadiusValue(mix, bottomEnd),
    );
  }

  @override
  Radius? get topLeft => null;
  @override
  Radius? get topRight => null;
  @override
  Radius? get bottomLeft => null;
  @override
  Radius? get bottomRight => null;

  @override
  BorderRadiusDirectional get defaultValue => BorderRadiusDirectional.zero;
}

extension BorderRadiusGeometryMixExt on BorderRadiusGeometry {
  BorderRadiusGeometryDto toDto() {
    if (this is BorderRadius) {
      return (this as BorderRadius).toDto();
    }
    if (this is BorderRadiusDirectional) {
      return (this as BorderRadiusDirectional).toDto();
    }
    throw ArgumentError.value(
      this,
      'radius',
      'BorderRadiusGeometry type is not supported',
    );
  }
}
