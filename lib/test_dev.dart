import 'package:flutter/material.dart';

class TestDevPage extends StatefulWidget {
  @override
  _TestDevPageState createState() => _TestDevPageState();
}

class _TestDevPageState extends State<TestDevPage>
    with SingleTickerProviderStateMixin {
  ScrollController _controller = ScrollController();
  TabController _tabController;
  var globalKeyOne = GlobalKey();
  var globalKeyTwo = GlobalKey();
  var globalKeyThree = GlobalKey();
  var oneY = 0.0;
  var twoY = 0.0;
  var threeY = 0.0;

  @override
  void initState() {
    super.initState();
    oneY = getY(globalKeyOne.currentContext);
    twoY = getY(globalKeyTwo.currentContext);
    threeY = getY(globalKeyThree.currentContext);
    _tabController = TabController(length: 3, vsync: this);
    _controller.addListener(() {
      var of = _controller.offset;
      if (of > threeY - oneY) {
        _tabController.animateTo(2);
      } else if (of > twoY - oneY) {
        _tabController.animateTo(1);
      } else {
        _tabController.animateTo(0);
      }
    });
  }

  /// getY
  double getY(BuildContext buildContext) {
    final RenderBox box = buildContext.findRenderObject();
    final topLeftPosition = box.localToGlobal(Offset.zero);
    return topLeftPosition.dy;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TabBar(
            onTap: (index) {
              switch (index) {
                case 0:
                  _controller.jumpTo(0);
                  _tabController.animateTo(0);
                  break;
                case 1:
                  _controller.jumpTo(twoY - oneY);
                  _tabController.animateTo(1);
                  break;
                case 2:
                  _controller.jumpTo(threeY - oneY);
                  _tabController.animateTo(2);
                  break;
              }
            },
            tabs: [
              Text('1'),
              Text('2'),
              Text('3'),
            ],
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return ListView(
      controller: _controller,
      children: [
        Container(
          key: globalKeyOne,
          height: 300,
          color: Colors.blue,
          child: Text("商品"),
        ),
        Container(
          key: globalKeyTwo,
          color: Colors.green,
          height: 700,
          child: Text("详情"),
        ),
        Container(
          key: globalKeyThree,
          color: Colors.orange,
          height: 1500,
          child: Text("评价"),
        )
      ],
    );
  }
}
