//
//  testViewModel.swift
//  Swift-DXKT
//
//  Created by 宗森 on 2023/7/4.
//

import RxSwift
import RxCocoa
import Foundation

class testViewModel {
    let text = BehaviorSubject<String>(value: "asdasd")
    
    init() {
        text.onNext("你射什么名")
    }
    
    func changeText() {
        text.onNext("你好")
    }
}
