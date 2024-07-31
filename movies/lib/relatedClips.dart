import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

class RelatedClips extends StatelessWidget {
  final Future<List<String>> movieClips;
  const RelatedClips({super.key, required this.movieClips});

  @override
  Widget build(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Related Clips',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          FutureBuilder<List<String>>(
            future: movieClips,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No clips found');
              } else {
                return SizedBox(
                  height: 200, // Adjust height as needed
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final videoKey = snapshot.data![index];
                      return Container(
                        width: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: PodVideoPlayer(
                          controller: PodPlayerController(
                            podPlayerConfig: const PodPlayerConfig(autoPlay: false),
                            playVideoFrom: PlayVideoFrom.youtube(videoKey),
                          )..initialise(),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      );
    }
  }

