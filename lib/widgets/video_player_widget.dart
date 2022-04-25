import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/application.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/comprehension_model.dart';
import 'package:pharmaaccess/models/quiz_question_model.dart';
import 'package:pharmaaccess/pages/game/comprehension_quiz_page.dart';
import 'package:pharmaaccess/services/quiz_service.dart';
import 'package:pharmaaccess/services/score_service.dart';
import 'package:pharmaaccess/services/video_watched_service.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/widgets/ShowSnackBar.dart';
import 'package:video_player/video_player.dart';

import '../theme.dart';

class VideoWidget extends StatefulWidget {
  final String? videoUrl;
  final bool isBrandVideo;
  final bool isLooping;
  final QuizService quizService = QuizService();
  final int? scoreCategoryId;
  final double? height;

  VideoWidget({
    Key? key,
    required this.videoUrl,
    this.isBrandVideo = false,
    this.isLooping = true,
    this.scoreCategoryId,
    this.height,
  }) : super(key: key);

  @override
  VideoWidgetState createState() => VideoWidgetState();
}

class VideoWidgetState extends State<VideoWidget> with RouteAware {
  ScrollController _scrollController = new ScrollController();
  bool isVideoWatchedSubmit = false;
  VideoPlayerController? _controller;
  StreamController<bool> videoStreamController =
      StreamController<bool>.broadcast();
  bool isVideoScoreUpdating = false, isGotoQuizPage = false;

  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(BRAND_VIDEO,
        param: {"isBrand_Video": widget.isBrandVideo});
    _controller = VideoPlayerController.network(
      widget.videoUrl!,
    );
    _controller!.setLooping(widget.isLooping);
    if (!_controller!.value.hasError) {
      _controller!.initialize().then((value) {
        _controller!.addListener(() async {
          if (_controller!.value.position == _controller!.value.duration) {
            if (widget.isBrandVideo && !isVideoScoreUpdating) {
              var videoWatchedService = VideoWatchedService();
              var isWatched = await getIsVideoWatched(videoWatchedService);
              if (!isWatched) {
                isVideoScoreUpdating = true;
                videoStreamController.add(true);
                //Go to the quiz page and at end of quiz page
                var videoWatchedService = VideoWatchedService();
                bool? isProcessed =
                    await videoWatchedService.uploadVideoWatchedInfo(
                  widget.videoUrl,
                  scoreCategoryId: widget.scoreCategoryId,
                );
                if (isProcessed! && !isVideoWatchedSubmit) {
                  isVideoWatchedSubmit = true;
                  await videoWatchedService.setVideoWatched(widget.videoUrl);
                  await ScoreService().refreshScore();
                }
              }
              if (!isGotoQuizPage) {
                await goToQuizPage();
              }
              isVideoScoreUpdating = false;
            }
          }
          videoStreamController.add(true);
        });
      }).onError((error, stackTrace) {});
    }
  }

  Future<bool> getIsVideoWatched(
      VideoWatchedService videoWatchedService) async {
    if (widget.videoUrl ==
            "https://content.pharmaaccess.com/static/pb/respimar_paed_promo.mp4" ||
        widget.videoUrl ==
            "https://content.pharmaaccess.com/static/pb/respimar_adult_promo.mp4") {
      return false;
    } else {
      return await videoWatchedService.isVideoWatched(widget.videoUrl);
    }
  }

  @override
  void dispose() {
    if (_controller!.value.isPlaying && !_controller!.value.hasError) {
      _controller!.pause();
    }
    _controller!.dispose();
    _controller = null;

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
  }

  @override
  void didPop() {
    // TODO: implement didPop
    super.didPop();
    if (_controller != null && !_controller!.value.hasError) {
      _controller!.pause();
    }
  }

  @override
  void didPushNext() {
    // TODO: implement didPushNext
    super.didPushNext();
    if (_controller != null && !_controller!.value.hasError) {
      _controller!.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: StreamBuilder<bool>(
              stream: videoStreamController.stream,
              builder: (_, snapshot) {
                if (isVideoScoreUpdating) {
                  return CircularProgressIndicator();
                }
                return GestureDetector(
                  onTap: () async {
                    if (!_controller!.value.hasError) {
                      if (_controller!.value.isPlaying) {
                        _controller!.pause();
                      } else {
                        if (_controller!.value.position ==
                            _controller!.value.duration) {
                          await _controller!.seekTo(Duration.zero);
                          _controller!.play();
                        } else {
                          _controller!.play();
                        }
                      }
                      videoStreamController.add(true);
                    }
                  },
                  child: widget.height != null
                      ? SizedBox(
                          height: 200,
                          child: videoStack(),
                        )
                      : AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: videoStack(),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget videoStack() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        VideoPlayer(_controller!),
        if (_controller!.value.caption.text.isNotEmpty) ...[
          ClosedCaption(text: _controller!.value.caption.text),
        ],
        _PlayPauseOverlay(
          controller: _controller,
          isBrandVideo: widget.isBrandVideo,
          videoUrl: widget.videoUrl,
        ),
        VideoProgressIndicator(
          _controller!,
          allowScrubbing: false,
        ),
      ],
    );
  }

  void showDialogHM() {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.8),
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                child: Text(
                  'Go To Quiz page! ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: primaryColor),
                ),
                onTap: () async {},
              )
            ],
          ),
        ),
      ),
    );
  }

  Future goToQuizPage() async {
    isGotoQuizPage = true;
    final QuizService quizService = QuizService();
    VideoComprehensionModel? comprehensionVideoId =
        await quizService.getComprehensionVideo(widget.videoUrl!);
    if (comprehensionVideoId != null) {
      List<QuizQuestion>? questions = await quizService
          .getComprehensionQuestions(comprehensionId: comprehensionVideoId.id);
      isGotoQuizPage = false;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ComprehensionQuizPage(
            comprehensionId: null,
            questions: questions,
            videoUrl: widget.videoUrl,
          ),
        ),
      );
    } else {
      showSnackBar(context, INTERNAL_SERVER_ERROR);
    }
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  final bool isBrandVideo;
  final String? videoUrl;

  const _PlayPauseOverlay({
    Key? key,
    this.controller,
    this.videoUrl,
    this.isBrandVideo = false,
  }) : super(key: key);
  final VideoPlayerController? controller;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: Duration(milliseconds: 50),
        reverseDuration: Duration(milliseconds: 200),
        child: controller!.value.isPlaying
            ? SizedBox.shrink()
            : Container(
                color: Colors.black26,
                child: Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 100.0,
                  ),
                ),
              ),
      );
}
