//
//  CeShiController.swift
//  Swift-DXKT
//
//  Created by 宗森 on 2023/5/12.
//

import UIKit

class CeShiController: BaseViewController {
    let CSpublishSub = PublishSubject<(String,[String: String])>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeView()
    }

    func makeView() {
        let buttonOne = UIButton(type: .custom)
        buttonOne.backgroundColor = UIColor.blue
        buttonOne.setTitle("测试按钮", for: UIControl.State())
        view.addSubview(buttonOne)
        buttonOne.rx.tap
            .subscribe(onNext: {
                self.goBackVC()
            })
            .disposed(by: disposeBag)

        buttonOne.snp.makeConstraints { make in
            make.centerY.equalTo(self.view.snp.centerY)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(CommonWidth(100))
            make.width.equalTo(CommonWidth(100))
        }
    }

    func goBackVC() {
//        CSpublishSub.onNext(["a":"b"])
        CSpublishSub.onNext(("你好",["a":"b"]))
    }
}
