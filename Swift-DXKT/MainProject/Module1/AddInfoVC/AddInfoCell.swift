//
//  AddInfoCell.swift
//  Swift-DXKT
//
//  Created by 宗森 on 2023/5/11.
//

import UIKit

class AddInfoCell: UITableViewCell {
    var leftLab: UILabel!
    var peopleTextField : UITextField!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = .white
        
        leftLab = UILabel()
        leftLab.text = "asd"
        leftLab.textColor = .black
        leftLab.font = JhFont_14
        leftLab.numberOfLines = 0
        contentView.addSubview(leftLab)
        leftLab.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top).offset(CommonWidth(5))
            make.left.equalTo(self.contentView.snp.left).offset(CommonWidth(28))
        }
        
        /// people
        peopleTextField = UITextField()
        peopleTextField.keyboardType = .default
        peopleTextField.placeholder = "请输入信息"
        peopleTextField.font = JhFont_15
        peopleTextField.tintColor = JhGrayColor(51)
        peopleTextField.backgroundColor = JhGrayColor(246)
        peopleTextField.textColor = .black
        peopleTextField.clearButtonMode = .whileEditing
        peopleTextField.borderStyle = .roundedRect
        peopleTextField.returnKeyType = .done
        contentView.addSubview(peopleTextField)
        peopleTextField.snp.makeConstraints { make in
            make.top.equalTo(self.leftLab.snp.bottom).offset(CommonWidth(10))
            make.left.equalTo(self.leftLab.snp.left).offset(CommonWidth(0))
            make.width.equalTo(CommonWidth(300))
            make.height.equalTo(CommonWidth(44))
            
        }
    }
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) 尚未实现")
    }

}
