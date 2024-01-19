//
//  Codable+Extension.swift
//  https://www.jianshu.com/p/a84dbb778476
//  Codable组合propertyWrapper实现编解码默认值
//  Created by 宗森 on 2023/6/30.
//  模型属性必须不能为nil 否则加可选值? 或者加默认值

import Foundation

/// 让需要有默认值的，遵循这个协议，提供默认值的能力，就是让模型必须有个静态属性
protocol DefaultValue {
    associatedtype DefValue: Codable, DefaultValue
    static var defaultValue: DefValue { get }
}
/// 属性包装
@propertyWrapper
struct Default<T: DefaultValue> {
    var wrappedValue: T.DefValue
    
}

extension Default: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.DefValue.self)) ?? T.defaultValue
    }
}

extension KeyedDecodingContainer {
    func decode<T>(
        _ type: Default<T>.Type,
        forKey key: Key
    ) throws -> Default<T> where T: DefaultValue {
        try decodeIfPresent(type, forKey: key) ?? Default(wrappedValue: T.defaultValue)
    }
}

// MARK: Dictionary默认值扩展
extension Dictionary: DefaultValue where Key: Codable, Value: DefaultValue & Codable {
    
    static var defaultValue: [Key: Value] { get { return [Key: Value]() } }
}

// MARK: Array默认值扩展
extension Array: DefaultValue where Element: DefaultValue & Codable {
    static var defaultValue: [Element] { get { return [] } }
}

// MARK: Float默认值扩展
extension Float: DefaultValue {
    static var defaultValue: Float = 0
}
// MARK: Double默认值扩展
extension Double: DefaultValue {
    static var defaultValue: Double = 0
}
// MARK: Bool默认值扩展
extension Bool: DefaultValue {
    static let defaultValue = false
    enum True: DefaultValue {
        static let defaultValue = true
    }
}

// MARK: String默认值扩展
extension String: DefaultValue {
    static let defaultValue = ""
}
extension String {
    enum Empty: DefaultValue {
        static let defaultValue = ""
    }
}

extension Int: DefaultValue {
    static let defaultValue = 0
    enum NegativeOne: DefaultValue {
        static let defaultValue = -1
    }
}

// MARK: 取别名
extension Default {
    //Bool
    typealias True = Default<Bool.True>
    typealias False = Default<Bool>
    
    //String
    typealias EmptyString = Default<String>
    
    /// Int
    typealias ZeroInt = Default<Int>
}

extension KeyedEncodingContainer {
    mutating func encode<T>(
        _ value: Default<T>,
        forKey key: Self.Key
    ) throws where T : Encodable & DefaultValue {
        try encodeIfPresent(value.wrappedValue, forKey: key)
    }
}

/// jsonData转model
public func jsonDataToModel<T: Codable>(_ modelType: T.Type, _ jsonData: Data) -> T? {
    do {
        let info = try JSONDecoder().decode(T.self, from: jsonData)
        return info
    } catch {
        //输出错误信息
        SLog("🆘 \(error)")
        YItoast("\(modelType) - json转模型失败")
        return nil
    }
}

/// model转json字符串
public func modelToJsonString(_ modelType: Codable) -> String? {
    do {
        let data = try JSONEncoder().encode(modelType)
        let string = String(data: data, encoding: .utf8)
        return string
    } catch {
        //输出错误信息
        SLog("🆘 \(error)")
        YItoast("\(modelType) - model转json字符串失败")
        return nil
    }
}

/// Data转为String?
public func dataToString(_ data:Data) -> String? {
    return String(data: data, encoding: .utf8)
    
}

/// String转为Data?
public func stringToData(_ string:String) -> Data? {
    return string.data(using: .utf8)
}
