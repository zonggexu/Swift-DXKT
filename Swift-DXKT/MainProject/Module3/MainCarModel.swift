//
//
//
//
//  Created by 宗森 on 2023/06/13.
//  Copyright © 2023年 JSONConverter. All rights reserved.
//
import Foundation

struct MainCarModel: Codable, DefaultValue {
    @Default<Array> var cityList: [MainCarModelCityList] = .defaultValue
    @Default<String> var code: String = .defaultValue
    @Default<String> var name: String = .defaultValue

    static let defaultValue = MainCarModel()
}

struct MainCarModelCityList: Codable, DefaultValue {
    @Default<Array> var areaList: [MainCarModelCityListAreaList] = .defaultValue
    @Default<String> var code: String = .defaultValue
    @Default<String> var name: String = .defaultValue

    static let defaultValue = MainCarModelCityList()
}

struct MainCarModelCityListAreaList: Codable, DefaultValue {
    @Default<String> var code: String = .defaultValue
    @Default<String> var name: String = .defaultValue

    static let defaultValue = MainCarModelCityListAreaList()
}
