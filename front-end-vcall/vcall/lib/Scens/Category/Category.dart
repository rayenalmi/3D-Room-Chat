import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:vcall/Models/Category_Model.dart';
import 'package:vcall/Scens/Category/Get_Categorie.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:vcall/Scens/Category/Get_Room.dart';

class Categorie extends StatefulWidget {
  Categorie({Key? key, this.animationController}) : super(key: key);
  final AnimationController? animationController;

  @override
  State<Categorie> createState() => _InviState();
}

class _InviState extends State<Categorie> with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  late bool? choose_category = false;
  late Category? the_chose_category = null;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FutureBuilder(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    left: 50,
                    right: 50,
                    top: AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top +
                        24,
                    bottom: 62 + MediaQuery.of(context).padding.bottom,
                  ),
                  itemCount: listViews.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    widget.animationController?.forward();
                    return wiget_cat_to_room();
                  },
                );
              }
            },
          ),
          getAppBarUI(),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    );
  }

  Widget wiget_cat_to_room() {
    if (choose_category == false) {
      return Get_Categories(
        animationController: widget.animationController,
        changeIndex: (Category c) {
          setState(() {
            this.the_chose_category = c;
            this.choose_category = !choose_category!;
          });
        },
      );
    } else {
      return Get_Rooms(
          animationController: widget.animationController,
          category: the_chose_category!);
    }
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: new BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: new BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),
                      )),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      change_bar(),
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget change_bar() {
    if (choose_category == false) {
      return bar_category();
    } else {
      return bar_room(the_chose_category!.cathegory.toString());
    }
  }

  Widget bar_category() {
    return Padding(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16 - 8.0 * topBarOpacity,
          bottom: 12 - 8.0 * topBarOpacity),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              // Constrains AutoSizeText to the width of the Row
              child: AutoSizeText(
            'Categories',
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveFlutter.of(context).scale(17),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Color(0xFF17262A),
            ),
          )),
        ],
      ),
    );
  }

  Widget bar_room(String cat) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16 - 8.0 * topBarOpacity,
          bottom: 12 - 8.0 * topBarOpacity),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                this.the_chose_category = null;
                this.choose_category = !choose_category!;
              });
            },
            child: Icon(Icons.home),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
              // Constrains AutoSizeText to the width of the Row
              child: AutoSizeText(
            'Meetings', // 'Meet of $cat',
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveFlutter.of(context).scale(17),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Color(0xFF17262A),
            ),
          )),
        ],
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  Widget getMainListViewUI() {
    return FutureBuilder(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            shrinkWrap: true,
            controller: scrollController,
            padding: EdgeInsets.only(
              left: 50,
              right: 50,
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            //scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }
}
