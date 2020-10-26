import 'package:dev_util/framework/base/base_state.dart';

/// * 如果是页面，继承 [PageState]
/// * 如果是view，继承 [WidgetState]
///
/// 此处扩展功能 应该只与 view相关
abstract class WidgetState extends BaseState with WidgetGenerator {
  ///刷新widget sate
  refreshState({Function task}) {
    if (mounted) {
      setState(task ?? () {});
    }
  }
}
