import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dim/models/ProfileInfoModel.dart';

class ProfileService {
  final SupabaseClient _supabase;
  final FirebaseAuth _firebaseAuth;

  ProfileService({
    required SupabaseClient supabase,
    FirebaseAuth? firebaseAuth,
  })  : _supabase = supabase,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<ProfileInfoModel> getCurrentUserProfile() async {
    try {
      final String? uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) throw Exception('No authenticated user found');

      final response = await _supabase
          .from('users')
          .select()
          .eq('id', uid)
          .single();

      if (response == null) {
        // default values
        return await _createInitialProfile(uid);
      }

      List<SocialMediaHandle> socialHandles = [];
      if (response['social_media_handles'] != null) {
        final List<dynamic> handles = response['social_media_handles'];
        socialHandles = handles
            .map((handle) => SocialMediaHandle.fromJSON(handle))
            .toList();
      }

      return ProfileInfoModel(
        id: response['id'],
        userName: response['user_name'] ?? '',
        fullName: response['full_name'] ?? '',
        email: response['email'] ?? '',
        phoneNumber: response['phone_number'] ?? '',
        dateofBirth: response['date_of_birth'] != null
            ? DateTime.parse(response['date_of_birth'])
            : null,
        bio: response['bio'] ?? '',
        city: response['city'] ?? '',
        workplace: response['workplace'] ?? '',
        profileImagePath: response['photo_url']??'',
        profileImageBytes: null,
        followerCount: response['follower_count'] ?? 0,  // Fixed: changed from followerCount
        followingCount: response['following_count'] ?? 0,
        recipesCount: response['recipes_count'] ?? 0,
        socialMediaHandles: socialHandles,
      );
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  Future<ProfileInfoModel> _createInitialProfile(String uid) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('No authenticated user found');

    final initialProfile = ProfileInfoModel(
      id: uid,
      userName: user.displayName ?? '',
      fullName: user.displayName ?? '',
      email: user.email ?? '',
      phoneNumber: user.phoneNumber ?? '',
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

    final Map<String, dynamic> initialProfileMap = {
      'id': initialProfile.id,
      'user_name': initialProfile.userName,
      'full_name': initialProfile.fullName,
      'email': initialProfile.email,
      'phone_number': initialProfile.phoneNumber,
      'date_of_birth': initialProfile.dateofBirth?.toIso8601String(),
      'bio': initialProfile.bio,
      'city': initialProfile.city,
      'workplace': initialProfile.workplace,
      //'profile_image_path': initialProfile.profileImagePath,
      //'profile_image_bytes': initialProfile.profileImageBytes,
      'follower_count': initialProfile.followerCount,
      'following_count': initialProfile.followingCount,
      'recipes_count': initialProfile.recipesCount,
      'social_media_handles': initialProfile.socialMediaHandles.map((h) => h.toJSON()).toList(),
    };

    await _supabase.from('users').insert(initialProfileMap);

    return initialProfile;
  }

  Future<void> updateProfile(ProfileInfoModel profile) async {
    try {
      
      final Map<String, dynamic> updateMap = {
        'user_name': profile.userName,
        'full_name': profile.fullName,
        'email': profile.email,
        'phone_number': profile.phoneNumber,
        'date_of_birth': profile.dateofBirth?.toIso8601String(),
        'bio': profile.bio,
        'city': profile.city,
        'workplace': profile.workplace,
       'profile_image_path': profile.profileImagePath,
       'profile_image_bytes': profile.profileImageBytes,
        'follower_count': profile.followerCount,
        'following_count': profile.followingCount,
        'recipes_count': profile.recipesCount,
        'social_media_handles': profile.socialMediaHandles.map((h) => h.toJSON()).toList(),
      };

      await _supabase
          .from('users')
          .update(updateMap)
          .eq('id', profile.id);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}