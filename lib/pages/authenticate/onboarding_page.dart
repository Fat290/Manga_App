import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            child: PageView(
              onPageChanged: (int page) {
                setState(() {
                  currentIndex = page;
                });
              },
              controller: _pageController,
              children: const [
                createPage(
                  image: 'assets/image/onboard1.gif',
                ),
                createPage(
                  image: 'assets/image/onboard2.jpg',
                ),
                createPage(
                  image: 'assets/image/onboard3.gif',
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          left: 30,
          child: Row(
            children: _buildIndicator(),
          ),
        ),
        Positioned(
            bottom: 60,
            right: 30,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: currentIndex == 2
                  ? const BoxDecoration()
                  : const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFDA0037),
                    ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    if (currentIndex < 2) {
                      currentIndex++;
                      if (currentIndex < 3) {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      }
                    } else {
                      context.pushNamed("Login");
                    }
                  });
                },
                icon: currentIndex == 2
                    ? ElevatedButton(
                        onPressed: () {
                          context.pushNamed("Login");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDA0037),
                          minimumSize: const Size(150, 50),
                        ),
                        child: const Text(
                          "Let Stareted",
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    : const Icon(
                        Icons.arrow_forward_ios,
                        size: 30,
                        color: Colors.black,
                      ),
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(top: 70, left: 350.0),
          child: GestureDetector(
            onTap: () {
              context.pushNamed("Login");
            },
            child: const DefaultTextStyle(
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              ),
              child: Text('Skip'),
            ),
          ),
        ),
      ],
    );
  }

  //Extra widget

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10.0,
      width: isActive ? 20 : 8,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: const Color(0xFFDA0037),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

//create the indicator list
  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];

    for (int i = 0; i < 3; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }
    return indicators;
  }
}

class createPage extends StatelessWidget {
  final String image;

  const createPage({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(image),
        fit: BoxFit.cover,
      )),
    );
  }
}
