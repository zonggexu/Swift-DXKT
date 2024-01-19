//
//  UIViewController+JhExtension.swift
//  Swift-DXKT
//
//  Created by 宗森 on 2022/1/5.
//

import UIKit

extension UIViewController {
    class func Jh_stringFromClass(_ className: AnyClass) -> String {
        let str: String = NSStringFromClass(className)
        return str
    }
}


