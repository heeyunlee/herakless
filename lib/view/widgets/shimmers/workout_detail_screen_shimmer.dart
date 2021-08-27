import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:workout_player/styles/constants.dart';

class WorkoutDetailScreenShimmer extends StatelessWidget {
  const WorkoutDetailScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      color: kBackgroundColor,
      child: Shimmer.fromColors(
        baseColor: kCardColor,
        highlightColor: kCardColorLight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size.height * 2 / 5,
              width: size.width,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: 120,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
                  width: size.width,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
