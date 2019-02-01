//
//  UserTableViewCell.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 11/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private func setupUI() {
        self.contentView.addSubviews(nameLabel)
        setupConstraints()
    }
    private func setupConstraints() {
        let constraints = [
        
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
  

}
