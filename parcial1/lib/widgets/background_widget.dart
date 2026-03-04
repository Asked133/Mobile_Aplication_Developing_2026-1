import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
	const BackgroundWidget({
		super.key,
		required this.child,
		this.imagePath = 'wallapeper.png',
		this.imageOpacity = 0.55,
	});

	final Widget child;
	final String imagePath;
	final double imageOpacity;

	@override
	Widget build(BuildContext context) {
		return Stack(
			children: [
				Positioned.fill(
					child: Opacity(
						opacity: imageOpacity,
						child: Image.asset(
							imagePath,
							fit: BoxFit.cover,
							errorBuilder: (context, error, stackTrace) {
								return Container(color: Colors.indigo.shade50);
							},
						),
					),
				),
				Positioned.fill(
					child: Container(color: Colors.black.withValues(alpha: 0.15)),
				),
				child,
			],
		);
	}
}
