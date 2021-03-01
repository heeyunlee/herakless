import 'package:flutter/material.dart';
import 'package:workout_player/models/enum_values.dart';

import '../../../../constants.dart';

typedef DoubleCallback(double rating);

class NewRoutineDifficultyAndMoreScreen extends StatefulWidget {
  final DoubleCallback ratingCallback;

  const NewRoutineDifficultyAndMoreScreen({Key key, this.ratingCallback})
      : super(key: key);

  @override
  _NewRoutineDifficultyAndMoreScreenState createState() =>
      _NewRoutineDifficultyAndMoreScreenState();
}

class _NewRoutineDifficultyAndMoreScreenState
    extends State<NewRoutineDifficultyAndMoreScreen> {
  double _rating;
  String _ratingLabel;

  @override
  void initState() {
    // TODO: implement initState
    _rating = 2;
    _ratingLabel = Difficulty.values[_rating.toInt()].label;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Difficulty: $_ratingLabel',
                style: Headline6Bold,
              ),
            ),
            Card(
              color: CardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Slider(
                activeColor: PrimaryColor,
                inactiveColor: PrimaryColor.withOpacity(0.2),
                value: _rating,
                onChanged: (newRating) {
                  setState(() {
                    _rating = newRating;
                    _ratingLabel = Difficulty.values[_rating.toInt()].label;
                    widget.ratingCallback(_rating);
                  });
                },
                label: '$_ratingLabel',
                min: 0,
                max: 4,
                divisions: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
