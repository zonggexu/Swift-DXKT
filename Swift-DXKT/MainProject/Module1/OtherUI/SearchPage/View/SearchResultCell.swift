//
//  SearchResultCell.swift
//  GMChat
//
//  Created by GXT on 2019/6/28.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    @objc func showDataWithRowModel(_ rowModel: RowModel) {
        let resultModel: SearchResultModel = rowModel.dataModel as! SearchResultModel
        
        headerImageView.image = UIImage(named: "common_user_header_image_place")
        nameLab.text = resultModel.name
        contentLab.text = resultModel.otherInformation
    }
    
    func setupViews() {
        headerImageView.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.centerY.equalTo(self.contentView.snp.centerY).offset(0)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(headerImageView.snp.right).offset(10)
            make.right.equalTo(-5)
            make.top.equalTo(10)
        }
        
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(headerImageView.snp.right).offset(10)
            make.right.equalTo(-5)
            make.top.equalTo(nameLab.snp.bottom).offset(3)
        }
    }
    
    lazy var headerImageView: UIImageView = {
        let headerImageView = UIImageView(image: UIImage(named: "common_user_header_image_place"))
        headerImageView.layer.cornerRadius = 4
        headerImageView.layer.masksToBounds = true
        self.contentView.addSubview(headerImageView)
        return headerImageView
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel()
        nameLab.textColor = .black
        nameLab.font = JhFont(16)
        self.contentView.addSubview(nameLab)
        return nameLab
    }()
    
    lazy var contentLab: UILabel = {
        let contentLab = UILabel()
        contentLab.textColor = UIColorFromRGB("#999999")
        contentLab.font = JhFont(12)
        self.contentView.addSubview(contentLab)
        return contentLab
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
