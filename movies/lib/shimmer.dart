import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {

  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
      return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 80, // Match the height of the image
                    width: 100, // Match the width of the image
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16.0), // Space between image and text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8.0), // Space between title and rating
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 15.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
  }
}

class ShimmerImage extends StatelessWidget {
  const ShimmerImage({super.key});

  @override
  Widget build(BuildContext context) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 150, // Match the height of the image
            width: 100, // Match the width of the image
            color: Colors.white,
          ),
        );
  }
}

