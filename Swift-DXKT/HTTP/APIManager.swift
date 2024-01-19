//
//  APIManager.swift
//
//
//  Created by 宗森 on 2021/12/28.
//  接口管理

import CryptoSwift
import Foundation
import Moya

/// 基础域名
let kBaseURL = HTTP_URL

// MARK: - --------------------------

// MARK: - 接口文件

/// 调用方法
var methodName: String = ""
/// 调用版本
var severVersion: String = "1.0"
/// 加密KEY
let KEY = "h8728hadh-2=aiy8"
/// 加密IV
let IV = "sijhr3y85y28aksb"

enum API {
    /// 未知接口
    case getGroupPageList(page: Int)
    /// 上传图片接口
    case ServiceTypeSendIamge(Data: Data)
    /// 多参接口...
    case ServiceTypeGetTnxWithPath(Path: String, Dic: [String: Any])

   
}

extension API: TargetType {
    // 0. 基础域名
    var baseURL: URL {
        return URL(string: kBaseURL)!
    }

    // 1. 接口相对路径
    var path: String {
        switch self {
        case .getGroupPageList:
            SLog("未知接口!")
            return "xxx"
        case .ServiceTypeSendIamge(Data: _):
            return "xxx"
        case .ServiceTypeGetTnxWithPath(Path: let Path, Dic: _):
            return Path

        
        }
    }

    // 2. 接口请求方式
    var method: Moya.Method {
        switch self {
        // get请求可加到case中
        case .getGroupPageList:
            return .get
        case .ServiceTypeSendIamge(Data: _):
            return .patch
      
        case .ServiceTypeGetTnxWithPath(Path: let Path, Dic: let Dic):
            return .post
        }
    }

    // MARK: - --------------------------

    // MARK: - 参数处理

    // 3. 任务参数
    var task: Task { // 可独立增添接口参数
        SLog("\n----------     网络请求开始    -----------\n")
        SLog("请求接口: \(path) \n接口版本: \(severVersion)")

        var commonParams: [String: Any] = [:]

        switch self {
        /// 图片上传特殊处理
        case let .ServiceTypeSendIamge(Data: data):
            let fromData = [MultipartFormData(provider: .data(data),
                                              name: "background",
                                              fileName: "fileName",
                                              mimeType: "image/jpeg")]
            return .uploadMultipart(fromData)
        /// 普通请求
        case let .getGroupPageList(page: page):
            commonParams = ["XXX": page]

        case .ServiceTypeGetTnxWithPath(Path: _, Dic: let Dic):
            commonParams = Dic
      
        }

        switch method {
        case .get:
            return .requestParameters(parameters: commonParams, encoding: URLEncoding.default)
        default:
            return .requestParameters(parameters: commonParams, encoding: JSONEncoding.default)
        }
    }
}
