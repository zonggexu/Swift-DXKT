//
//  SceneDelegate.swift
//  Swift-DXKT
//
//  Created by 宗森 on 2023/5/10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // MARK: 程序生命周期
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        /// 主窗口
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.windowScene = (scene as! UIWindowScene)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = LaunchViewController()
       
        
        print("应用程序生命周期： 场景将要连接会话")
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("应用程序生命周期： 场景已断开")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("应用程序生命周期： 不活跃到活跃状态")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("应用程序生命周期： 活跃到不活跃状态")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("应用程序生命周期： 应用将进入前台")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("应用程序生命周期： 应用已进入后台")
    }


}

