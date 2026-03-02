import 'package:equatable/equatable.dart';

class RequestModel extends Equatable {
  final List<ConnectionRequestModel> request;
  final int unseenCount;

  const RequestModel({required this.request, required this.unseenCount});

  @override
  List<Object> get props => [request, unseenCount];
}

class ConnectionRequestModel {
  final String connectionId;
  final String notificationId;
  final String userId;
  final String name;
  final String dept;
  final String year;
  final String profilePicUrl;
  final String requestedAt;
  ConnectionRequestModel({
    required this.notificationId,
    required this.userId,
    required this.name,
    required this.dept,
    required this.year,
    required this.profilePicUrl,
    required this.requestedAt,
    this.connectionId = '',
  });
}

class ConnectionModel {
  final String connectionId;
  final String userId;
  final String name;
  final String dept;
  final String year;
  final String profilePicUrl;
  final String connectedAt;
  ConnectionModel({
    required this.connectionId,
    required this.userId,
    required this.name,
    required this.dept,
    required this.year,
    required this.profilePicUrl,
    required this.connectedAt,
  });
}

class ConnectionSuggestionModel {
  final String userId;
  final String name;
  final String dept;
  final String year;
  final String profilePicUrl;
  final bool? requested;
  ConnectionSuggestionModel({
    required this.userId,
    required this.name,
    required this.dept,
    required this.year,
    required this.profilePicUrl,
    this.requested,
  });

  ConnectionSuggestionModel copyWith({
    String? userId,
    String? name,
    String? dept,
    String? year,
    String? profilePicUrl,
    bool? requested,
  }) {
    return ConnectionSuggestionModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      dept: dept ?? this.dept,
      year: year ?? this.year,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      requested: requested ?? this.requested,
    );
  }
}
