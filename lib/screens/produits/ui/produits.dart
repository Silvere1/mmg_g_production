import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/controllers/article_controller.dart';
import '/app/controllers/portable_controller.dart';
import '/res/assets_files.dart';
import '/screens/produits/ui/add_article.dart';
import '/screens/produits/ui/add_protable.dart';
import '/screens/produits/widgets/article_list.dart';
import '/screens/produits/widgets/portable_list.dart';

class Produits extends StatefulWidget {
  const Produits({Key? key}) : super(key: key);

  @override
  _ProduitsState createState() => _ProduitsState();
}

class _ProduitsState extends State<Produits> {
  PortableController portableController = PortableController.instance;
  ArticleController articleController = ArticleController.instance;
  final List<String> item = ["Téléphones", "Accessoires"];
  String tri = "Téléphones";
  final tel = "Téléphones";
  late ScrollController scrollController;
  bool dialVisible = true;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  SpeedDial buildFloatingButton() {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      visible: dialVisible,
      spacing: 10,
      children: [
        SpeedDialChild(
          child: SvgPicture.asset(MmgAssets.electronic, height: 24),
          backgroundColor: Colors.white,
          label: 'Accessoire',
          labelStyle: const TextStyle(fontSize: 18.0),
          onTap: () {
            Get.to(() => const AddArticle());
            setState(() {
              tri = item[1];
            });
          },
        ),
        SpeedDialChild(
            child: SvgPicture.asset(MmgAssets.phone, height: 24),
            backgroundColor: Colors.white,
            label: 'Téléphone',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              Get.to(() => const AddPortable());
              setState(() {
                tri = item[0];
              });
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  tri,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              PopupMenuButton(
                itemBuilder: (_) => item
                    .map((e) => PopupMenuItem(
                        child: Text(e),
                        onTap: () {
                          setState(() {
                            tri = e;
                          });
                        }))
                    .toList(),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                tri == tel
                    ? PortableList(portableController: portableController)
                    : ArticlesList(articleController: articleController),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: buildFloatingButton(),
    );
  }
}
