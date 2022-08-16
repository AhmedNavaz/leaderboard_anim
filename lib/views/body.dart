import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  late AnimationController rotateAnimationController;
  late Animation<double> rotateAnimation;

  late AnimationController shakeMovementAnimationController;
  late Animation<Offset> shakeMovementAnimation;

  late AnimationController shakeMovementPodiumAnimationController;
  late Animation<Offset> shakeMovementPodiumAnimation;

  late AnimationController tiltAnimationController;
  late Animation<double> tiltAnimation;

  late AnimationController tiltPodiumAnimationController;
  late Animation<double> tiltPodiumAnimation;

  late AnimationController fadeAnimationController;
  late Animation<double> fadeAnimation;

  late AnimationController crownAnimationController;
  late Animation<double> crownAnimation;

  late AnimationController badgeAnimationController;
  late Animation<Offset> badgeAnimation;

  late AnimationController badgeScoreAnimationController;
  late Animation<Offset> badgeScoreAnimation;

  TabController? tabController;
  ScrollController scrollController = ScrollController();

  bool expandToTop = false;
  bool showFloating = true;
  double scoreOpacity = 1;

  PageController pageController = PageController();

  List<double> cloud1 = [0.1, 0.25, 0.4];
  List<double> cloud2 = [0.05, 0.1, 0.05];
  List<double> glare = [45, 45, 45];
  List<double> crownVert = [0.185, 0.175, 0.185];
  List<double> crownHoriz = [0.39, 0.47, 0.55];
  List<double> crownAngle = [-30, 0, 30];

  List<String> rankImages = [
    'https://mymodernmet.com/wp/wp-content/uploads/archive/9YPBjDyXBmK6zd25PAM1_gesichtermix14.jpg',
    'https://media.allure.com/photos/57890b5c1d4bede12c872532/master/w_1600%2Cc_limit/celebrity-trends-2016-07-rihanna-face-reading.jpg',
    'https://media.allure.com/photos/57890b5ccedb40dd65c24206/master/w_1600%2Cc_limit/celebrity-trends-2016-07-gigi-hadid-face-reading.jpg',
    'https://i.pinimg.com/originals/20/5d/eb/205deb83336aaed867312c9187ab6c24.jpg',
    'https://cdn2.stylecraze.com/wp-content/uploads/2013/07/30-How-Do-Celebrities-With-Diamond-Face-Shape-Style-Their-Hair.jpg',
    'https://hips.hearstapps.com/cosmouk.cdnds.net/cm/14/30/53d2e91caee8f_-_or_2a3bfe4a12706427441711.jpg',
    'https://hips.hearstapps.com/cosmouk.cdnds.net/cm/14/30/53d2e918ad6d7_-_or_04060da4127064184527139.jpg',
    'https://mymodernmet.com/wp/wp-content/uploads/archive/AtqzUyFR9fqOwrgbLK9Z_gesichtermix17.jpg?width=721',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_QWO42BTaclcx_cFV5UYBAUDS5CLt5sLbhw&usqp=CAU'
  ];

  List<String> names = [
    'Rihanna',
    'Gigi Hadid',
    'Selena Gomez',
    'Kylie Jenner',
    'Khloe Kardashian',
    'Kendall Jenner',
    'Kourtney Kardashian',
    'Kylie Jenner',
    'Khloe Kardashian',
  ];

  List<String> scores = [
    '45',
    '23',
    '12',
    '10',
    '98',
    '87',
    '76',
    '65',
    '54',
  ];
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    scrollController.addListener(() {
      setState(() {
        expandToTop = scrollController.offset > 50;
        if (!showFloating) {
          showFloating = scrollController.offset < 50;
        }
      });
    });
    rotateAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    rotateAnimation = Tween<double>(begin: 0, end: 90 * pi / 180)
        .animate(rotateAnimationController);

    shakeMovementPodiumAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    shakeMovementPodiumAnimation =
        Tween(begin: Offset.zero, end: const Offset(-0.025, 0)).animate(
            CurvedAnimation(
                parent: shakeMovementPodiumAnimationController,
                curve: Curves.easeIn));

    shakeMovementAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    shakeMovementAnimation =
        Tween(begin: Offset.zero, end: const Offset(-0.25, 0)).animate(
            CurvedAnimation(
                parent: shakeMovementAnimationController,
                curve: Curves.easeIn));

    tiltAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    tiltAnimation = Tween<double>(begin: 0, end: -2.5 * pi / 180).animate(
        CurvedAnimation(parent: tiltAnimationController, curve: Curves.easeIn));

    tiltPodiumAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    tiltPodiumAnimation = Tween<double>(begin: 0, end: -5 * pi / 180).animate(
        CurvedAnimation(
            parent: tiltPodiumAnimationController, curve: Curves.easeIn));

    fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    fadeAnimation = Tween<double>(begin: 1, end: 0.2).animate(CurvedAnimation(
        parent: fadeAnimationController, curve: Curves.easeInOut));

    badgeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    badgeAnimation = Tween(begin: Offset.zero, end: const Offset(-0.15, 0))
        .animate(CurvedAnimation(
            parent: badgeAnimationController, curve: Curves.easeIn));

    badgeScoreAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    badgeScoreAnimation = Tween(begin: Offset.zero, end: const Offset(-1, 0))
        .animate(CurvedAnimation(
            parent: badgeAnimationController, curve: Curves.easeIn));
  }

  String trimName(String name) {
    if (name.split(' ').length > 1) {
      String temp = name.split(' ')[0];
      return '$temp ${name.split(' ')[1][0]}.';
    }
    return name;
  }

  @override
  void dispose() {
    tabController!.dispose();
    rotateAnimationController.dispose();
    fadeAnimationController.dispose();
    tiltAnimationController.dispose();
    shakeMovementAnimationController.dispose();
    badgeAnimationController.dispose();
    badgeScoreAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xff583bfc), Color(0xffff23ae)],
          ),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: expandToTop
                  ? 100
                  : MediaQuery.of(context).size.height * crownVert[currentPage],
              left: MediaQuery.of(context).size.width * crownHoriz[currentPage],
              child: Transform.rotate(
                angle: crownAngle[currentPage] * pi / 180,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: expandToTop ? 0 : 1,
                  child: Image.network(
                      'https://www.freeiconspng.com/thumbs/crown-png/black-crown-png-16.png',
                      width: 30,
                      height: 30,
                      color: Colors.white),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              top: MediaQuery.of(context).size.height * 0.05,
              left: MediaQuery.of(context).size.width * cloud1[currentPage],
              child: Image.network(
                'https://openclipart.org/image/800px/193560',
                color: Colors.white.withOpacity(0.4),
                width: 100,
                height: 100,
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              top: MediaQuery.of(context).size.height * 0.125,
              right: MediaQuery.of(context).size.width * cloud2[currentPage],
              child: Image.network(
                'https://openclipart.org/image/800px/193560',
                color: Colors.white.withOpacity(0.4),
                width: 100,
                height: 100,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.04,
              left: MediaQuery.of(context).size.width * 0.02,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: AnimatedBuilder(
                    animation: rotateAnimation,
                    child: Image.asset(
                      'assets/images/glare.png',
                      width: 350,
                      height: 350,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: rotateAnimation.value,
                        child: child,
                      );
                    }),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.15,
              left: MediaQuery.of(context).size.width * 0.25,
              child: AnimatedBuilder(
                animation: tiltPodiumAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                      angle: tiltPodiumAnimation.value, child: child);
                },
                child: SlideTransition(
                  position: shakeMovementPodiumAnimation,
                  child: Transform.rotate(
                    angle: 10 * pi / 180,
                    child: Image.asset(
                      'assets/images/podium_3.png',
                      width: 300,
                      height: 300,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.195,
              right: MediaQuery.of(context).size.width * 0.25,
              child: AnimatedBuilder(
                animation: tiltPodiumAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                      angle: tiltPodiumAnimation.value, child: child);
                },
                child: SlideTransition(
                  position: shakeMovementPodiumAnimation,
                  child: Transform.rotate(
                    angle: -10 * pi / 180,
                    child: Image.asset(
                      'assets/images/podium_2.png',
                      width: 300,
                      height: 300,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.25,
              right: MediaQuery.of(context).size.width * 0.075,
              child: AnimatedBuilder(
                animation: tiltPodiumAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                      angle: tiltPodiumAnimation.value, child: child);
                },
                child: SlideTransition(
                  position: shakeMovementPodiumAnimation,
                  child: Image.asset(
                    'assets/images/podium_1.png',
                    width: 300,
                    height: 300,
                  ),
                ),
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: expandToTop
                    ? SystemUiOverlayStyle.dark
                        .copyWith(statusBarColor: Colors.white)
                    : SystemUiOverlayStyle.light
                        .copyWith(statusBarColor: const Color(0xfff724b1)),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 100),
                      opacity: expandToTop ? 0 : 1,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        alignment: Alignment.topCenter,
                        height: expandToTop
                            ? 0
                            : MediaQuery.of(context).size.height * 0.6,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              TabBar(
                                controller: tabController,
                                indicator: const BoxDecoration(
                                    color: Colors.transparent),
                                isScrollable: true,
                                labelPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                unselectedLabelColor:
                                    Colors.white.withOpacity(0.9),
                                unselectedLabelStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                labelColor: Colors.white,
                                labelStyle: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                                tabs: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        pageController.animateToPage(0,
                                            duration: const Duration(
                                                milliseconds: 200),
                                            curve: Curves.easeIn);
                                      });
                                    },
                                    child: const Tab(text: 'Today'),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          pageController.animateToPage(1,
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              curve: Curves.easeIn);
                                        });
                                      },
                                      child: const Tab(text: 'Month')),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          pageController.animateToPage(2,
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              curve: Curves.easeIn);
                                        });
                                      },
                                      child: const Tab(text: 'All Time')),
                                ],
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1),
                              Row(
                                children: [
                                  Transform.translate(
                                    offset: Offset(
                                        5,
                                        MediaQuery.of(context).size.height *
                                            0.05),
                                    child: Column(
                                      children: [
                                        FadeTransition(
                                          opacity: fadeAnimation,
                                          child: AnimatedBuilder(
                                              animation: tiltAnimation,
                                              child: SlideTransition(
                                                position:
                                                    shakeMovementAnimation,
                                                child: Column(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 50,
                                                      backgroundColor: Colors
                                                          .white
                                                          .withOpacity(0.3),
                                                      child: CircleAvatar(
                                                        radius: 40,
                                                        backgroundColor:
                                                            Colors.white,
                                                        backgroundImage:
                                                            NetworkImage(rankImages[
                                                                currentPage == 0
                                                                    ? 0
                                                                    : currentPage *
                                                                        3]),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      trimName(names[
                                                          currentPage == 0
                                                              ? 0
                                                              : currentPage *
                                                                  3]),
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              builder: (context, child) {
                                                return Transform.rotate(
                                                  angle: tiltAnimation.value,
                                                  child: child,
                                                );
                                              }),
                                        ),
                                        const SizedBox(height: 20),
                                        SlideTransition(
                                          position: badgeAnimation,
                                          child: const CircleAvatar(
                                            radius: 14,
                                            backgroundColor: Colors.red,
                                            child: Icon(
                                              Icons.star,
                                              size: 14,
                                              color: Colors.yellow,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 7.5),
                                        SlideTransition(
                                          position: badgeScoreAnimation,
                                          child: AnimatedOpacity(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            opacity: scoreOpacity,
                                            onEnd: () {
                                              setState(() {
                                                scoreOpacity = 1;
                                              });
                                            },
                                            child: Text(
                                              scores[currentPage == 0
                                                  ? 0
                                                  : currentPage * 3],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: const Offset(3, -5),
                                    child: Column(
                                      children: [
                                        FadeTransition(
                                          opacity: fadeAnimation,
                                          child: AnimatedBuilder(
                                              animation: tiltAnimation,
                                              child: SlideTransition(
                                                position:
                                                    shakeMovementAnimation,
                                                child: Column(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 50,
                                                      backgroundColor: Colors
                                                          .white
                                                          .withOpacity(0.3),
                                                      child: CircleAvatar(
                                                        radius: 40,
                                                        backgroundColor:
                                                            Colors.white,
                                                        backgroundImage:
                                                            NetworkImage(
                                                          rankImages[
                                                              currentPage == 0
                                                                  ? 1
                                                                  : currentPage ==
                                                                          1
                                                                      ? 4
                                                                      : 7],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      trimName(
                                                          names[currentPage == 0
                                                              ? 1
                                                              : currentPage == 1
                                                                  ? 4
                                                                  : 7]),
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              builder: (context, child) {
                                                return Transform.rotate(
                                                  angle: tiltAnimation.value,
                                                  child: child,
                                                );
                                              }),
                                        ),
                                        const SizedBox(height: 20),
                                        SlideTransition(
                                          position: badgeAnimation,
                                          child: const CircleAvatar(
                                            radius: 16,
                                            backgroundColor: Colors.red,
                                            child: Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.yellow,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 7.5),
                                        SlideTransition(
                                          position: badgeScoreAnimation,
                                          child: AnimatedOpacity(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            opacity: scoreOpacity,
                                            onEnd: () {
                                              setState(() {
                                                scoreOpacity = 1;
                                              });
                                            },
                                            child: Text(
                                              scores[currentPage == 0
                                                  ? 1
                                                  : currentPage == 1
                                                      ? 4
                                                      : 7],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: Offset(
                                        -5,
                                        MediaQuery.of(context).size.height *
                                            0.1),
                                    child: Column(
                                      children: [
                                        FadeTransition(
                                          opacity: fadeAnimation,
                                          child: AnimatedBuilder(
                                              animation: tiltAnimation,
                                              child: SlideTransition(
                                                position:
                                                    shakeMovementAnimation,
                                                child: Column(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 50,
                                                      backgroundColor: Colors
                                                          .white
                                                          .withOpacity(0.3),
                                                      child: CircleAvatar(
                                                        radius: 40,
                                                        backgroundColor:
                                                            Colors.white,
                                                        backgroundImage:
                                                            NetworkImage(
                                                          rankImages[
                                                              currentPage == 0
                                                                  ? 2
                                                                  : currentPage ==
                                                                          1
                                                                      ? 5
                                                                      : 8],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      trimName(
                                                          names[currentPage == 0
                                                              ? 2
                                                              : currentPage == 1
                                                                  ? 5
                                                                  : 8]),
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              builder: (context, child) {
                                                return Transform.rotate(
                                                  angle: tiltAnimation.value,
                                                  child: child,
                                                );
                                              }),
                                        ),
                                        const SizedBox(height: 20),
                                        SlideTransition(
                                          position: badgeAnimation,
                                          child: const CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.red,
                                            child: Icon(
                                              Icons.star,
                                              size: 12,
                                              color: Colors.yellow,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 7.5),
                                        SlideTransition(
                                          position: badgeScoreAnimation,
                                          child: AnimatedOpacity(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            opacity: scoreOpacity,
                                            onEnd: () {
                                              setState(() {
                                                scoreOpacity = 1;
                                              });
                                            },
                                            child: Text(
                                              scores[currentPage == 0
                                                  ? 2
                                                  : currentPage == 1
                                                      ? 5
                                                      : 8],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        onNotification:
                            (OverscrollIndicatorNotification overscroll) {
                          overscroll.disallowIndicator();
                          return false;
                        },
                        child: PageView(
                          controller: pageController,
                          // ignore: avoid_types_as_parameter_names
                          onPageChanged: (num) {
                            if (num > currentPage) {
                              rotateAnimationController.forward(from: num * 0);
                            } else {
                              rotateAnimationController.reverse(
                                  from: num == 0 ? 90 : num * 90);
                            }
                            setState(() {
                              currentPage = num;
                              scoreOpacity = 0;
                            });
                            tabController!.animateTo(num);
                            shakeMovementAnimationController
                                .forward()
                                .then((value) {
                              shakeMovementAnimationController.reverse();
                            });
                            shakeMovementPodiumAnimationController
                                .forward()
                                .then((value) {
                              shakeMovementPodiumAnimationController.reverse();
                            });
                            tiltAnimationController.forward().then((value) {
                              tiltAnimationController.reverse();
                            });
                            tiltPodiumAnimationController
                                .forward()
                                .then((value) {
                              tiltPodiumAnimationController.reverse();
                            });
                            fadeAnimationController.forward().then((value) {
                              fadeAnimationController.reverse();
                            });
                            badgeAnimationController.forward().then((value) {
                              badgeAnimationController.reverse();
                            });
                          },
                          children: [
                            LeaderboardList(
                                expandToTop: expandToTop,
                                scrollController: scrollController,
                                pageIndex: 0),
                            LeaderboardList(
                                expandToTop: expandToTop,
                                scrollController: scrollController,
                                pageIndex: 1),
                            LeaderboardList(
                                expandToTop: expandToTop,
                                scrollController: scrollController,
                                pageIndex: 2),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: expandToTop
                    ? MediaQuery.of(context).size.height * 0.125
                    : 0,
                child: Material(
                  color: Colors.transparent,
                  child: ClipShadowPath(
                    clipper: SkewCutTop(),
                    shadow: Shadow(
                      blurRadius: 25,
                      color: expandToTop
                          ? Colors.black.withOpacity(0.25)
                          : Colors.transparent,
                    ),
                    child: Container(
                      color: Colors.white.withOpacity(0.9),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.125,
                      padding: const EdgeInsets.only(top: 20, left: 5),
                      alignment: Alignment.topCenter,
                      child: TabBar(
                        controller: tabController,
                        indicator:
                            const BoxDecoration(color: Colors.transparent),
                        isScrollable: true,
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        unselectedLabelColor: Colors.black.withOpacity(0.9),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        labelColor: Colors.black,
                        labelStyle: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: const [
                          Tab(text: 'Today'),
                          Tab(text: 'Month'),
                          Tab(text: 'All Time'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              bottom: MediaQuery.of(context).size.height * 0.34,
              right: showFloating ? 0 : -80,
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showFloating = false;
                    });
                    scrollController.animateTo(750,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut);
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          bottomLeft: Radius.circular(40)),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xffff23ae), Color(0xffd529c2)],
                      ),
                    ),
                    child: const Icon(
                      Icons.gps_fixed,
                      color: Colors.white,
                    ),
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

class LeaderboardList extends StatelessWidget {
  const LeaderboardList({
    Key? key,
    required this.expandToTop,
    required this.scrollController,
    required this.pageIndex,
  }) : super(key: key);

  final bool expandToTop;
  final ScrollController scrollController;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: expandToTop
          ? NoSkewCut()
          : pageIndex == 0
              ? SkewCut1()
              : pageIndex == 1
                  ? SkewCut2()
                  : SkewCut3(),
      child: Container(
        color: expandToTop ? Colors.white : Colors.white.withOpacity(0.9),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          controller: scrollController,
          itemCount: 100,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                  color: index == 16 ? Colors.grey[200] : Colors.transparent,
                  border: index == 16
                      ? const Border(
                          left: BorderSide(
                            color: Color(0xffff23ae),
                            width: 2.5,
                          ),
                        )
                      : null),
              child: Row(
                children: [
                  SizedBox(
                    width: 25,
                    child: Text(
                      '${index + 4}',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 17.5,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                        'https://media.allure.com/photos/57890b5c1d4bede12c872533/master/w_1600%2Cc_limit/celebrity-trends-2016-07-jennifer-lopez-face-reading.jpg'),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'The Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2.5),
                      Text('The Username',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[500])),
                    ],
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: index == 16
                        ? const Color(0xffff23ae)
                        : Colors.grey.withOpacity(0.1),
                    child: Icon(
                      Icons.star,
                      size: 12,
                      color: index == 16 ? Colors.white : Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, left: 10),
                    child: Text(
                      '67',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: index == 16
                              ? const Color(0xffff23ae)
                              : Colors.black),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class NoSkewCut extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(NoSkewCut oldClipper) => false;
}

class SkewCut1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 20);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(SkewCut1 oldClipper) => false;
}

class SkewCut2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 20);
    path.lineTo(0, 20);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(SkewCut2 oldClipper) => false;
}

class SkewCut3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(0, 20);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(SkewCut3 oldClipper) => false;
}

class SkewCutTop extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 30);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(SkewCutTop oldClipper) => false;
}

@immutable
class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  const ClipShadowPath({
    Key? key,
    required this.shadow,
    required this.clipper,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      key: UniqueKey(),
      painter: _ClipShadowShadowPainter(
        clipper: clipper,
        shadow: shadow,
      ),
      child: ClipPath(clipper: clipper, child: child),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
