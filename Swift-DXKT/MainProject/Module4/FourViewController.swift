//
//  FourViewController.swift
//  Swift-DXKT
//
//  Created by 宗森 on 2021/12/27.
//

import UIKit
import CryptoKit
import SwiftUI

class FourViewController: BaseViewController {
    var buttonOne : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "我的"
        buttonOne = UIButton(type: .custom)
        buttonOne.backgroundColor = .systemPink
        buttonOne.setTitle("测试a", for: UIControl.State())
        view.addSubview(buttonOne)
        buttonOne.rx.tap
            .subscribe(onNext: {
                
                self.makeGrayImage()
            })
            .disposed(by: disposeBag)
        
        buttonOne.snp.makeConstraints { make in
            make.centerY.equalTo(self.view.snp.centerY)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(CommonWidth(100))
            make.width.equalTo(CommonWidth(100))
        }
        view.addSubview(headerImgView)
        headerImgView.snp.makeConstraints { make in
            make.bottom.equalTo(buttonOne.snp.top).offset( -30)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(CommonWidth(100))
            make.width.equalTo(CommonWidth(100))
        }
        
        if let infoDict = Bundle.main.infoDictionary {
            // App 版本
            if let version = infoDict["CFBundleVersion"] as? String {
                let certainVersion = "1.13.4"
                if version.compare(certainVersion, options: .numeric) == .orderedDescending {
                    print("\(version) is bigger")
                } else {
                    print("\(certainVersion) is bigger")
                }
            }
        }
        
        let isoString = "2023-10-18T15:03:24.266080+08:00"
        // 使用 ISO8601DateFormatter 解析日期字符串
        // 2023-10-18T07:15:22Z ISO8601时间
        // 2023-10-18T15:03:24.266080+08:00 RFC3339时间
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = isoFormatter.date(from: isoString) {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai") // 中国标准时间
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let formattedDateString = dateFormatter.string(from: date)
            print(formattedDateString)
        } else {
            print("Failed to parse date")
        }
        
    }
    
    lazy var headerImgView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "appicon"))
        imgView.layer.cornerRadius = 20
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    /// UIkit使用swiftui
    func makeGrayImage() {
        let vc = UIHostingController(rootView: AddBluetoothKey_V(callback:{ backStr in
            self.buttonOne.setTitle(backStr, for: .normal)
        } ))
//        present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

/// 新预览UIkit
#Preview {
    PreviewContainer {
        let controller = FourViewController()
        return controller
    }
}

/// 测试 预览UIkit
//struct ViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        PreviewContainer {
//            let controller = FourViewController()
//            return controller
//        }
//    }
//}


