//
//  NSString+JhExtension.swift
//  Swift-DXKT
//
//  Created by 宗森 on 2021/12/29.
//

import UIKit


extension String {
    
    /// 判空
    public var Jh_isEmpty: Bool {
        let trimmedStr = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedStr.isEmpty
    }
    
    /// 一串字符在固定宽度下，正常显示所需要的高度
    func Jh_getStringHeight(_ width: CGFloat, _ font: CGFloat) -> CGFloat {
        let size = self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: font)], context: nil).size
        return size.height
    }
    
    /// 一串字符在一行中正常显示所需要的宽度
    func Jh_getStringWidth(_ font: CGFloat) -> CGFloat {
        let size = self.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: font)], context: nil).size
        return size.width
    }
    
    /// 字符串转换为类
    ///
    /// - Parameter className: 类名字符串
    /// - Returns: 类对象
    static func Jh_classFromString(_ className: String) -> UIViewController! {
        /// 获取命名空间
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String;
        /// 根据命名空间传来的字符串先转换成anyClass
        let cls: AnyClass = NSClassFromString(namespace + "." + className)!;
        // 在这里已经可以return了   返回类型:AnyClass!
        //return cls;
        /// 转换成 明确的类
        let vcClass = cls as! UIViewController.Type;
        /// 返回这个类的对象
        return vcClass.init();
    }
    
    /// 字典转json字符串
    func convertDictionaryToString(dict:[String:AnyObject]) -> String {
      var result:String = ""
      do {
        //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))
     
        if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
          result = JSONString
        }
     
      } catch {
        result = ""
      }
      return result
    }
    
    /// 数组转json字符串
    func convertArrayToString(arr:[AnyObject]) -> String {
      var result:String = ""
      do {
        let jsonData = try JSONSerialization.data(withJSONObject: arr, options: JSONSerialization.WritingOptions.init(rawValue: 0))
     
        if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
          result = JSONString
        }
     
      } catch {
        result = ""
      }
      return result
    }
    
    func toRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }
    
    static func systemTime() -> String {
        let date = Date.init(timeIntervalSinceNow: 0)
        let time = CLongLong(round(date.timeIntervalSince1970 * 1000))
        let timeString = "\(time)"
        return timeString
    }
    
    /// 获取名字的第一个字母
    func firCharactor() -> String {
        let pinyinString = self.pinyinString()
        // 将拼音首字母装换成大写
        let strPinYin = polyphoneStringHandle(nameString: self, pinyinString: pinyinString).uppercased()
        if strPinYin.count == 0 {return ""}
        // 截取大写首字母
        let firstString = String(strPinYin[..<strPinYin.index(strPinYin.startIndex, offsetBy:1)])//strPinYin.substring(to: strPinYin.index(strPinYin.startIndex, offsetBy:1))
        // 判断姓名首位是否为大写字母
        let regexA = "^[A-Z]$"
        let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
        return predA.evaluate(with: firstString) ? firstString : "#"
    }
    
    /// 转换为拼音
    func pinyinString() -> String {
        // 注意,这里一定要转换成可变字符串
        let mutableString = NSMutableString.init(string: self)
        // 将中文转换成带声调的拼音
        CFStringTransform(mutableString as CFMutableString, nil, kCFStringTransformToLatin, false)
        // 去掉声调(用此方法大大提高遍历的速度)
        let pinyinString = mutableString.folding(options: String.CompareOptions.diacriticInsensitive, locale: NSLocale.current)
        return pinyinString
    }
    
    /// 多音字处理
    func polyphoneStringHandle(nameString:String, pinyinString:String) -> String {
        if nameString.hasPrefix("长") {return "chang"}
        if nameString.hasPrefix("沈") {return "shen"}
        if nameString.hasPrefix("厦") {return "xia"}
        if nameString.hasPrefix("地") {return "di"}
        if nameString.hasPrefix("重") {return "chong"}
        return pinyinString;
    }
    
    /// 判断字符串中是否有中文
    func isIncludeChinese() -> Bool {
        for ch in self.unicodeScalars {
            if (0x4e00 < ch.value  && ch.value < 0x9fff) { return true } // 中文字符范围：0x4e00 ~ 0x9fff
        }
        return false
    }
    
    /// 手机号加密
    ///
    /// - Returns: 手机号加星
    func phoneNumReplaceWithStar() -> String {
        var replaceString = self
        if replaceString.count == 11 {
            replaceString = replaceString.replacingCharacters(in: replaceString.toRange(NSMakeRange(3, self.count - 7))!, with: "****")
        }
        return replaceString
    }
    


    
}
