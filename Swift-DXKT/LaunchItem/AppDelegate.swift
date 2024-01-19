//
//  AppDelegate.swift
//  Swift-DXKT
//
//  Created by 宗森 on 2023/5/10.
//


import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        SLog("程序开始运行 🤩")
        /// 统一管理第三方库初始化
        ThirdLibsManager.shared.setup()
        
        return true
    }
    
    // MARK: 场景生命周期

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("应用场景生命周期： 创建新的场景会话")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("应用场景生命周期： 已丢弃一个场景会话")
    }


}

