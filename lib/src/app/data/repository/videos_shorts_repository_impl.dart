import 'dart:async';

import 'package:chat/src/app/core/exceptions/data_source_exception.dart';
import 'package:chat/src/app/core/exceptions/repository_exception.dart';
import 'package:chat/src/app/data/datasource/chat_videos_rest_client.dart';
import 'package:chat/src/app/data/dto/story_dto.dart';
import 'package:chat/src/app/domain/model/videos.dart';
import 'package:chat/src/app/domain/repository/videos_shorts_repository.dart';

class VideosShortsRepositoryImpl implements VideosShortsRepository {
  final videos = [
    Video(
      descrition: "Passeio na praia ao pôr do sol 🌅",
      urlVideo: "https://www.pexels.com/pt-br/download/video/2231485/",
      duration: 30,
      ownerId: 1,
      ownerName: "Alice Souza",
      ownerUrlImge:
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg",
      exparesAt: DateTime.now().add(const Duration(days: 1)),
      createdAt: DateTime.now(),
    ),
    Video(
      descrition: "Treino rápido de HIIT 💪",
      urlVideo: "https://www.pexels.com/pt-br/download/video/5310972/",
      duration: 45,
      ownerId: 2,
      ownerName: "Carlos Oliveira",
      ownerUrlImge:
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg",
      exparesAt: DateTime.now().add(const Duration(days: 2)),
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Video(
      descrition: "Receita de bolo de chocolate 🍫",
      urlVideo: "https://www.pexels.com/pt-br/download/video/3992584/",
      duration: 60,
      ownerId: 3,
      ownerName: "Maria Silva",
      ownerUrlImge:
          "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg",
      exparesAt: DateTime.now().add(const Duration(hours: 12)),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Video(
      descrition: "Truques de mágica impressionantes 🎩✨",
      urlVideo: "https://www.pexels.com/pt-br/download/video/3760750/",
      duration: 25,
      ownerId: 4,
      ownerName: "João Pedro",
      ownerUrlImge:
          "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg",
      exparesAt: DateTime.now().add(const Duration(days: 3)),
      createdAt: DateTime.now().subtract(const Duration(hours: 10)),
    ),
    Video(
      descrition: "Tour pelo meu setup gamer 🎮",
      urlVideo: "https://www.pexels.com/pt-br/download/video/8128342/",
      duration: 55,
      ownerId: 5,
      ownerName: "Beatriz Lima",
      ownerUrlImge:
          "https://images.pexels.com/photos/103123/pexels-photo-103123.jpeg",
      exparesAt: DateTime.now().add(const Duration(days: 5)),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];
  final ChatVideosRestClient _chatVideosRestClient;
  VideosShortsRepositoryImpl({required ChatVideosRestClient chatVideosRestClient})
    : _chatVideosRestClient = chatVideosRestClient;

  @override
  Future<List<Video>> finalAll() async {
    return Future.value(videos);
  }

  @override
  Future<List<StoryDto>> findStoryMyContacts(int id) async {
    try {
      return await _chatVideosRestClient.auth().findStoryMyContacts(id);
    } on DataSourceException catch (e) {
      throw RepositoryException(message: e.message);
    }
  }
}
