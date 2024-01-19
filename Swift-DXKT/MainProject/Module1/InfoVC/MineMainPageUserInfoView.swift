//
//  MineMainPageUserInfoView.swift
//  Swift-DXKT
//
//  Created by 宗森 on 2023/5/11.
//

import UIKit

class MineMainPageUserInfoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        nameLab.text = "User"
    }

    func setupViews() {
        backgroundColor = .white
        headerImageView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(35)
            make.size.equalTo(CGSize(width: 54, height: 54))
        }

        nameLab.snp.makeConstraints { make in
            make.left.equalTo(headerImageView.snp.right).offset(12)
            make.top.equalTo(headerImageView.snp.top).offset(3)
        }

        phoneNumLab.snp.makeConstraints { make in
            make.left.equalTo(headerImageView.snp.right).offset(12)
            make.top.equalTo(nameLab.snp.bottom).offset(11)
        }
        mailLab.snp.makeConstraints { make in
            make.left.equalTo(headerImageView.snp.right).offset(12)
            make.top.equalTo(phoneNumLab.snp.bottom).offset(11)
        }
        addressLab.snp.makeConstraints { make in
            make.left.equalTo(headerImageView.snp.right).offset(12)
            make.top.equalTo(mailLab.snp.bottom).offset(11)
        }
        textLab.snp.makeConstraints { make in
            make.left.equalTo(headerImageView.snp.right).offset(12)
            make.right.equalTo(self.snp.right).offset(-12)
            make.top.equalTo(addressLab.snp.bottom).offset(11)
        }
    }

    lazy var headerImageView: UIImageView = {
        let headerImageView = UIImageView(image: UIImage(named: "AppIcon"))
        headerImageView.layer.cornerRadius = 4
        headerImageView.layer.masksToBounds = true
        self.addSubview(headerImageView)
        return headerImageView
    }()

    lazy var nameLab: UILabel = {
        let nameLab = UILabel()
        nameLab.font = JhBoldFont(18)
        nameLab.textColor = .black
        self.addSubview(nameLab)
        return nameLab
    }()

    lazy var phoneNumLab: UILabel = {
        let phoneNumLab = UILabel()
        phoneNumLab.font = JhBoldFont(14)
        phoneNumLab.textColor = .black
        self.addSubview(phoneNumLab)
        return phoneNumLab
    }()
    
    lazy var mailLab: UILabel = {
        let mailLab = UILabel()
        mailLab.font = JhBoldFont(14)
        mailLab.textColor = .black
        self.addSubview(mailLab)
        return mailLab
    }()
    
    lazy var addressLab: UILabel = {
        let addressLab = UILabel()
        addressLab.font = JhBoldFont(14)
        addressLab.textColor = .black
        self.addSubview(addressLab)
        return addressLab
    }()
    
    lazy var textLab: UILabel = {
        let textLab = UILabel()
        textLab.font = JhBoldFont(14)
        textLab.textColor = .black
        textLab.numberOfLines = 0
        self.addSubview(textLab)
        return textLab
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
