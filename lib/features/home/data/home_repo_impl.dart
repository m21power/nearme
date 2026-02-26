import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nearme/core/constant/user_session.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/core/network/network_info_impl.dart';
import 'package:nearme/features/home/domain/entities/post_model.dart';
import 'package:nearme/features/home/domain/repository/home_repository.dart';
import 'package:nearme/features/profile/data/profile_repo_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRepoImpl implements HomeRepository {
  final SharedPreferences sharedPreferences;
  final FirebaseFirestore firestore;
  final NetworkInfo networkInfo;
  HomeRepoImpl({
    required this.sharedPreferences,
    required this.firestore,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, PostModel>> createPost(
    String? caption,
    String? imagePath,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      if (imagePath == null && (caption == null || caption.isEmpty)) {
        return Left(
          ServerFailure(message: "Please provide an image or a caption"),
        );
      }
      String? imageUrl;
      if (imagePath != null) {
        imageUrl = await uploadImageToCloudinary(File(imagePath));
        if (imageUrl == null) {
          return Left(ServerFailure(message: "Failed to upload image"));
        }
      }
      var postRef = await firestore.collection("posts").add({
        "username": UserSession.instance.name ?? "Unnamed User",
        "dept": UserSession.instance.dept ?? "---",
        "authorId": UserSession.instance.userId,
        "imageUrl": imageUrl,
        "caption": caption,
        "userProfilePic": UserSession.instance.profileImage,
        "likeCount": 0,
        "commentCount": 0,
        "createdAt": FieldValue.serverTimestamp(),
      });
      // then update the post with the generated id
      await postRef.update({"postId": postRef.id});
      return Right(
        PostModel(
          postId: postRef.id,
          userId: UserSession.instance.userId!,
          userName: UserSession.instance.name ?? "Unnamed User",
          dept: UserSession.instance.dept ?? "---",
          createdAt: DateTime.now().toString(),
          caption: caption,
          imageUrl: imageUrl,
          isLiked: false,
          userProfile: UserSession.instance.profileImage,
          likes: 0,
          comments: 0,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PostModel>>> fetchPosts() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      QuerySnapshot snapshot = await firestore
          .collection("posts")
          .orderBy("createdAt", descending: true)
          .get();
      List<PostModel> posts = await Future.wait(
        snapshot.docs.map((doc) async {
          var data = doc.data() as Map<String, dynamic>;
          // check if i already liked at check here posts/{postId}/likes/{userId}
          final userId = UserSession.instance.userId!;
          final likeRef = firestore
              .collection("posts")
              .doc(data["postId"])
              .collection("likes")
              .doc(userId);
          final likeDoc = await likeRef.get();
          final isLiked = likeDoc.exists;
          return PostModel(
            isLiked: isLiked,
            postId: data["postId"],
            userId: data["authorId"],
            userProfile: data["userProfilePic"],
            userName:
                data["username"] ??
                "Unnamed User", // Fallback to "Unnamed User"
            dept: data["dept"] ?? "---", // Fallback to "---" if dept is null
            createdAt: (data["createdAt"] as Timestamp).toDate().toString(),
            caption: data["caption"],
            imageUrl: data["imageUrl"],
            likes: data["likeCount"],
            comments: data["commentCount"],
          );
        }).toList(),
      );
      return Right(posts);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<void> likePost(String postId) {
    try {
      // check here posts/{postId}/likes/{userId}
      // if exists, then unlike the post by deleting the document
      // if not exists, then like the post by creating the document
      final userId = UserSession.instance.userId!;
      final likeRef = firestore
          .collection("posts")
          .doc(postId)
          .collection("likes")
          .doc(userId);
      return firestore.runTransaction((transaction) async {
        final likeDoc = await transaction.get(likeRef);
        if (likeDoc.exists) {
          // Unlike the post
          transaction.delete(likeRef);
          // Decrement like count
          final postRef = firestore.collection("posts").doc(postId);
          transaction.update(postRef, {"likeCount": FieldValue.increment(-1)});
        } else {
          // Like the post
          transaction.set(likeRef, {"likedAt": FieldValue.serverTimestamp()});
          // Increment like count
          final postRef = firestore.collection("posts").doc(postId);
          transaction.update(postRef, {"likeCount": FieldValue.increment(1)});
        }
      });
    } catch (e) {
      print("Error liking post: $e");
      return Future.error(e);
    }
  }
}
