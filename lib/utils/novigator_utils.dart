import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_goya_app/routers/application.dart';
import 'package:flutter_goya_app/routers/routes.dart';
import 'package:flutter_goya_app/utils/logger.dart';

/// fluro 的路由跳转工具类
class NavigatorUtils {
  static push(BuildContext context, String path,
      {bool replace = false, bool clearStack = false}) {
    Application.router.navigateTo(context, path,
        replace: replace,//replace = true时，跳转关闭当前页面
        clearStack: clearStack,
        transition: TransitionType.native);
  }

  static pushResult(
      BuildContext context, String path, Function(Object) function,
      {bool replace = false, bool clearStack = false}) {
    Application.router
        .navigateTo(context, path,
            replace: replace,
            clearStack: clearStack,
            transition: TransitionType.native)
        .then((result) {
      // 页面返回result为null
      if (result == null) {
        return;
      }
      function(result);
    }).catchError((error) {
      LogHelper().logger.e("$error");
    });
  }

  /// 返回
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  /// 带参数返回
  static void goBackWithParams(BuildContext context, result) {
    Navigator.pop(context, result);
  }

  /// 跳到WebView页
  static goWebViewPage(BuildContext context, String title, String url) {
    //fluro 不支持传中文,需转换
    push(context,
        '${Routes.webViewPage}?title=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(url)}');
  }
}
