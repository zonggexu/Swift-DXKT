//
//  JhHttpRequest.swift
//  JhSwiftDemo
//
//  Created by Jh on 2022/2/10.
//  Moya 配置文件

import Foundation
import Moya
import Alamofire


// MARK: - Moya 配置文件

/**
 1、配置TargetType协议可以一次性处理的参数

 - Todo: 根据自己的需要更改，不能统一处理的移除下面的代码，并在APIManager中实现

 **/
public extension TargetType {
    
    /// 请求头
    var headers: [String: String]? {
        let tokenHeaders =
//        [
//            "Accept-Language": "zh-Hans-CN;q=1.0",
//            "Authorization": "Token e80eaa23af907b789de1521ed3135aa619c692df",
//            "Accept-Encoding": "br;q=1.0, gzip;q=0.9, deflate;q=0.8",
//            "User-Agent": "vapor 1.0",
//            "Content-Type": "application/json",
//            "Accept": "application/json; version=2"
//        ]

//        return nil
        
        [
            // 客户端的请求token
            "Authorization": getToken(),
            // 客户端的类型，客户端的软件环境
            "User-Agent":HTTPHeader.defaultUserAgent.value.replacingOccurrences(of: "测试", with: "ceshi"),
            // 客户端所能接收的数据类型
            "Accept":"application/json; version=2",
            // 客户端的语言环境
            "Accept-Language": "zh-Hans-CN;q=1.0",
            // 客户端支持的数据压缩格式
            "Accept-Encoding": "br;q=1.0, gzip;q=0.9, deflate;q=0.8",
        ]
        
        return tokenHeaders

    }

    private func getToken() -> String {
       
        return "Token "
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
}

/**
 2、公共参数

 - Todo: 配置公共参数，例如所有接口都需要传token，version，time等，就可以在这里统一处理

 - Note: 接口传参时可以覆盖公共参数。下面的代码只需要更改 【private var commonParams: [String: Any]?】

 **/
extension URLRequest {
    // TODO：处理公共参数 一
    private var commonParams: [String: Any]? {
        // 所有接口的公共参数添加在这里：
        
//        let CommonParam = [
//            "Content-Type": "application/x-www-form-urlencoded",
//            "systemType": "iOS",
//            "version": "1.0.0",
//            "token": getToken(),
//        ]
//        return CommonParam
        
        // 如果不需要传空
        return nil
    }

    private func getToken() -> String {
        return "1"
    }
}

// 下面的代码不更改
class RequestHandlingPlugin: PluginType {
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var mutateableRequest = request
        return mutateableRequest.appendCommonParams()
    }
}

// 下面的代码不更改
extension URLRequest {
    mutating func appendCommonParams() -> URLRequest {
        let request = try? encoded(parameters: commonParams, parameterEncoding: URLEncoding(destination: .queryString))
        assert(request != nil, "追加公共参数失败，请检查公共参数值")
        return request!
    }

    func encoded(parameters: [String: Any]?, parameterEncoding: ParameterEncoding) throws -> URLRequest {
        do {
            return try parameterEncoding.encode(self, with: parameters)
        } catch {
            throw MoyaError.parameterEncoding(error)
        }
    }
}
