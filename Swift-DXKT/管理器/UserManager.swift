//
//  UserManager.swift
//  Baocase-Baby
//
//  Created by 宗森 on 2023/3/24.
//

/*
  静态方法是在类级别上定义的方法，它们可以直接通过类名来调用，而不需要创建类的实例。静态方法通常用于提供通用的实用函数，例如数学计算、字符串处理等。它们可以访问类的静态属性和方法，但不能访问实例属性和方法。

 单例是一种设计模式，它通过确保类只有一个实例来提供全局访问点。单例在应用程序中只有一个实例，可以在整个应用程序中共享数据和状态。单例通常用于管理全局状态或提供全局服务，例如应用程序设置、网络管理等。单例可以访问类的实例和静态属性和方法。

 因此，静态方法和单例都可以在类级别上提供功能和操作数据，但静态方法更适合提供通用的实用函数，而单例则更适合管理全局状态和提供全局服务。
  */

import Foundation
import SwiftyUserDefaults

/// 本地数据
extension DefaultsKeys {
    var username: DefaultsKey<String?> { .init("username") }
    var launchCount: DefaultsKey<Int> { .init("launchCount", defaultValue: 0) }
    var USERINFO: DefaultsKey<[String: Any]?> { .init("USERINFO", defaultValue: [:]) }
}

/// 用户管理器(可销毁)
class UserManager {
    private static var _sharedInstance = UserManager?(UserManager())

    class func SharedInstance() -> UserManager {
        guard let instance = _sharedInstance else {
            _sharedInstance = UserManager()
            return _sharedInstance!
        }
        return instance
    }

    // MARK: 用户全局数据

    var userPhoneNum: String = ""
    /// sessionID
    var ZSESSIONID: String = ""
    /// 动态key
    var AESKey1: String = ""
    /// 动态偏移量
    var AESKey2: String = ""

    private init() {}

    func doSomething() {
        print("Doing something...")
    }

    // MARK: 登录登出操作

    /// 配置登录数据
    func configLoginData(_ loginData: [String: Any]) {
        ZSESSIONID = loginData["session"] as? String ?? ""
        AESKey1 = loginData["key1"] as? String ?? ""
        AESKey2 = loginData["key2"] as? String ?? ""
        userPhoneNum = loginData["userPhoneNum"] as? String ?? ""
    }

    /// 退出登录
    class func loginOut() {
        print("进行退出登录操作")
        UserManager.SharedInstance().removeUserInfo()
        clearMainUser()
//        JhKeyWindow?.rootViewController = JhBaseNavigationController(rootViewController: LoginViewController())
    }

    /// 清空单例
    class func clearMainUser() {
        print("用户管理器已销毁")
        UserManager._sharedInstance = nil
    }

    // MARK: 操作本地数据

    /// 保存用户数据到本地
    func saveUserInfo(_ serInfo: [String: Any]) {
        
        Defaults[\.USERINFO] = serInfo
    }

    /// 是否有本地用户数据
    func haveLocalUserInfo() -> Bool {
        return Defaults.hasKey(\.USERINFO)
    }

    /// 获取本地用户数据
    func getLocalUserInfo() -> [String: Any] {
        return Defaults[\.USERINFO] ?? [:]
    }

    /// 删除本地用户数据
    func removeUserInfo() {
        ZSESSIONID = ""
        Defaults.remove(\.USERINFO)
    }
}
