//
//  ReachabilityTool.swift
//
//
//  Created by 宗森 on 2021/12/28.
//  实时网络监测

import UIKit
import Alamofire
import Reachability

enum JhNetworkStatus {
    /// 未知网络
    case unknown
    /// 无网络
    case notReachable
    /// 手机网络
    case wwan
    // WIFI网络
    case ethernetOrWiFi
}

class JhReachabilityTool {
    
    static let shared = JhReachabilityTool()
    /// 网络状态
    static var isHaveNetWork: Bool = false
    static let reachability = try! Reachability()
    static let networkManager = NetworkReachabilityManager(host: "www.baidu.com")
    
    /// 监听网络变化 - ReachabilitySwift
    static func monitorNetworkStatus1(status: @escaping(JhNetworkStatus)->Void) {
        // 网络可用或切换网络类型时执行
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
    
                self.isHaveNetWork = true
                status(.ethernetOrWiFi)
            } else {
                
                self.isHaveNetWork = true
                status(.wwan)
            }

        }
        
        // 网络不可用时执行
        reachability.whenUnreachable = { reachability in
            SLog("无网络连接")
            status(.notReachable)
        }
        
        do {
            // 开始监听，停止监听调用reachability.stopNotifier()即可
            try reachability.startNotifier()
        } catch {
            SLog("Unable to start notifier")
        }
    }
    
    /// 监听网络变化 - Alamofire
    static func monitorNetworkStatus2(status: @escaping(JhNetworkStatus)->Void) {
        networkManager!.startListening(onUpdatePerforming: { status in
                switch status {
                case .notReachable:
                    SLog("暂时没有网络连接")
                case .unknown:
                    SLog("网络状态未知")
                case .reachable(.ethernetOrWiFi):
                    SLog("以太网或者wifi")
                case .reachable(.cellular):
                    SLog("蜂窝数据")
                }
            })
    }
    
}


