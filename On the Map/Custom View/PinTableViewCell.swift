//
//  PinTableViewCell.swift
//  On the Map
//
//  Created by Zhazira Garipolla on 8/18/19.
//  Copyright © 2019 Zhazira Garipolla. All rights reserved.
//

import UIKit

class PinTableViewCell: UITableViewCell {
    
    lazy var pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon_pin")
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(pinImageView)
        pinImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pinImageView.widthAnchor.constraint(equalToConstant: 20),
            pinImageView.heightAnchor.constraint(equalToConstant: 30),
            pinImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            pinImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15)
            ])
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: pinImageView.trailingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        contentView.addSubview(detailLabel)
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            detailLabel.leadingAnchor.constraint(equalTo: pinImageView.trailingAnchor, constant: 15),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
