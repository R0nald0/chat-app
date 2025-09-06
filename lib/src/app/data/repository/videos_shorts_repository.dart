
import 'dart:async';

import 'package:chat/src/app/domain/model/videos.dart';
import 'package:chat/src/app/domain/repository/short_video_repository.dart';

class VideosShortsRepository implements ShortVideoRepository{
  final videos = [
  Video(
    descrition: "Passeio na praia ao pôr do sol 🌅",
    urlVideo: "https://www.pexels.com/pt-br/download/video/2231485/",
    duration: 30,
    ownerId: 1,
    ownerName: "Alice Souza",
    ownerUrlImge: "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg",
    exparesAt: DateTime.now().add(const Duration(days: 1)),
    createdAt: DateTime.now(),
  ),
  Video(
    descrition: "Treino rápido de HIIT 💪",
    urlVideo: "https://www.pexels.com/pt-br/download/video/5310972/",
    duration: 45,
    ownerId: 2,
    ownerName: "Carlos Oliveira",
    ownerUrlImge: "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg",
    exparesAt: DateTime.now().add(const Duration(days: 2)),
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  Video(
    descrition: "Receita de bolo de chocolate 🍫",
    urlVideo: "https://www.pexels.com/pt-br/download/video/3992584/",
    duration: 60,
    ownerId: 3,
    ownerName: "Maria Silva",
    ownerUrlImge: "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg",
    exparesAt: DateTime.now().add(const Duration(hours: 12)),
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Video(
    descrition: "Truques de mágica impressionantes 🎩✨",
    urlVideo: "https://www.pexels.com/pt-br/download/video/3760750/",
    duration: 25,
    ownerId: 4,
    ownerName: "João Pedro",
    ownerUrlImge: "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg",
    exparesAt: DateTime.now().add(const Duration(days: 3)),
    createdAt: DateTime.now().subtract(const Duration(hours: 10)),
  ),
  Video(
    descrition: "Tour pelo meu setup gamer 🎮",
    urlVideo: "https://www.pexels.com/pt-br/download/video/8128342/",
    duration: 55,
    ownerId: 5,
    ownerName: "Beatriz Lima",
    ownerUrlImge: "https://images.pexels.com/photos/103123/pexels-photo-103123.jpeg",
    exparesAt: DateTime.now().add(const Duration(days: 5)),
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
];

   VideosShortsRepository();
  
  @override
  Future<List<Video>> finalAll()  async{
     return  Future.value(videos); 
  }
}