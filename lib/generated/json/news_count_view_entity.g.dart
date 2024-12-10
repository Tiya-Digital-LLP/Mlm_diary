import 'package:mlmdiary/generated/json/base/json_convert_content.dart';
import 'package:mlmdiary/generated/news_count_view_entity.dart';

NewsCountViewEntity $NewsCountViewEntityFromJson(Map<String, dynamic> json) {
  final NewsCountViewEntity newsCountViewEntity = NewsCountViewEntity();
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    newsCountViewEntity.status = status;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    newsCountViewEntity.message = message;
  }
  return newsCountViewEntity;
}

Map<String, dynamic> $NewsCountViewEntityToJson(NewsCountViewEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['status'] = entity.status;
  data['message'] = entity.message;
  return data;
}

extension NewsCountViewEntityExtension on NewsCountViewEntity {
  NewsCountViewEntity copyWith({
    int? status,
    String? message,
  }) {
    return NewsCountViewEntity()
      ..status = status ?? this.status
      ..message = message ?? this.message;
  }
}