import 'package:flutter/material.dart';

class CookTimeSlider extends StatefulWidget {
  final ValueChanged<double> onValueChanged;
  const CookTimeSlider({super.key, required this.onValueChanged});

  @override
  State<CookTimeSlider> createState() => _CookTimeSliderState();
}

class _CookTimeSliderState extends State<CookTimeSlider> {
  double _sliderValue = 180;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _formatSliderText(_sliderValue),
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
        ),
        Container(
          padding: EdgeInsets.zero,
          width: double.maxFinite,
          child: SliderTheme(
            data: SliderThemeData(
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              trackShape: CustomTrackShape(),
              trackHeight: 3,
            ),
            child: Slider(
              divisions: 300,
              min: 5.0,
              max: 180.0,
              value: _sliderValue,
              activeColor: Theme.of(context).colorScheme.error,
              onChanged: (double value) {
                setState(() {
                  _sliderValue = value;
                  widget.onValueChanged(value); // Notify parent of value change
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  String _formatSliderText(double value) {
    if (value < 60) {
      return 'Up to ${value.toInt()} minutes';
    } else if (value % 60 == 0) {
      return 'Up to ${(value / 60).toInt()} hour';
    } else {
      return 'Up to ${(value / 60).toInt()} hours ${(value % 60).toInt()} minutes';
    }
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
