import 'package:alagy/core/helpers/extensions.dart';
import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final int maxRating;
  final Function(int rating)? onRatingSelected;

  const StarRating({super.key, this.maxRating = 5, this.onRatingSelected});

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  int _selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Star row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.maxRating, (index) {
            final starValue = index + 1;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRating = starValue;
                });
                widget.onRatingSelected?.call(_selectedRating);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Icon(
                  starValue <= _selectedRating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 40, // Larger stars
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        // Labels below first and last star
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.maxRating, (index) {
            return Expanded(
              child: Align(
                alignment: index == 0
                    ? Alignment.centerLeft
                    : index == widget.maxRating - 1
                        ? Alignment.centerRight
                        : Alignment.center,
                child: index == 0
                    ? Text(context.l10n.bad, style: TextStyle(color: Colors.red))
                    : index == widget.maxRating - 1
                        ? Text(context.l10n.good, style: TextStyle(color: Colors.green))
                        : const SizedBox.shrink(),
              ),
            );
          }),
        ),
      ],
    );
  }
}
