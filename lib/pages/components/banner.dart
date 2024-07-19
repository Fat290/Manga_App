import 'package:doan_cs3/pages/components/cached_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderP extends StatefulWidget {
  SliderP({Key? key}) : super(key: key);

  @override
  State<SliderP> createState() => _SliderPState();
}

class _SliderPState extends State<SliderP> {
  int activeIndex = 0;
  final controller = CarouselController();
  final urlImages = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTF2pBE7iGoDJ6RDZWWhNUB0XX8p_7hpIbgcA&s",
    'https://img.freepik.com/free-psd/horizontal-banner-template-sales-comic-style_23-2148954675.jpg?size=626&ext=jpg&ga=GA1.1.1141335507.1718323200&semt=ais_user',
    'https://img.freepik.com/free-psd/comic-style-party-horizontal-banner_23-2149558233.jpg?size=626&ext=jpg&ga=GA1.1.1141335507.1718323200&semt=ais_user',
    'https://mangaplanet.com/storage/ranking-banner/rk_65bcc50392c11/banner.webp',
    'https://static0.gamerantimages.com/wordpress/wp-content/uploads/2022/10/Collage-Maker-15-Oct-2022-0416-PM.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("Promotions",textAlign: TextAlign.start,style: TextStyle(fontSize: 18),),
            ),
            CarouselSlider.builder(
                carouselController: controller,
                itemCount: urlImages.length,
                itemBuilder: (context, index, realIndex) {
                  final urlImage = urlImages[index];
                  return buildImage(urlImage, index);
                },
                options: CarouselOptions(
                    height: 280,
                    viewportFraction: 1,
                    autoPlay: true,
                    enableInfiniteScroll: false,
                    autoPlayAnimationDuration: const Duration(seconds: 2),
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) =>
                        setState(() => activeIndex = index))),

            Center(child: buildIndicator())
          ],
        ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
    onDotClicked: animateToSlide,
    effect: ExpandingDotsEffect(dotWidth: 6, activeDotColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),dotHeight: 6,),
    activeIndex: activeIndex,
    count: urlImages.length,

  );

  void animateToSlide(int index) => controller.animateToPage(index);
}

Widget buildImage(String urlImage, int index) =>
    Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CachedImage(mangaThumb: urlImage,width: double.infinity,height:185,),
              Container(
                width: double.infinity,
                height:80,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)
                ),
               child: const Padding(
                 padding: EdgeInsets.all(12.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text("Dive in to these must-reads!",style: TextStyle(fontWeight: FontWeight.bold),),
                     Text("Unlock the entire for Free with ads!"),
                   ],
                 ),
               ),
              )
            ],
          ),
        )
    );