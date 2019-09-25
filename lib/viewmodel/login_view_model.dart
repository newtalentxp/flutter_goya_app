import 'package:flutter/material.dart';
import 'package:flutter_goya_app/base/base.dart';
import 'package:flutter_goya_app/config/storage_manager.dart';
import 'package:flutter_goya_app/entity/user_entity.dart';
import 'package:flutter_goya_app/repository/wan_android_repository.dart';
import 'package:flutter_goya_app/viewmodel/user_view_model.dart';
import 'package:rxdart/rxdart.dart';

const String kLoginName = 'kLoginName';
const String kUser = 'kUser';

class LoginViewModel extends BaseViewModel<UserEntity> with ChangeNotifier {
  BehaviorSubject<UserEntity> _dataObservable = BehaviorSubject();

  Stream<UserEntity> get dataStream => _dataObservable.stream;

  UserEntity _user;

  UserEntity get user => _user;

  ///用于判断当前用户是否登录
  bool get hasUser => user != null;

  @override
  void dispose() {
    _dataObservable.close();
    super.dispose();
  }

  @override
  void doInit(BuildContext context) {
    // TODO: implement doInit
  }

  String getLoginName() {
    return StorageManager.sharedPreferences.getString(kLoginName);
  }

  //登录
  Future<bool> login(loginName, password) async {
    try {
      var user = await WanAndroidRepository.login(loginName, password);
      saveUser(user);
      StorageManager.sharedPreferences.setString(kLoginName, user.username);
      return true;
    } catch (e) {
      return false;
    }
  }

  //退出登录
  Future<bool> logout() async {
    if (!hasUser) {
      //防止递归
      return false;
    }
    try {
      await WanAndroidRepository.logout();
      clearUser();
      return true;
    } catch (e) {
      return false;
    }
  }

  ///保存用户数据
  saveUser(UserEntity user) {
    _user = user;
    notifyListeners();
    StorageManager.localStorage.setItem(kUser, user);
  }

  /// 清除持久化的用户数据
  clearUser() {
    _user = null;
    notifyListeners();
    StorageManager.localStorage.deleteItem(kUser);
  }
}
