import 'package:dartz/dartz.dart';
import 'package:nearme/features/home/domain/entities/post_model.dart'
    show ViewerModel;

import '../../../../../core/error/failure.dart';
import '../../repository/story_repository.dart';

class FetchViewerUseCase {
  final StoryRepository repository;

  FetchViewerUseCase(this.repository);

  Future<Either<Failure, List<ViewerModel>>> call(String storyId) async {
    return await repository.fetchViewer(storyId);
  }
}
