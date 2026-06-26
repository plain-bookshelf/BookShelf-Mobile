class ProfileImageUploadResult {
  final String uploadUrl;
  final String imageKey;
  final String publicUrl;
  final String expiresAt;

  const ProfileImageUploadResult({
    required this.uploadUrl,
    required this.imageKey,
    required this.publicUrl,
    required this.expiresAt,
  });

  factory ProfileImageUploadResult.fromJson(Map<String, dynamic> json) {
    return ProfileImageUploadResult(
      uploadUrl: json['upload_url'] as String,
      imageKey: json['image_key'] as String,
      publicUrl: json['public_url'] as String,
      expiresAt: json['expires_at'] as String,
    );
  }
}
