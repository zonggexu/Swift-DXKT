//
//  ZSWebSocket.swift
//  WebSocket
//
//  Created by 宗森 on 2021/12/28.
//

import Starscream
import UIKit

class ZSWebSocket: NSObject, WebSocketDelegate {
    static let sharedInstance = ZSWebSocket()

    /// socket示例
    var socket: WebSocket!
    /// 是否连接成功
    var isConnected = false
    private var retryInterval: TimeInterval = 5

    /// 连接服务器
    func connectSever() {
        // 你的URL网址如：ws://192.168.3.209:8080/shop
        var request = URLRequest(url: URL(string: SOCKET_URL)!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        // 自动返回pingpong
        socket.respondToPingWithPong = true
        connectSocket()
        DispatchQueue.main.asyncAfter(deadline: .now() + retryInterval) {
            if !self.isConnected {
                SLog(" ⚠️ SOCKET* 未连接成功")
            }
        }
    }

    func connectSocket() {
        socket.connect()
    }

    // 发送文字消息
    func sendBrandStr(brandID: String) {
        socket.write(string: brandID)
    }

    /// 断开连接
    func closeSocket() {
        socket.disconnect()
    }

    // MARK: - WebSocketDelegate

    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case let .connected(headers):
            isConnected = true
            SLog("SOCKET* 已连接: \(headers)")
        case let .disconnected(reason, code):
            isConnected = false
            SLog("SOCKET* 已断开: \(reason) with code: \(code)")
            DispatchQueue.main.asyncAfter(deadline: .now() + retryInterval) {
                if !self.isConnected {
                    SLog("SOCKET* 重连中")
                    self.connectSocket()
                }
            }
        case let .binary(data):
            SLog("SOCKET* 接收到的数据: \(data.count)")
        case let .text(string):
//            SLog("SOCKET* 收到的文本: \(string)")
            let jsonS = JSON(parseJSON: string)
            SLog("SOCKET* 收到的JSON: \(jsonS)")
            if let responseObjectMsg = jsonS["code"].string {
                if responseObjectMsg == "0" {
//                    let jsonDic = jsonS["data"][0].dictionaryObject
//                    ControllerManager.SharedInstance.socketVC.addMasage(dic: jsonDic ?? [:])
                }
            }

        case .ping:
            SLog("SOCKET* ping \(CFAbsoluteTimeGetCurrent())")
        case .pong:
            SLog("SOCKET* pong \(CFAbsoluteTimeGetCurrent())")
        case .viabilityChanged:
            // 可行性改变
            SLog("SOCKET* 连接状态改变 \(isConnected)")
        case .reconnectSuggested:
            SLog("SOCKET* 重新连接")
        case .cancelled:
            isConnected = false
            SLog("//************ SOCKET 已取消 *************//")
        case let .error(error):
            isConnected = false
            SLog("SOCKET* 错误: \(String(describing: error))")
            DispatchQueue.main.asyncAfter(deadline: .now() + retryInterval) {
                if !self.isConnected {
                    SLog("SOCKET* 重连中")
                    self.connectSocket()
                }
            }
        }
    }
}
