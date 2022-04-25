import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmaaccess/components/timeline.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/GiftModel.dart';
import 'package:pharmaaccess/models/brand/brand_model.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/models/score_model.dart';
import 'package:pharmaaccess/pages/brand/brand_page.dart';
import 'package:pharmaaccess/pages/club/redeem_points_page.dart';
import 'package:pharmaaccess/pages/quiz/quiz_category_page.dart';
import 'package:pharmaaccess/pages/registered_main_screen.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/screen_utils/ScreenUtil.dart';
import 'package:pharmaaccess/services/brand_service.dart';
import 'package:pharmaaccess/services/score_service.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/util/PermissionUtil.dart';
import 'package:pharmaaccess/util/screen_shot.dart';
import 'package:pharmaaccess/widgets/ShowProgressDialog.dart';
import 'package:pharmaaccess/widgets/ShowSnackBar.dart';

import '../../main.dart';
import '../../theme.dart';
import 'promo_code_page.dart';
import 'respimar_earning_points_page.dart';

class RespimarClubLandingPage extends StatefulWidget {
  @override
  _RespimarClubLandingPageState createState() =>
      _RespimarClubLandingPageState();
}

class _RespimarClubLandingPageState extends State<RespimarClubLandingPage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();
  ScrollController _scrollControllerNested = new ScrollController();
  ScrollController _scrollControllerTab = new ScrollController();
  ScrollController _scrollControllerTabChild = new ScrollController();
  ScrollController _scrollControllerReward = new ScrollController();
  ScrollController _scrollControllerRewardChild = new ScrollController();
  TabController? _controller;
  var scoreService = ScoreService();
  GlobalKey _globalKey = GlobalKey();
  MyScreenUtil? myScreenUtil;
  BrandService brandService = BrandService();
  final TextEditingController description = TextEditingController();
  late Future<PartnerScoreModel?> getScore;
  StreamController<bool> refreshGift = StreamController<bool>.broadcast();
  StreamController<bool> refreshScore = StreamController<bool>.broadcast();

  @override
  void dispose() {
    refreshGift.close();
    refreshScore.close();
    super.dispose();
  }

  @override
  void initState() {
    callAPI();
    super.initState();
    _controller = new TabController(length: 3, vsync: this);

    firebaseAnalyticsEventCall(RESPIMAR_SCREEN,
        param: {"name": "RESPIMAR Screen"});
  }

  void buttonClicked(int? index) {
    if (index == 0) {
      //display invite friends page
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => PromoCodePage()));
      return;
    }
    if (index == 1) {
      //redeem points page
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => RedeemPointsPage()));
      return;
    }
    //Earning points page
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => RespimarEarningPointsPage()));
    return;
  }

  @override
  Widget build(BuildContext context) {
    myScreenUtil = getScreenUtilInstance(context);
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollControllerNested,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            welcomeHeader(),
            clubWidget(context),
            //clubFeature(),
            sliverPersistentTabBar(),
          ];
        },
        body: tabBarView(),
      ),
    );
  }

  Widget clubFeature() => SliverToBoxAdapter(
        child: Container(
          height: 78,
          color: Colors.white,
          padding: EdgeInsets.only(
            top: 0,
            left: 18,
            right: 18,
            bottom: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RCVerticalButton(
                index: 0,
                callback: buttonClicked,
                icon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: SvgPicture.asset('assets/images/invite_friends.svg',
                      width: 26),
                ),
                text: Text(
                  "Enter Promo",
                  style: TextStyle(
                    color: Color(0xFFCBCBC9),
                  ),
                ),
                color: Colors.white,
              ),
              RCVerticalButton(
                index: 1,
                callback: buttonClicked,
                icon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: SvgPicture.asset('assets/images/redeem_points.svg',
                      width: 26),
                ),
                text: Text(
                  "Redeem Points",
                  style: TextStyle(
                    color: Color(0xFFCBCBC9),
                  ),
                ),
                color: Colors.white,
              ),
              RCVerticalButton(
                index: 2,
                callback: buttonClicked,
                icon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: SvgPicture.asset('assets/images/earn_points.svg',
                      width: 26),
                ),
                text: Text(
                  "Earning MCP",
                  style: TextStyle(
                    color: Color(0xFFCBCBC9),
                  ),
                ),
                color: Colors.white,
              ),
            ],
          ),
        ),
      );

  Widget clubWidget(BuildContext context) => SliverToBoxAdapter(
        child: Container(
          height: 70,
          color: Colors.white,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: 130,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  //   child: Image.asset(
                  //     'assets/images/meeting.png',
                  //     width: 40,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 12,
                  // ),
                  Text(
                    "Respimar",
                    style: TextStyle(
                      color: Color(0xFF6F706F),
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "Club",
                    style: TextStyle(
                      color: Color(0xFF6F706F),
                      fontSize: 18,
                    ),
                  ),
                  // RCVerticalButton(
                  //   index: 2,
                  //   callback: (index) {},
                  //   icon:
                  //   text:
                  //   color: Colors.white,
                  // ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget welcomeHeader() => SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
            top: 20,
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                Text("Welcome to Respimar Club", style: styleBoldBodyText),
                Text("Your personal rewards redemption section in",
                    style: styleNormalBodyText),
                Text("Hola Medico", style: styleBlackHeadline2),
              ],
            ),
          ),
        ),
      );

  Widget tabBarView() => Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 16),
        child: Container(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.only(
            top: 10,
          ),
          child: TabBarView(
            controller: _controller,
            children: <Widget>[
              FutureBuilder<PartnerScoreModel?>(
                future: getScore,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    var points = scoreService.getPoints()!;
                    return tabWidget(points);
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasError) {
                    return apiError();
                  } else {
                    return apiLoadingWidget();
                  }
                },
              ),
              StreamBuilder<bool>(
                  initialData: false,
                  stream: refreshGift.stream,
                  builder: (context, snapshot) {
                    scoreService.refreshScore().then((value) {
                      refreshScore.add(true);
                    });
                    return FutureBuilder<GiftModel?>(
                      future: scoreService.getGifts(
                          isRefresh: snapshot.data != null && snapshot.data!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return rewardsTabWidget(snapshot.data!);
                        } else if ((snapshot.connectionState ==
                                    ConnectionState.done &&
                                !snapshot.hasData) ||
                            snapshot.hasError) {
                          return apiError();
                        } else {
                          return apiLoadingWidget();
                        }
                      },
                    );
                  }),
              Container(
                margin: EdgeInsets.all(18),
                padding: EdgeInsets.only(left: 12, right: 12, bottom: 60),
                decoration: softCardShadow,
                child: ListView(
                  controller: _scrollController,
                  children: [
                    Timeline(
                      indicatorColor: primaryColor,
                      children: <Widget>[
                        getItem(
                          "Respimar Adult Range Video",
                          "Watch Respimar video in the Brands Section and answer questions (50 MCPs each time with a limit of 200 MCPs per month)",
                          () {
                            callBrandDetail(35);
                          },
                        ),
                        getItem(
                          "Respimar Pediatric Video",
                          "Watch Respimar video in the Brands Section and answer questions (50 MCPs each time with a limit of 200 MCPs per month)",
                          () {
                            callBrandDetail(38);
                          },
                        ),
                        getItem(
                          "Socrates",
                          "Answer questions in Socrates (5 MCPs for each question with a limit of 100 MCPs per month)",
                          () {
                            goToSocrates();
                          },
                        ),
                      ],
                      // indicators: <Widget>[
                      //   primaryCircle(),
                      //   primaryCircle(),
                      //   primaryCircle(),
                      // ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Disclaimer: In line with its fair-user policy initiative, PharmaAccess reserves the right to adjust or modify the membership points in case of any inconsistencies are observed.",
                      style:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget getItem(String title, String description, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: stylePrimaryTextMedium),
          RichText(
            text: TextSpan(
              style: styleSmallBodyText, //children will inherit
              children: <TextSpan>[
                TextSpan(text: description),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sliverPersistentTabBar() => SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
          height: tabBar().preferredSize.height,
          child: Container(
            margin: EdgeInsets.only(
              top: 8,
            ),
            decoration: softCardShadow,
            child: tabBar(),
          ),
        ),
      );

  Widget apiError() => Center(child: Text("Can't fetch the score information"));

  Widget apiLoadingWidget() => Center(child: CircularProgressIndicator());

  Widget tabWidget(List<ScoreModel> points) => SingleChildScrollView(
        controller: _scrollControllerTab,
        child: Column(
          children: [
            ListView.builder(
              controller: _scrollControllerTabChild,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                horizontal: 18,
              ),
              itemCount: points.length,
              itemBuilder: (BuildContext context, int index) {
                var score = points[index];
                return InkWell(
                  onTap: () {
                    scoreItemTap(score);
                  },
                  child: RClubCategoryWidget(
                    score: score,
                    first:
                        Text(score.scoreCategory!, style: styleNormalBodyText),
                    second: Text(
                      score.score.toString().padLeft(3, '0'),
                      style: stylePrimaryTextMedium,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              child: Container(
                color: Colors.white,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Your current MCP', style: styleBoldSmallBodyText),
                    InkWell(
                      child: Text(
                        scoreService.getScoreT().toString().padLeft(4, '0'),
                        style: styleBlackHeadline1.copyWith(fontSize: 52),
                      ),
                      onTap: () async {
                        await scoreService.refreshScore();
                        //setState(() {});
                      },
                    ),
                    Text('1 point = 1 MCP (Medical Contribution Points)',
                        style: styleMutedTextMedium),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(
                    child: RepaintBoundary(
                      key: _globalKey,
                      child: Container(
                        width: 200,
                        height: 200,
                        child: Image.asset(
                          "assets/images/respimar_range.jpg",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  getShareButton(),
                ],
              ),
            )
          ],
        ),
      );

  Widget rewardsTabWidget(GiftModel? giftModel) {
    Size size = MediaQuery.of(context).size;
    double itemHeight = (size.height - kToolbarHeight) / 2.1;
    double itemWidth = size.width / 2;
    return SingleChildScrollView(
      controller: _scrollControllerReward,
      child: Column(
        children: [
          StreamBuilder<bool>(
              stream: refreshScore.stream,
              builder: (context, snapshot) {
                return mcpWidget();
              }),
          Padding(
            padding: const EdgeInsets.only(
              left: 18.0,
              right: 18.0,
              bottom: 35.0,
              top: 10,
            ),
            child: GridView.builder(
              controller: _scrollControllerRewardChild,
              padding: EdgeInsets.only(top: 0),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: giftModel!.gift!.length + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 15,
                childAspectRatio: itemWidth / itemHeight,
              ),
              itemBuilder: (
                context,
                index,
              ) {
                if (index == giftModel.gift!.length) {
                  return GestureDetector(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return descriptionDialog(context);
                        },
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          height: itemHeight * 0.65,
                          width: double.maxFinite,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Others",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 17.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Flexible(
                                  child: Text(
                                    "Please contact our Medical Sales Representative",
                                    style: TextStyle(
                                      color: Color(0xFFCBCBC9),
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Others",
                              style: TextStyle(
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () async {
                    int? totalScore = scoreService.getScoreT();
                    if (totalScore != null &&
                        giftModel.gift![index].points != null &&
                        totalScore >= giftModel.gift![index].points!) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Please Confirm"),
                            content: Text(
                                "Are you sure you want to redeem Product?"),
                            actions: [
                              FlatButton(
                                child: Text("No"),
                                onPressed: () {
                                  goBack(context);
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                    color: primaryColor,
                                  ),
                                ),
                                onPressed: () async {
                                  showProgressDialog(context);
                                  var response =
                                      await scoreService.redeemRequest(
                                          giftModel.gift![index].id!);
                                  String message = "";
                                  if (response != null) {
                                    refreshGift.add(true);
                                    message =
                                        "Thank you. Your request has been submitted and you will be contacted soon!";
                                  } else {
                                    message =
                                        "Error occurred while processing your request. Please try again.";
                                  }
                                  goBack(context);
                                  goBack(context);
                                  showSnackBar(context, message);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showSnackBar(context,
                          "You don't have enough score to redeem this.");
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        height: itemHeight * 0.65,
                        width: double.maxFinite,
                        child: CachedNetworkImage(
                          imageUrl: giftModel.gift![index].product_url!,
                          fit: BoxFit.fill,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/MedicalUpdate.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 2.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                giftModel.gift![index].points!.toString(),
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  giftModel.gift![index].name!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              Text(
                                "Points",
                                style: TextStyle(
                                  color: bodyTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void goBack(BuildContext context) => Navigator.of(context).pop();

  AnimatedContainer descriptionDialog(BuildContext context) {
    return AnimatedContainer(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 100),
      child: Center(
        child: Wrap(
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.all(20.0),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add Description",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Material(
                    child: TextField(
                      controller: description,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      cursorColor: Colors.amber,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.edit,
                          color: Colors.grey[200],
                        ),
                        hintText: 'Description',
                        hintStyle: TextStyle(
                          color: Colors.grey[200],
                        ),
                        border: inputBorder,
                        enabledBorder: inputBorder,
                        focusedBorder: focusedBorder,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: MaterialButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (description.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please Enter description"),
                            ),
                          );
                        } else {
                          showProgressDialog(context);
                          String message = "";
                          var response = await authService
                              .submitContactUs(description.text.trim());
                          if (response != null) {
                            message = "Request submitted successfully.";
                          } else {
                            message =
                                "Error occurred while processing your request. Please try again.";
                          }
                          description.clear();
                          showSnackBar(context, message);
                          goBack(context);
                          goBack(context);
                        }
                      },
                      color: primaryColor,
                      shape: StadiumBorder(),
                      child: Text(
                        "SUBMIT",
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .apply(
                              color: Colors.white,
                            )
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getShareButton() => GestureDetector(
        onTap: () async {
          if (await PermissionUtil.getStoragePermission(
            context: context,
            screenUtil: myScreenUtil,
          )) {
            String filePath = await saveScreenShot(_globalKey, 'respimar_club');
            shareOption(filePath, '');
          }
        },
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.share,
                color: Colors.black,
                size: 13,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "SHARE",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );

  TabBar tabBar() => TabBar(
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 4.0,
              color: primaryColor,
            ),
          ),
        ),
        controller: _controller,
        labelColor: primaryColor,
        labelStyle: TextStyle(fontSize: 16),
        unselectedLabelColor: Color(0xFFCBCBC9),
        tabs: [
          Tab(
            text: 'Points',
          ),
          Tab(text: 'Rewards'),
          Tab(
            text: 'Earning MCP',
          ),
        ],
      );

  Widget mcpWidget() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Your current MCP', style: styleBoldSmallBodyText),
          if (scoreService.getScoreT() == null) ...[
            SizedBox(
              height: 5,
            ),
            apiError(),
          ],
          if (scoreService.getScoreT() != null) ...[
            InkWell(
              child: Text(
                scoreService.getScoreT().toString().padLeft(4, '0'),
                style: styleBlackHeadline1.copyWith(fontSize: 40),
              ),
              onTap: () async {
                await scoreService.refreshScore();
                //setState(() {});
              },
            )
          ],
        ],
      );

  void scoreItemTap(ScoreModel score) async {
    if (score.path != null && score.path!.isNotEmpty) {
      List<String> pathList = score.path!.split('/');
      if (pathList.length > 2 && pathList[1] == 'brand') {
        await callBrandDetail(int.parse(pathList[2]));
      } else if (pathList[1] == 'socrates') {
        goToSocrates();
      } else if (pathList[1] == 'brands') {
        bottomNavigationController.jumpToPage(0);
      }
    }
  }

  void goToSocrates() async {
    await firebaseAnalyticsEventCall(SOCRATES_SELECTION_EVENT,
        param: {"name": "Quiz"});
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => QuizCategoryPage(),
      ),
    );
  }

  Future<void> callBrandDetail(int id) async {
    showProgressDialog(context);
    ProfileModel? profile = await authService.getProfile();
    BrandModel? brand;
    if (profile != null &&
        profile.countryName != null &&
        profile.countryName.isNotEmpty) {
      brand = await brandService.getBrand(id, profile.countryName);
    }
    hideDialog(context);
    if (brand != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BrandPage(brand: brand),
        ),
      );
    } else {
      showSnackBar(
        context,
        "Can't fetch the details.",
      );
    }
  }

  void callAPI() {
    getScore = scoreService.getScore();
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  SliverAppBarDelegate({
    required this.child,
    required this.height,
  });

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      child;

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class RCVerticalButton extends StatelessWidget {
  final Widget? icon;
  final Widget? text;
  final Color? color;
  final void Function(int? index)? callback;
  final int? index;

  RCVerticalButton(
      {Key? key, this.icon, this.text, this.color, this.callback, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          onPressed: () {
            callback!(index);
          },
          color: this.color,
          padding: EdgeInsets.all(10.0),
          child: Column(
            // Replace with a Row for horizontal icon + text
            children: [
              icon!,
              text!,
            ],
          ),
        ),
      ],
    );
  }
}

class RClubCategoryWidget extends StatelessWidget {
  //firstIcon: SvgPicture.asset('assets/images/icon_game.svg', width: 24),
  final ScoreModel? score;
  final Widget? first;
  final Widget? firstIcon;
  final Widget? second;
  final bool lessPadding;

  RClubCategoryWidget(
      {Key? key,
      this.first,
      this.second,
      this.firstIcon,
      this.lessPadding = true,
      this.score})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? icon;
    if (score!.iconType == "a") {
      icon = SvgPicture.asset(score!.iconUri!, width: 24);
    }
    if (score!.iconType == "u") {
      icon = SvgPicture.network(score!.iconUri!, width: 24);
    }
    if (score!.iconType == "m") {
      //TODO Hetvi change
      icon = Icon(
        Icons.access_alarm,
        size: 24,
        color: Color(0xFFD1D0D0),
      );
    }
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 4,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      height: 52,
      decoration: softCardShadow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              Padding(
                padding: this.lessPadding
                    ? const EdgeInsets.symmetric(horizontal: 8.0)
                    : const EdgeInsets.symmetric(vertical: 14, horizontal: 8.0),
                child: icon == null ? Container() : icon,
              ),
              first!,
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: primaryColor, width: 1),
              ),
            ),
            child: second,
          ),
        ],
      ),
    );
  }
}
