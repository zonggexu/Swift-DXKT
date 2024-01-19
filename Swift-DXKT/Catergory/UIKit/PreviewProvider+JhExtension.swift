//
//  PreviewProvider+JhExtension.swift
//  Swift
//  UIkit预览 适配到ios13
//  Created by 宗森 on 2023/10/7.
//

import SwiftUI
import UIKit

// 创建一个SwiftUI的容器View，将UIViewControler包含在内
struct PreviewContainer<T: UIViewController>: UIViewControllerRepresentable {
    let viewController: T

    init(_ viewControllerBuilder: @escaping () -> T) {
        viewController = viewControllerBuilder()
    }

    // MARK: - UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> T {
        return viewController
    }

    func updateUIViewController(_ uiViewController: T, context: Context) {}
}
