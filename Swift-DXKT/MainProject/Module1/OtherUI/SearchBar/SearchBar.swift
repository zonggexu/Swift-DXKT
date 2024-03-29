//
//  SearchBar.swift
//  GMChat
//
//  Created by GXT on 2019/6/19.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

protocol SearchBarDelegate: NSObjectProtocol {
    func clickedTheSearchBar()
}

class SearchBar: UIView {
    
    weak var delegate: SearchBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    @objc func clickedSeacrhBar() {
        delegate?.clickedTheSearchBar()
    }
    
    func setupViews() {
        
        backgroundColor = JhGrayColor(246)

        let btn = UIButton(type: .custom)
        addSubview(btn)
        btn.setImage(UIImage(named: "common_search_bar_search_icon"), for: .normal)
        btn.setTitle(" 搜索", for: .normal)
        btn.titleLabel?.font = JhFont(12)
        btn.setTitleColor(UIColorFromRGB("#999999"), for: .normal)
        btn.addTarget(self, action: #selector(clickedSeacrhBar), for: .touchUpInside)
        btn.backgroundColor = .white
        btn.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(8)
            make.bottom.equalTo(-8)
        }
        btn.layer.cornerRadius = 4
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
