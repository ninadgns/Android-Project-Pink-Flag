import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../models/RecipeModel.dart';
import '../widgets/RecipeDirectionScreen/UpperBar.dart';

class RecipeDirectionScreen extends StatefulWidget {
  RecipeDirectionScreen({
    super.key,
    required this.recipe,
  });
  Recipe recipe;

  @override
  State<RecipeDirectionScreen> createState() => _RecipeDirectionScreenState();
}

class _RecipeDirectionScreenState extends State<RecipeDirectionScreen> {
  final List<Widget> _pages = [];
  final FlutterTts flutterTts = FlutterTts();
  String recipeText = '';
  double _currentPosition = 0;
  double _duration = 0;
  bool _isPlaying = false;
  int _currentWordIndex = 0;
  List<String> _words = [];
  int time = 1;
  final _pageController = PageController();
  int pageIndex = 0;

  void _onPageChanged() {
    setState(() {
      pageIndex = _pageController.page!.round();
      _updateTtsText();
    });
  }

  void _updateTtsText() {
    recipeText = widget.recipe.steps[pageIndex].description;
    _words = recipeText.split(' ');
    _duration = _words.length.toDouble();
  }

  @override
  void initState() {
    // recipeText

    // for (int i = 0; i < widget.recipe.steps.length; i++) {
    //   _pages.add(recipeBody(
    //       MediaQuery.of(context).size.width,
    //       MediaQuery.of(context).size.height,
    //       widget.recipe.stepIntervals[i],
    //       widget.recipe.steps[i],
    //       widget.recipe.titlePhoto));
    // }
    // recipeText = widget.recipe.steps[0];
    // _words = recipeText.split(' ');
    // _duration = _words.length.toDouble();
    // // _pageController
    super.initState();
    _initTts();
    _pageController.addListener(_onPageChanged);
    recipeText = widget.recipe.steps[pageIndex].description;
    _words = recipeText.split(' ');
    _duration = _words.length.toDouble();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (int i = 0; i < widget.recipe.steps.length; i++) {
      _pages.add(recipeBody(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
          widget.recipe.steps[i].time,
          widget.recipe.steps[i].description,
          widget.recipe.titlePhoto,
          i + 1));
    }
    // flutterTts.stop();
    _initTts();
    recipeText = widget.recipe.steps[pageIndex].description;
    _words = recipeText.split(' ');
    _duration = _words.length.toDouble();
    print(_words);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    // Set up word boundary callback
    flutterTts
        .setProgressHandler((String text, int start, int end, String word) {
      if (mounted) {
        setState(() {
          _currentWordIndex = _words.indexOf(word);
          if (_currentWordIndex != -1) {
            _currentPosition = _currentWordIndex.toDouble();
          }
        });
      }
    });
    flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _currentPosition = 0;
          _currentWordIndex = 0;
        });
      }
    });
  }

  Future<void> _speak([int? startIndex]) async {
    if (!_isPlaying) {
      String textToSpeak;
      if (startIndex != null) {
        textToSpeak = _words.sublist(startIndex).join(' ');
        _currentWordIndex = startIndex;
      } else {
        textToSpeak = recipeText;
        _currentWordIndex = 0;
      }

      await flutterTts.speak(textToSpeak);
      if (mounted) {
        setState(() {
          _isPlaying = true;
        });
      }
    }
  }

  Future<void> _pause() async {
    if (_isPlaying) {
      await flutterTts.pause();
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  Future<void> _stop() async {
    await flutterTts.stop();
    if (mounted) {
      setState(() {
        _isPlaying = false;
        _currentPosition = 0;
        _currentWordIndex = 0;
      });
    }
  }

  Timer? _timer;
  int _elapsed = 0;
  bool _hasStarted = false;
  bool _timerPaused = true;
  bool _hasEnded = false;

  void startTimer() {
    _timer?.cancel();
    _timer = null;
    if (_hasStarted) {
      return;
    }
    setState(() {
      _hasStarted = true;
      _timerPaused = false;
      _elapsed = 0;
    });
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_elapsed == time * 60) {
          setState(() {
            timer.cancel();
            // _timerPaused = true;
            // _hasStarted = false;
            // timer = null;
            _hasEnded = true;
          });
        } else if (!_timerPaused) {
          setState(
            () {
              _elapsed++;
            },
          );
        }
      },
    );
  }

  String _formatDuration(double position) {
    int totalSeconds =
        (position * 0.3).round(); // Assuming 0.3 seconds per word
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // pageIndex = _pageController.page!.round();
    recipeText = widget.recipe.steps[pageIndex].description;
    time = widget.recipe.steps[pageIndex].time;

    return Scaffold(
      body: Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Column(
              children: [
                UpperBar(height: height, time: time, name: widget.recipe.name),
                SizedBox(height: height * 0.03),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SleekCircularSlider(
                      appearance: CircularSliderAppearance(
                        customWidths: CustomSliderWidths(
                          trackWidth: 8,
                          progressBarWidth: 10,
                          handlerSize: 12,
                          shadowWidth: 10,
                        ),
                        customColors: CustomSliderColors(
                          trackColor: Colors.grey[300]!,
                          progressBarColor: Theme.of(context).colorScheme.error,
                          shadowColor: Colors.black.withOpacity(0.5),
                          shadowMaxOpacity: 0.08,
                          shadowStep: 5.0,
                          dotColor: Theme.of(context).colorScheme.error,
                        ),
                        startAngle: 270,
                        angleRange: 360,
                        size: width * 0.55,
                        animationEnabled: true,
                      ),
                      min: 0,
                      max: time.toDouble() * 60,
                      initialValue: _elapsed.toDouble(),
                      onChange: (double value) {
                        setState(() {
                          _elapsed = value.toInt();
                        });
                      },
                    ),
                    ClipOval(
                      child: Image.network(
                        widget.recipe.titlePhoto,
                        width: width * 0.45,
                        height: width * 0.45,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.01),
                Text(
                  '${_elapsed >= 3600 ? ('${(_elapsed ~/ 3600).toString().padLeft(2, '0')}:') : ''}${((_elapsed % 3600) ~/ 60).toString().padLeft(2, '0')}:${(_elapsed % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(height: height * 0.56),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: [
                    ..._pages,
                  ],
                  // key: PageStorageKey('recipe'),
                ),
              ),
            ],
          ),
          const Spacer(),
          Positioned(
            bottom: 0,
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    print('TextButton pressed');
                    setState(() {
                      if (_isPlaying) {
                        print('Pausing TTS');
                        _pause();
                      } else {
                        print('Speaking TTS');
                        _speak();
                      }
                    });
                  },
                  style: ButtonStyle(
                    shadowColor: WidgetStateProperty.all(Colors.black38),
                    elevation: WidgetStateProperty.all(3),
                    padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(
                          horizontal: width * 0.04, vertical: height * 0.01),
                    ),
                    backgroundColor: WidgetStateProperty.all(
                        _isPlaying ? Colors.black : Colors.white),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                        color: _isPlaying ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Hear the recipe',
                        style: TextStyle(
                            color: _isPlaying ? Colors.white : Colors.black),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.012),
                Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35.0),
                      topRight: Radius.circular(35.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous_rounded,
                                color: Colors.black, size: 30),
                            onPressed: () {
                              setState(() {
                                pageIndex = (_pageController.page!.round() - 1)
                                    .clamp(0, _pages.length - 1);

                                _pageController.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut);
                                resetTimer();
                                startTimer();
                                _hasStarted = false;

                                // pageIndex = _pageController.page!.round();
                              });
                              _updateTtsText();
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              _hasEnded
                                  ? Icons.refresh
                                  : !_timerPaused
                                      ? Icons.pause_circle_filled_rounded
                                      : Icons.play_circle_filled_rounded,
                              color: Colors.black,
                              size: 65,
                            ),
                            onPressed: () {
                              if (_hasEnded) {
                                resetTimer();
                                startTimer();
                              } else if (!_hasStarted) {
                                startTimer();
                              } else {
                                setState(() {
                                  _timerPaused = !_timerPaused;
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next_rounded,
                                color: Colors.black, size: 30),
                            onPressed: () {
                              setState(() {
                                pageIndex = (_pageController.page!.round() + 1)
                                    .clamp(0, _pages.length - 1);

                                _pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut);
                                resetTimer();
                                startTimer();
                                _hasStarted = false;
                              });
                              _updateTtsText();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void resetTimer() {
    setState(() {
      _hasEnded = false;
      _hasStarted = false;
      _elapsed = 0;
    });
  }

  Container recipeBody(double width, double height, int time, String text,
      String imageUrl, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Step $index',
              style: TextStyle(
                color: Colors.grey,
                fontSize: width * 0.04,
                fontWeight: FontWeight.bold,
              )),
          // SizedBox(height: height * 0.01),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // color: Colors.red,
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04, vertical: height * 0.015),
                height: height * 0.2,
                width: width * 0.92,
                child: SingleChildScrollView(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
            ],
          ),
        ],
      ),
    );
  }
}
