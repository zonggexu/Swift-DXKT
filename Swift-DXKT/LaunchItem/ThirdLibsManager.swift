//
//  ThirdLibsManager.swift
//  Swift-DXKT
//
//  Created by 宗森 on 2023/5/10.
//


import UIKit
import IQKeyboardManagerSwift
/// 统一管理第三方库
final class ThirdLibsManager: NSObject {
    static let shared = ThirdLibsManager()

    func setup() {
        /// 获取应用信息
        getAppInfo()
        /// 配置Toast样式
        makeToastStyle()
        /// 热重载
//        configHotInjection()
        
        IQKeyboardManager.shared.enable = true
    }

    func getAppInfo() {
        print("App 显示名称 :", kAppDisplayName)
        print("App BundleName :", kAppName)
        print("App BundleID :", kAppBundleID)
        print("App 版本号 :", kAppVersion)
        print("App BuildNumber :", kAppBuildNumber)
        print("App Language :", kAPPLanguage)
        print("设备型号 :", iOS_DEVICE_DEVICENAME)
    }

    func makeToastStyle() {
    }

//    func configHotInjection() {
//        #if DEBUG
//            do {
//                let injectionBundle = Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")
//                if let bundle = injectionBundle {
//                    try bundle.loadAndReturnError()
//                } else {
//                    debugPrint("热重载 注入失败,未能检测到 Injection")
//                }
//
//            } catch {
//                debugPrint("热重载 注入失败 \(error)")
//            }
//        #endif
//    }
}
