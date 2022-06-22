import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:vcall/Models/Category_Model.dart';

class Get_Categories extends StatefulWidget {
  Get_Categories({Key? key, this.animationController, this.changeIndex})
      : super(key: key);

  final AnimationController? animationController;
  final Function(Category cat)? changeIndex;

  @override
  State<Get_Categories> createState() => _Get_CategoriesState();
}

class _Get_CategoriesState extends State<Get_Categories> {
  Widget Card_Categorie(Category c) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      padding: EdgeInsets.only(
        left: 10.0,
        top: 16,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Color(0xff132137),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.65),
            spreadRadius: 8,
            blurRadius: 8,
          ),
        ],
      ),
      child: InkWell(
          onTap: () {
            setState(() {
              widget.changeIndex!(c);
            });
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(c.path_iamge.toString()),
                maxRadius: 30,
                minRadius: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text(c.cathegory.toString(),
                          style: TextStyle(
                            fontSize: ResponsiveFlutter.of(context).scale(14),
                            color: Color(0xFFFFFFFF),
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ],
                  ),
                ],
              )
            ],
          )),
    );
  }

  List<Category> all_category = [
    Category("Mecanics", "assets/img/mecanique.png"),
    Category("Coding", "assets/img/prog.png"),
    Category("Electricity", "assets/img/electrique.png"),
    Category("Industry", "assets/img/batiment.png"),
    Category("Public Speech", "assets/img/speech.png")
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        ListView.builder(
          itemCount: all_category.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 16),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Card_Categorie(all_category[index]),
                SizedBox(
                  height: 50,
                )
              ],
            );
          },
        ),
      ]),
    );
  }
}
