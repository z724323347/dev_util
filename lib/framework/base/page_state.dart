import 'package:dev_util/framework/base/base_state.dart';
import 'package:dev_util/framework/config/router_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// * 如果是页面，继承 [PageState]
/// * 如果是view，继承 [WidgetState]
/// 确保你的页面名字在项目中唯一，
/// 否则一些页面跳转的结果可能非你预期
/// ensure your page's name is unique in project,
/// will cause unexpected in navigator action if not.
///
/// 此处扩展功能应该只与page相关
abstract class PageState extends BaseState with WidgetGenerator,RouteAware,_RouteHandler{

  double marginLeft = 0.0;
  double dragPosition = 0.0;
  bool slideOutActive = false;



  ///所有页面请务必使用此方法作为根布局
  ///切换状态栏 模式：light or dark
  ///应在根位置调用此方法
  ///needSlideOut是否支持右滑返回、如果整个项目不需要，可以配置默认值为false
  Widget switchStatusBar2Dark({bool isSetDark = true,@required Widget child,
    ///适配、
    EdgeInsets edgeInsets,bool needSlideOut = false}){
    if(! needSlideOut){
      //不含侧滑退出
      return getNormalPage(isSetDark: isSetDark,child: child,edgeInsets: edgeInsets,
          needSlideOut: needSlideOut);

    }else{
      //侧滑退出
      return getPageWithSlideOut(isSetDark: isSetDark,child: child,edgeInsets: edgeInsets,
          needSlideOut: needSlideOut);
    }

  }

  Widget getNormalPage({bool isSetDark = true,@required Widget child,
    ///适配、
    EdgeInsets edgeInsets,bool needSlideOut = false}){
    return AnnotatedRegion(
        value: isSetDark ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        child: Material(
          color: Colors.white,
          child: Padding(
            padding: edgeInsets??EdgeInsets.only(bottom: 0),
            child: child,
          ),
        )
    );
  }

  Widget getPageWithSlideOut({bool isSetDark = true,@required Widget child,
    ///适配、
    EdgeInsets edgeInsets,bool needSlideOut = false}){
    return AnnotatedRegion(
        value: isSetDark ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        child: Material(
          color: Colors.transparent,
          child: Padding(
            // padding: edgeInsets??EdgeInsets.only(bottom: ScreenUtil.getInstance().bottomBarHeight),
            padding: edgeInsets??EdgeInsets.only(bottom: 0),
            child: GestureDetector(
              onHorizontalDragStart: (dragStart){
                slideOutActive = dragStart.globalPosition.dx < (getScreenWidth() / 10);

              },
              onHorizontalDragUpdate: (dragDetails){
                if(!slideOutActive) return;
                marginLeft = dragDetails.globalPosition.dx;
                dragPosition = marginLeft;
                //if(marLeft > 250) return;
                if(marginLeft < getWidthPx(50)) marginLeft = 0;
                setState(() {

                });
              },
              onHorizontalDragEnd: (dragEnd){
                if(dragPosition > getScreenWidth()/5){
                  pop();
                }else{
                  marginLeft = 0.0;
                  setState(() {

                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(left: marginLeft),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: child,
                ),
              ),

            ),
          ),
        )
    );

  }

  /// 一般页面的通用APP BAR 具体根据项目需求调整
  Widget commonAppBar({Widget leftWidget,String title,List<Widget> rightWidget ,
    Color bgColor = Colors.white,@required double leftPadding,@required double rightPadding}){
    return Container(
      width: getWidthPx(750),
      height: getHeightPx(115),
      color: bgColor??Color.fromRGBO(241, 241, 241, 1),
      padding: EdgeInsets.only(bottom: getHeightPx(10),left: leftPadding,right: rightPadding),
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          Positioned(
            left: 0,
            child: leftWidget ?? Container(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Visibility(
              visible:  title != null,
              child: Text(
                "$title",
                style: TextStyle(fontSize: getSp(36),color: Colors.black,
                    decoration: TextDecoration.none),
              ),
            ),
          ),
          if(rightWidget != null)
            ...rightWidget,
        ],
      ),
    );
  }

  ///通用APP bar 统一后退键
  Widget buildAppBarLeft(){
    return GestureDetector(
      onTap: (){
        if(canPop()){
          pop();
        }else{
          ///增加需要的提示信息
        }

      },
      child: Container(
        color: Colors.white,
        width: getWidthPx(150),
        height: getHeightPx(90),
        alignment: Alignment.bottomLeft,
        child: Icon(Icons.arrow_back_ios),
        // child: Image.asset(ImageHelper.wrapAssetsIcon("icon_back_black"),width: getWidthPx(17),height: getHeightPx(32),),
      ),
    );
  }

  //////////////////////////////////////////////////////
  ///页面出/入 监测
  //////////////////////////////////////////////////////
  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    handleDidPush();
    super.didPush();
  }

  @override
  void didPop() {
    handleDidPop();
    super.didPop();
  }

  @override
  void didPopNext() {
    handleDidPopNext();
    super.didPopNext();
  }

  @override
  void didPushNext() {
    handleDidPushNext();
    super.didPushNext();
  }

}

/// route aware's util
/// you can do something in this
/// e.g. create recordList at [_RouteHandler] and record something
mixin _RouteHandler on BaseState implements HandleRouteNavigate{
  @override
  void handleDidPop() {
    debugPrint("已经pop的页面 ${this.runtimeType}");
  }
  @override
  void handleDidPush() {
    debugPrint("push后,显示的页面 ${this.runtimeType}");
  }

  @override
  void handleDidPopNext() {
    debugPrint("pop后，将要显示的页面 ${this.runtimeType}");
  }
  @override
  void handleDidPushNext() {
    debugPrint("push后，被遮挡的页面 ${this.runtimeType}");
  }
}

abstract class HandleRouteNavigate{
  void handleDidPush();
  void handleDidPop();
  void handleDidPopNext();
  void handleDidPushNext();

}

