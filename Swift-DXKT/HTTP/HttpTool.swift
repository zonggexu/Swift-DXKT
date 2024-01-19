//
//  HttpTool.swift
//
//
//  Created by 宗森 on 2021/12/28.
//  网络请求工具类：Alamofire + Moya + SwiftyJSON

import Alamofire
import CryptoSwift
import Foundation
import Moya
import SwiftyJSON

public class HttpTool {
    // MARK: - 文件图片网络请求

    /// - Parameters:
    ///   - target: 请求API，TargetType里的枚举值
    ///   - success: 成功
    ///   - fail: 失败
    ///   - progressClosure: 进度
    public class func upLoadImage<T: TargetType>(_ target: T, success: @escaping ((JSON) -> Void), fail: ((Int?, String) -> Void)?, progressClosure: ((Float) -> Void)?) {
        let provider = MoyaProvider<T>(plugins: [
            RequestHandlingPlugin(),
        ])

        provider.request(target,
                         callbackQueue: DispatchQueue.main, progress: { progress in
                             // 进度更新
                             let percent = Float(progress.progress * 100)
                             SLog("上传进度：\(percent)%")
                             progressClosure!(percent)

                         }, completion: { result in

                             switch result {
                             case let .success(response):

                                 let responseObject = JSON(response.data)
                                 SLog((response.description) + "\n接收到的json实体 ---------> \(responseObject)")
                                 success(responseObject)

                             case let .failure(error):
                                 let statusCode = error.response?.statusCode ?? -9999
                                 let message = "网络连接出错，错误码：" + String(statusCode)
                                 SAllLog(message)
                                 fail?(statusCode, error.errorDescription ?? message)
                             }
                         })
    }

    // MARK: - 普通网络请求

    /// - Parameters:
    ///   - target: 请求API，TargetType里的枚举值
    ///   - success: 成功的回调
    ///   - error: 连接服务器成功但是数据获取失败
    ///   - failure: 连接服务器失败
    ///
    public class func request<T: TargetType>(_ target: T, success: @escaping ((Response, JSON) -> Void), failure: ((Int?, String) -> Void)?) {
        let provider = MoyaProvider<API>(requestClosure: requestClosure, plugins: [
            RequestHandlingPlugin(),
            networkPlugin,
        ], trackInflights: false)

        if !isNetwork() {
            failureHandle(failure: failure, stateCode: -7777, message: "网络似乎出现了问题")
            return
        }

        provider.request(target as! API) { result in
            /// 消除等待框
            RemoveHUD()
            switch result {
            case let .success(response):

                do {
                    // *********** 收到数据后处理 ***********

                    let responseObject = JSON(response.data)

                    SLog((response.description) + "\n接收到的json实体 ---------> \(responseObject)")

                    /// 对返回头进行处理 
                    getResponseHeaders(response: response)

                    /// 判断状态码
                    switch response.statusCode {
                    case 200, 201:
                        // 数据返回正确
                        // 原始data  三方JSON
                        success(response, responseObject)

                    case 401, 403:
                        // 请重新登录
                        failureHandle(failure: failure, stateCode: response.statusCode, message: "请重新登录")
                        alertLogin("请重新登录")
                        SLog("⚠️ 请重新登录\(response.statusCode)")
                    case 400:
                        // 数据返回错误
                        var errerMsg: String?
                        if let responseObjectMsg = responseObject["detail"].string {
                            errerMsg = responseObjectMsg
                        } else {
                            errerMsg = try? response.mapString()
                        }
                        failureHandle(failure: failure, stateCode: -6666, message: errerMsg ?? "请求失败 400")
                        SLog("⚠️ 请求失败 400")

                    case 500:

                        failureHandle(failure: failure, stateCode: response.statusCode, message: "服务器电力不足，请稍后再试")
                        SLog("⚠️ 服务器电力不足，请稍后再试")

                    default:

                        failureHandle(failure: failure, stateCode: response.statusCode, message: "获取数据错误\(response.statusCode)")
                        SLog("⚠️ 获取数据错误")
                    }
                }

            case let .failure(error):

                let statusCode = error.response?.statusCode ?? -9999
                let message = "网络连接出错，错误码：" + String(statusCode)
                SAllLog(message)
                failureHandle(failure: failure, stateCode: statusCode, message: error.errorDescription ?? message)
            }
        }

        // 错误处理 - 弹出错误信息
        func failureHandle(failure: ((Int?, String) -> Void)?, stateCode: Int?, message: String) {
            showLoading(message)
            failure?(stateCode, message)
        }

        // 登录弹窗 - 弹出是否需要登录的窗口
        func alertLogin(_ title: String?) {
            // TODO: 跳转到登录页的操作：
//            UserManager.loginOut()
        }

        // 信息弹框
        func showLoading(_ message: String) {
            YItoast(message)
        }

        // 基于Alamofire，判断网络是否连接，返回一个布尔值
        func isNetwork() -> Bool {
            let networkManager = NetworkReachabilityManager()
            return networkManager?.isReachable ?? true // 无返回就默认网络已连接
        }
        // TODO: 添加其他方法：

        /// 更改特能业务逻辑
        func getResponseHeaders(response: Response) {
//            if let backHeaders = response.response?.headers.dictionary {
//                SLog("返回数据的请求头内容 --->>> \n\(backHeaders)")
//            }

        }
    }

    // MARK: - 打印日志

    // 插件
    static let networkPlugin = NetworkActivityPlugin.init { changeType, _ in

        // targetType 是当前请求的基本信息
        switch changeType {
        case .began:
//            SLog("----------     网络请求开始    ----------\n")
            break

        case .ended:
            SLog("----------     网络请求结束     ----------\n")
        }
    }

    /// 网络请求的设置
    static let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            // 设置请求时长
            request.timeoutInterval = 30
            // 打印请求参数
            if let requestData = request.httpBody {
                SLog(
                    "\n网络请求头: \(request.allHTTPHeaderFields!)\n" +
                        "网络请求地址: \(request.url!)\n" +
                        "网络请求方式: \(request.httpMethod!) \n" +
                        "网络请求实际参数: \(JSON(request.httpBody!)) \n"
                )

            } else {
                SLog("\n网络请求头: \(request.allHTTPHeaderFields!)\n" + "网络请求地址: \(request.url!)\n" + "网络请求方式: \(request.httpMethod!)")
            }
            done(.success(request))
        } catch {
            done(.failure(MoyaError.underlying(error, nil)))
        }
    }

    // MARK: - 其他设置
    
    
}
