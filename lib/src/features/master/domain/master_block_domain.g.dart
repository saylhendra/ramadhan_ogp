// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_block_domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MasterBlockDomainImpl _$$MasterBlockDomainImplFromJson(
        Map<String, dynamic> json) =>
    _$MasterBlockDomainImpl(
      id: json['id'] as int?,
      title: json['title'] as String?,
      number: json['number'] as String?,
      description: json['description'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      publishedAt: json['published_at'] == null
          ? null
          : DateTime.parse(json['published_at'] as String),
      createdById: json['created_by_id'] as int?,
      updatedById: json['updated_by_id'] as int?,
    );

Map<String, dynamic> _$$MasterBlockDomainImplToJson(
        _$MasterBlockDomainImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'number': instance.number,
      'description': instance.description,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'published_at': instance.publishedAt?.toIso8601String(),
      'created_by_id': instance.createdById,
      'updated_by_id': instance.updatedById,
    };
