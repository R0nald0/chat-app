import 'package:chat/src/app/core/exceptions/repository_exception.dart';
import 'package:chat/src/app/data/dto/story_dto.dart';
import 'package:chat/src/app/domain/repository/find_my_repository.dart';
import 'package:chat/src/app/domain/repository/videos_shorts_repository.dart';
import 'package:chat/src/app/domain/usecase/conversation_use_case.dart';

class FindStoryMyContacts {
  final VideosShortsRepository _videosShortsRepository;
  final FindMyRepository _findMyRepository;
  FindStoryMyContacts({
    required VideosShortsRepository videosShortsRepository,
    required FindMyRepository findMyRepository,
  }) : _videosShortsRepository = videosShortsRepository,
       _findMyRepository = findMyRepository;
  Future<List<StoryDto>> call() async {
    try {
      final user = await _findMyRepository.findMy();
      return _videosShortsRepository.findStoryMyContacts(user.id!);
    } on RepositoryException catch (e) {
      throw ServiceException(message: e.message ?? 'Erro ao buscar dados do usuário');
    }
  }
}
