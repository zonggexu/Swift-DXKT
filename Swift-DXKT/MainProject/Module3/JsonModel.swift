//
//
//
//
//  Created by 宗森 on 2023/06/13.
//  Copyright © 2023年 JSONConverter. All rights reserved.
//
import Foundation

struct JsonModel: Codable {
    var 安庆市: String?
    var 巴音郭楞蒙古自治州: String?
    var 郴州市: String?
    var 河源市: String?
    var 金华市: String?
    var 喀什地区: String?
    var 娄底市: String?
    var 南通市: String?
    var 曲靖市: String?
    var 遂宁市: String?
    var 泰州市: String?
    var 铁岭市: String?
    var 邢台市: String?
    var 云林县: String?
    @Default<String> var code: String = .defaultValue
    var testStr: String {
        guard 河源市 != nil else {
            return "失败"
        }
        return 河源市! + "你好"
    }
}
