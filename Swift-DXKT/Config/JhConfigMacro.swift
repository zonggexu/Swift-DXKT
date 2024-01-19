//
//  JhConfigMacro.swift
//  Swift-DXKT
//
//  Created by 宗森 on 2021/12/27.
//
import UIKit

// MARK: - 定义常用的类库

// MARK: TODO 定义常用的类库信息,使用@_exported关键字，就可以全局引入对应的包

@_exported import HandyJSON
@_exported import JFPopup
@_exported import Kingfisher
@_exported import RxCocoa
@_exported import RxSwift
@_exported import RxGesture
@_exported import SnapKit
@_exported import SwiftyJSON
@_exported import Kingfisher

// MARK: - 应用信息

/// App 显示名称
let kAppDisplayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] ?? ""
/// App BundleName
let kAppName = Bundle.main.infoDictionary![kCFBundleNameKey as String] ?? ""
/// App BundleID
let kAppBundleID = Bundle.main.bundleIdentifier ?? ""
/// App 版本号
let kAppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] ?? ""
/// App BuildNumber
let kAppBuildNumber = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) ?? ""
/// App Language en
let kAPPLanguage = NSLocale.preferredLanguages[0]

let JhApplication = UIApplication.shared
let JhKeyWindow = getWindow()
let JhAppDelegate = UIApplication.shared.delegate
let JhUserDefaults = UserDefaults.standard
let JhNotificationCenter = NotificationCenter.default

// MARK: - 打印输出

/// 默认打印
public func SLog<T>(_ message: T, file: String = #file, lineNum: Int = #line) {
    #if DEBUG
    let date = Date()
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "HH:mm:ss.SSS"
    let strNowTime = timeFormatter.string(from: date) as String
    let fileName = (file as NSString).lastPathComponent
    
    print("⭐️ [\(strNowTime)] <\(fileName):(\(lineNum))> \(message)")
    #endif
}

/// 全部打印
public func SAllLog<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("\n*********** AllLog-satrt ************\n\n文件名称:\(fileName)\n方法名称:\(funcName)\n行数:\(lineNum)\n信息:\n\n\(message)\n\n*********** AllLog-end ************\n")
    #endif
}

// MARK: - Toast弹窗

/// 提示文字
public func YItoast(_ toastStr: String) {
    JFPopupView.popup.toast {
        [
            .hit(toastStr),
            .autoDismissDuration(.seconds(value: 1)),
            .position(.center)
        ]
    }
}

/// 展示HUD
public func ShowHUD() {
    JFPopupView.popup.loading()
}

/// 移除HUD
public func RemoveHUD() {
    JFPopupView.popup.hideLoading()
    
}
