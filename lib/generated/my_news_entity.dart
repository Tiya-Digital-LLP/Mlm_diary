import 'package:mlmdiary/generated/json/base/json_field.dart';
import 'package:mlmdiary/generated/json/my_news_entity.g.dart';
import 'dart:convert';
export 'package:mlmdiary/generated/json/my_news_entity.g.dart';

@JsonSerializable()
class MyNewsEntity {
	int? status = 0;
	String? message = '';
	List<MyNewsData>? data = [];

	MyNewsEntity();

	factory MyNewsEntity.fromJson(Map<String, dynamic> json) => $MyNewsEntityFromJson(json);

	Map<String, dynamic> toJson() => $MyNewsEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class MyNewsData {
	int? id = 0;
	String? title = '';
	String? photo = '';
	String? description = '';
	int? pgcnt = 0;
	String? createdate = '';
	String? category = '';
	String? creatby = '';
	String? subcategory = '';
	String? website = '';
	String? urlcomponent = '';
	int? totallike = 0;
	int? totalbookmark = 0;
	int? totalcomment = 0;
	@JSONField(name: "liked_by_user")
	bool? likedByUser = false;
	@JSONField(name: "bookmarked_by_user")
	bool? bookmarkedByUser = false;
	@JSONField(name: "user_data")
	MyNewsDataUserData? userData;
	@JSONField(name: "image_path")
	String? imagePath = '';

	MyNewsData();

	factory MyNewsData.fromJson(Map<String, dynamic> json) => $MyNewsDataFromJson(json);

	Map<String, dynamic> toJson() => $MyNewsDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class MyNewsDataUserData {
	int? id = 0;
	String? name = '';
	String? userimage = '';
	String? email = '';
	String? mobile = '';
	String? countrycode1 = '';
	@JSONField(name: "image_path")
	String? imagePath = '';
	@JSONField(name: "image_thum_path")
	String? imageThumPath = '';

	MyNewsDataUserData();

	factory MyNewsDataUserData.fromJson(Map<String, dynamic> json) => $MyNewsDataUserDataFromJson(json);

	Map<String, dynamic> toJson() => $MyNewsDataUserDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}