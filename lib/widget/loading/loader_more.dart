import 'package:flutter/material.dart';
import 'package:async/async.dart';

///a list view
///auto load more when reached the bottom
class AutoLoadMoreList<T> extends StatefulWidget {
  ///list total count
  final totalCount;

  ///initial list item
  final List<T> initialList;

  ///return the items loaded
  ///null indicator failed
  final Future<List<T>> Function(int loadedCount) loadMore;

  ///build list tile with item
  final Widget Function(BuildContext context, T item) builder;

  const AutoLoadMoreList(
      {Key key,
      @required this.loadMore,
      @required this.totalCount,
      @required this.initialList,
      @required this.builder})
      : super(key: key);

  @override
  _AutoLoadMoreListState<T> createState() => _AutoLoadMoreListState<T>();
}

class _AutoLoadMoreListState<T> extends State<AutoLoadMoreList> {
  ///true when more item available
  bool hasMore;

  ///true when load error occurred
  bool error = false;

  List<T> items = [];

  CancelableOperation<List> _autoLoadOperation;

  @override
  AutoLoadMoreList<T> get widget => super.widget;

  @override
  void initState() {
    super.initState();
    items.clear();
    items.addAll(widget.initialList ?? []);
    hasMore = items.length < widget.totalCount;
  }

  void _load() {
    if (hasMore && !error && _autoLoadOperation == null) {
      _autoLoadOperation =
          CancelableOperation<List<T>>.fromFuture(widget.loadMore(items.length))
            ..value.then((result) {
              if (result == null) {
                error = true;
              } else if (result.isEmpty) {
                //assume empty represent end of list
                hasMore = false;
              } else {
                items.addAll(result);
                hasMore = items.length < widget.totalCount;
              }
              setState(() {});
            }).whenComplete(() {
              _autoLoadOperation = null;
            }).catchError((e) {
              setState(() {
                error = true;
              });
            });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < 500) {
          _load();
        }
      },
      child: ListView.builder(
          itemCount: items.length + (hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= 0 && index < items.length) {
              return widget.builder(context, items[index]);
            } else if (index == items.length && hasMore) {
              if (!error) {
                return _ItemLoadMore();
              } else {
                return Container(
                  height: 56,
                  child: Center(
                    child: RaisedButton(
                      onPressed: () {
                        error = false;
                        _load();
                      },
                      child: Text("加载失败！点击重试"),
                      textColor: Theme.of(context).primaryTextTheme.body1.color,
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                );
              }
            }
            throw Exception("illegal state");
          }),
    );
  }
}

///suffix of a list, indicator that list is loading more items
class _ItemLoadMore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child: CircularProgressIndicator(),
            height: 16,
            width: 16,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
          ),
          Text("正在加载更多...")
        ],
      ),
    );
  }
}
