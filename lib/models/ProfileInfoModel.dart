import 'dart:typed_data';

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
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'city': city,
      'workplace': workplace,
      'profileImagePath': profileImagePath,
      'profileImageBytes': profileImageBytes,
      'followerCount': followerCount,
      'followingCount': followingCount,
      'recipesCount': recipesCount,
      'socialMediaHandles': socialMediaHandles.map((x) => x.toJSON()).toList(),
    };
  }


  factory ProfileInfoModel.fromMap(Map<String, dynamic> map) {
    return ProfileInfoModel(
      id: map['id'] ?? '',
      userName: map['userName'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      bio: map['bio'] ?? '',
      city: map['city'] ?? '',
      workplace: map['workplace'] ?? '',
      profileImagePath: map['profileImagePath'] ?? '',
      profileImageBytes: map['profileImageBytes'],
      followerCount: map['followerCount']?.toInt() ?? 0,
      followingCount: map['followingCount']?.toInt() ?? 0,
      recipesCount: map['recipesCount']?.toInt() ?? 0,
      socialMediaHandles: List<SocialMediaHandle>.from(
        (map['socialMediaHandles'] ?? []).map(
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