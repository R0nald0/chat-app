import 'package:chat/src/app/core/ui/widgets/chat_loader.dart';
import 'package:chat/src/app/core/ui/widgets/contact_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/* _videoPlayerController.value.isInitialized &&
         _videoPlayerController.value.duration.inSeconds > 0
      ? (_videoPlayerController.value.position.inSeconds /
         _videoPlayerController.value.duration.inSeconds)
         .clamp(0.0, 1.0)
      : 0.0, */
class ChatVideoWidget extends StatefulWidget {
  final String urlImage;
  final String urlVideo;
  final String nameOwner;
  final String desciption;
  final double duration;
  final VoidCallback onFavorite;

  const ChatVideoWidget({
    super.key,
    required this.urlImage,
    required this.nameOwner,
    required this.desciption,
    required this.duration,
    required this.onFavorite,
    required this.urlVideo,
  });

  @override
  State<ChatVideoWidget> createState() => _ChatVideoWidgetState();
}

class _ChatVideoWidgetState extends State<ChatVideoWidget> {
  late VideoPlayerController _videoPlayerController;
  final ValueNotifier<double> _duration = ValueNotifier(0.0);

  Future<void> getDuration() async {}
  void _togglePlayPause() {
    setState(() {
      _videoPlayerController.value.isPlaying
          ? _videoPlayerController.pause()
          : _videoPlayerController.play();
    });

  }

  Future<void> initialize() async {
    await _videoPlayerController.initialize();
    setState(()  {
       _videoPlayerController.play();
       _videoPlayerController.setVolume(1.0);
       _videoPlayerController.setLooping(true);
     
    });
  }

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.urlVideo),
    );

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initialize();

      _videoPlayerController.addListener((){
       
       final VideoPlayerValue( :duration, :position) =
        _videoPlayerController.value;
         if (duration.inMilliseconds > 0) {
            final progress = position.inMilliseconds /duration.inMilliseconds;
            _duration.value = progress.clamp(0.0, 1.0);
         }
      });
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _duration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final VideoPlayerValue( :isInitialized, :isPlaying,:aspectRatio) = _videoPlayerController.value;
  
    return Scaffold(
     
      body: InkWell(
        onTap: () {
          _togglePlayPause();
        },
        child: _videoPlayerController.value.isInitialized
            ? Stack(
                children: [
                  VideoPlayer(_videoPlayerController),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        vertical: 60,
                        horizontal: 12,
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: _duration,
                        builder: (context, value, child) {
                          return LinearProgressIndicator(
                            value: _duration.value
                          );
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: AnimatedOpacity(
                      opacity: !isPlaying && isInitialized ? 1 : 0.0,
                      duration: Duration(milliseconds: 600),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: IconButton(
                                alignment: Alignment.center,
                                icon: Icon(Icons.play_arrow),
                                iconSize:
                                    MediaQuery.of(context).size.height * 0.1,
                                color: Colors.white,
                                onPressed: () {
                                  _togglePlayPause();
                                },
                              ),
                            ),
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black87.withAlpha(178),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(32),
                                topLeft: Radius.circular(32),
                              ),
                            ),
                            child: ContactInfoWidget(
                              title: widget.nameOwner,
                              imageUrl: widget.urlImage,
                              description: widget.desciption,
                              icon: Icon(Icons.favorite),
                              onTap: () => widget.onFavorite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : ChatLoader(),
      ),
    );
  }
}
