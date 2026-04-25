import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nearme/core/constant/user_session.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/core/network/network_info_impl.dart';
import 'package:nearme/features/home/domain/entities/comment_model.dart';
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
      // thenupdate post count in user document
      var userRef = firestore
          .collection("users")
          .doc(UserSession.instance.userId);
      await userRef.update({"postCount": FieldValue.increment(1)});
      UserSession.instance.postCount =
          (UserSession.instance.postCount ?? 0) + 1;
      UserSession.instance.save();
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

  @override
  Future<void> commentOnPost(String postId, String comment) async {
    if (!await networkInfo.isConnected) {
      return Future.error("No internet connection");
    }
    var user = {
      "userId": UserSession.instance.userId!,
      "userName": UserSession.instance.name ?? "Unnamed User",
      "userProfile": UserSession.instance.profileImage,
      "dept": UserSession.instance.dept ?? "---",
      "comment": comment,
      "createdAt": FieldValue.serverTimestamp(),
    };
    // first add the comment at posts/{postId}/comments/{commentId}
    var commentRef = await firestore
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .add(user);
    // then update the comment with the generated id
    await commentRef.update({"commentId": commentRef.id});
    // finally increment the comment count at posts/{postId}
    var postRef = firestore.collection("posts").doc(postId);
    await postRef.update({"commentCount": FieldValue.increment(1)});
  }

  @override
  Future<Either<Failure, List<CommentModel>>> fetchComments(
    String postId,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      QuerySnapshot snapshot = await firestore
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .orderBy("createdAt", descending: true)
          .get();
      List<CommentModel> comments = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return CommentModel(
          id: data["commentId"],
          userId: data["userId"],
          userName: data["userName"] ?? "Unnamed User",
          imageUrl: data["userProfile"],
          dept: data["dept"] ?? "---",
          comment: data["comment"],
          createdAt: (data["createdAt"] as Timestamp).toDate().toString(),
        );
      }).toList();
      return Right(comments);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    if (!await networkInfo.isConnected) {
      return;
    }
    try {
      // Find the comment document across all posts and delete it
      var postsSnapshot = await firestore.collection("posts").get();
      for (var postDoc in postsSnapshot.docs) {
        var commentsSnapshot = await postDoc.reference
            .collection("comments")
            .where("commentId", isEqualTo: commentId)
            .get();
        for (var commentDoc in commentsSnapshot.docs) {
          await commentDoc.reference.delete();
          // Decrement the comment count on the post
          await postDoc.reference.update({
            "commentCount": FieldValue.increment(-1),
          });
          return; // Exit after deleting the comment
        }
      }
    } catch (e) {
      print("Error deleting comment: $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    if (!await networkInfo.isConnected) {
      return;
    }
    try {
      // First delete all comments and likes associated with the post
      var postRef = firestore.collection("posts").doc(postId);
      var commentsSnapshot = await postRef.collection("comments").get();
      for (var commentDoc in commentsSnapshot.docs) {
        await commentDoc.reference.delete();
      }
      var likesSnapshot = await postRef.collection("likes").get();
      for (var likeDoc in likesSnapshot.docs) {
        await likeDoc.reference.delete();
      }
      // Then delete the post itself
      await postRef.delete();
      var userRef = firestore
          .collection("users")
          .doc(UserSession.instance.userId);
      await userRef.update({"postCount": FieldValue.increment(-1)});
      UserSession.instance.postCount =
          (UserSession.instance.postCount ?? 1) - 1;
      UserSession.instance.save();
    } catch (e) {
      print("Error deleting post: $e");
    }
  }

  Future<Either<Failure, List<PostModel>>> fetchMyPost() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }

    try {
      final currentUserId = UserSession.instance.userId!;
      final snapshot = await firestore
          .collection("posts")
          .where("authorId", isEqualTo: currentUserId)
          .orderBy("createdAt", descending: true)
          .get();

      final posts = await Future.wait(
        snapshot.docs.map((doc) async {
          final data = doc.data() as Map<String, dynamic>? ?? {};

          final likeDoc = await firestore
              .collection("posts")
              .doc(data["postId"])
              .collection("likes")
              .doc(currentUserId)
              .get();

          return PostModel(
            isLiked: likeDoc.exists,
            postId: data["postId"] ?? "",
            userId: data["authorId"] ?? "",
            userProfile: data["userProfilePic"] ?? "",
            userName: data["username"] ?? "Unnamed User",
            dept: data["dept"] ?? "---",
            createdAt:
                (data["createdAt"] as Timestamp?)?.toDate().toIso8601String() ??
                "",
            caption: data["caption"] ?? "",
            imageUrl: data["imageUrl"] ?? "",
            likes: data["likeCount"] ?? 0,
            comments: data["commentCount"] ?? 0,
          );
        }),
      );
      print("Fetched ${posts.length} posts for current user");
      return Right(posts);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
