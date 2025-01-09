import 'dart:typed_data';
import 'package:intl/intl.dart';

class SocialMediaHandle {
  String platform;
  String handle;

  SocialMediaHandle({
    required this.platform,
    required this.handle,
  });

  Map<String, dynamic> toJSON() {
    return {
      'platform': platform,
      'handle': handle,
    };
  }

  factory SocialMediaHandle.fromJSON(Map<String, dynamic> map) {
    return SocialMediaHandle(
      platform: map['platform'] ?? '',
      handle: map['handle'] ?? '',
    );
  }
}

class ProfileInfoModel {
  String id;
  String userName;
  String fullName;
  String email;
  String phoneNumber;
  DateTime? dateofBirth;
  String bio;
  String city;
  String workplace;
  String profileImagePath;
  Uint8List? profileImageBytes;
  int followerCount;
  int followingCount;
  int recipesCount;
  List<SocialMediaHandle> socialMediaHandles;

  ProfileInfoModel({
    required this.id,
    required this.userName,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.dateofBirth,
    required this.bio,
    required this.city,
    required this.workplace,
    required this.profileImagePath,
    this.profileImageBytes,
    required this.followerCount,
    required this.followingCount,
    required this.recipesCount,
    required this.socialMediaHandles,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_name': userName,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'date_of_birth': dateofBirth != null ? DateFormat('yyyy-MM-dd').format(dateofBirth!) : null,
      'bio': bio,
      'city': city,
      'work_place': workplace,
      'profile_Image_Path': profileImagePath,
      'profile_Image_Bytes': profileImageBytes,
      'follower_Count': followerCount,
      'following_Count': followingCount,
      'recipes_Count': recipesCount,
      'social_Media_Handles': socialMediaHandles.map((x) => x.toJSON()).toList(),
    };
  }


  factory ProfileInfoModel.fromMap(Map<String, dynamic> map) {
    return ProfileInfoModel(
      id: map['id'] ?? '',
      userName: map['user_name'] ?? '',
      fullName: map['full_name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      dateofBirth: map['date_of_birth'],
      bio: map['bio'] ?? '',
      city: map['city'] ?? '',
      workplace: map['work_place'] ?? '',
      profileImagePath: map['profile_Image_Path'] ?? '',
      profileImageBytes: map['profile_Image_Bytes'],
      followerCount: map['follower_Count']?.toInt() ?? 0,
      followingCount: map['following_Count']?.toInt() ?? 0,
      recipesCount: map['recipes_Count']?.toInt() ?? 0,
      socialMediaHandles: List<SocialMediaHandle>.from(
        (map['social_Media_Handles'] ?? []).map(
              (x) => SocialMediaHandle.fromJSON(x),
        ),
      ),
    );
  }

  factory ProfileInfoModel.empty() {
    return ProfileInfoModel(
      id: '',
      userName: '',
      fullName: '',
      email: '',
      phoneNumber: '',
      dateofBirth: null,
      bio: '',
      city: '',
      workplace: '',
      profileImagePath: '',
      profileImageBytes: null,
      followerCount: 0,
      followingCount: 0,
      recipesCount: 0,
      socialMediaHandles: [],
    );
  }
}