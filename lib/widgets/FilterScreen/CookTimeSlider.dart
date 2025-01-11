import 'package:flutter/material.dart';

class CookTimeSlider extends StatefulWidget {
  const CookTimeSlider({super.key});

  @override
  State<CookTimeSlider> createState() => _CookTimeSliderState();
}

class _CookTimeSliderState extends State<CookTimeSlider> {
  double _sliderValue = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            _sliderValue < 60
                ? 'Up to ${_sliderValue.toInt()} minutes'
                : _sliderValue % 60 == 0
                    ? 'Up to ${(_sliderValue / 60).toInt()} hour'
                    : 'Up to ${(_sliderValue / 60).toInt()} hours ${(_sliderValue % 60).toInt()} minutes',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: Colors.grey, fontWeight: FontWeight.normal)),
        Container(
          // color: Colors.red,
          padding: EdgeInsets.zero, // Remove padding
          width: double.maxFinite, // Set the desired width here
          child: SliderTheme(
            data: SliderThemeData(
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              trackShape: CustomTrackShape(),
              trackHeight: 3,
            ),
            child: Slider(
              divisions: 300,
              min: 0.0,
              max: 300.0,
              value: _sliderValue,
              activeColor: Theme.of(context).colorScheme.error,
              onChanged: (dynamic value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 3;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
