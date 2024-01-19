//
//  BookListHeaderView.swift
//  GMChat
//
//  Created by GXT on 2019/6/18.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class BookListHeaderView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        title = nil
        titleColor = UIColorFromRGB("#999999")
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    var title: String? {
        didSet {
            titleLab.text = title
        }
    }
    var titleColor: UIColor? {
        didSet {
            titleLab.textColor = titleColor
        }
    }
    
    func setupViews() {
        contentView.backgroundColor = JhGrayColor(246)
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.centerY.equalTo(self.contentView.snp.centerY).offset(0)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = JhGrayColor(246)
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(1)
        }
    }
    
    lazy var titleLab: UILabel = {
        let titleLab = UILabel()
        titleLab.font = JhFont(12)
        titleLab.textColor = UIColorFromRGB("#999999")
        self.contentView.addSubview(titleLab)
        return titleLab
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
