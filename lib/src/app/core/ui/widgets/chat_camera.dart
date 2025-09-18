import 'dart:developer';

import 'package:chat/src/app/data/dto/story_dto.dart';
import 'package:chat/src/app/domain/model/user.dart';
import 'package:chat/src/app/presentation/features/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ChatCamera extends StatefulWidget {
  final User my;
  const ChatCamera({super.key, required this.my});

  @override
  _ChatCameraState createState() => _ChatCameraState();
}

class _ChatCameraState extends State<ChatCamera> {
   late ImagePicker picker;
  bool openCamera = false;
  bool _isRecording = false;
  final List<StoryDto> mockStories = [
    StoryDto(
      id: 1,
      imageUrl:
          "https://i.pinimg.com/236x/3d/91/83/3d9183a5a1a40a482a719f8d144be4ac.jpg",
      name: "Alice",
      storys: [
        VideoDto(
          id: "vid-101",
          urlVideo: "https://example.com/video1.mp4",
          duration: 12.5,
          description: "Primeiro vídeo da Alice",
          ownerId: 1,
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          private: false,
        ),
        VideoDto(
          id: "vid-102",
          urlVideo: "https://example.com/video2.mp4",
          duration: 8.0,
          description: "Segundo vídeo da Alice",
          ownerId: 1,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          private: true,
        ),
      ],
    ),
    StoryDto(
      id: 2,
      imageUrl:
          "https://i.pinimg.com/236x/f1/32/ab/f132ab91c293a2efb5ddfa5d2f894f83.jpg",
      name: "Bob",
      storys: [
        VideoDto(
          id: "vid-201",
          urlVideo: "https://example.com/video3.mp4",
          duration: 15.2,
          description: "Vídeo do Bob curtindo música",
          ownerId: 2,
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
          private: false,
        ),
      ],
    ),
  ];

  //
  String? filePath;

  @override
  void initState() {
    super.initState();
       picker = ImagePicker();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }


 Future<void> _recordVideo() async {
    final file = await picker.pickVideo(source: ImageSource.camera);
    if (file == null) {
      log('File vazio');
      return;
    }
    final dir = await getTemporaryDirectory();
    log('File ${file.path} ${file.name}');
  }

 Future<void> _videoFromGalery() async {
    final file = await picker.pickVideo(source: ImageSource.gallery);

    if (file == null) {
      log('File vazio');
      return;
    }
    final dir = await getTemporaryDirectory();
    log('File ${file.path} ${file.name}');
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 350,
                collapsedHeight: 100,
              
                flexibleSpace: SizedBox(
                  height: constraints.maxHeight * .5,
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(32),
                    child: Expanded(child: Image.network(widget.my.urlImage ?? '',fit: BoxFit.cover,)),
                  ),
                ),
                actions: [
                  IconButton.filled(
                    onPressed: () {},
                    icon: Icon(Icons.edit, color: Colors.white),
                  ),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.only(
                    bottomRight: Radius.circular(32),
                    bottomLeft: Radius.circular(32),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(120),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusGeometry.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      gradient: LinearGradient(
                        begin: AlignmentGeometry.topCenter,
                        end: AlignmentGeometry.bottomCenter,
                        colors: [
                          Colors.grey.withAlpha(100),
                          Colors.black87.withAlpha(140),
                        ],
                      ),
                    ),
                    child: SizedBox(
                      height: 105,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 3,
                          children: [
                            Text(
                              widget.my.name,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              widget.my.email,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            //  RecentsSection(story: mockStories),
              SliverToBoxAdapter(child: Divider()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20,
                    children: [
                      Text('Add a new Story'),
                      Row(
                        spacing: 20,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CardMediaTypeWidget(
                            icon: Icons.camera_alt_outlined,
                            title: 'Camera',
                            onTap: () {
                               _recordVideo();
                            },
                          ),
                          CardMediaTypeWidget(
                            onTap: () {
                              _videoFromGalery();
                            },
                            icon: Icons.photo_size_select_actual,
                            title: 'Gallery',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CardMediaTypeWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  const CardMediaTypeWidget({super.key, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ,
      child: Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.all(16),
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Icon(icon), Text(title)],
          ),
        ),
      ),
    );
  }
}
