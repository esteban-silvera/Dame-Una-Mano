import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageCarousel extends StatelessWidget {
  final List<String> imageAssetPaths;

  const ImageCarousel({Key? key, required this.imageAssetPaths})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 120,
        aspectRatio: 16 / 9,
        viewportFraction: 0.6,
        initialPage: 0,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 2),
        autoPlayAnimationDuration: const Duration(milliseconds: 400),
        pauseAutoPlayOnTouch: true,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {},
      ),
      items: imageAssetPaths.map((assetPath) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
