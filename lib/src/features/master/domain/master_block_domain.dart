// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'master_block_domain.freezed.dart';
part 'master_block_domain.g.dart';

@freezed
class MasterBlockDomain with _$MasterBlockDomain {
  const factory MasterBlockDomain({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "number") String? number,
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
    @JsonKey(name: "published_at") DateTime? publishedAt,
    @JsonKey(name: "created_by_id") int? createdById,
    @JsonKey(name: "updated_by_id") int? updatedById,
  }) = _MasterBlockDomain;

  factory MasterBlockDomain.fromJson(Map<String, dynamic> json) => _$MasterBlockDomainFromJson(json);
}
