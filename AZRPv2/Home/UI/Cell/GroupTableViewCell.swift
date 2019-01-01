//
//  GroupTableViewCell.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 01/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    
    
    var GroupNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(30))
        return label
    }()
    
    var lastMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: CGFloat(20))
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(20))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: CGFloat(15))
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
//        self.backgroundColor = .black
        self.contentView.addSubviews(GroupNameLabel,userNameLabel, lastMessageLabel, timeLabel)
        setupConstraints()
    }
    
    
    private func setupConstraints() {
        let constraints = [
            contentView.heightAnchor.constraint(equalToConstant: 100),
            GroupNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            GroupNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            GroupNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            userNameLabel.topAnchor.constraint(equalTo: GroupNameLabel.bottomAnchor, constant: 5),
            userNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: lastMessageLabel.leadingAnchor, constant: -8),
            
            lastMessageLabel.topAnchor.constraint(equalTo: userNameLabel.topAnchor, constant: 0),
//            lastMessageLabel.leadingAnchor.constraint(equalTo:  userNameLabel.trailingAnchor, constant: 8),
//            lastMessageLabel.trailingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 0),



//            timeLabel.topAnchor.constraint(equalTo: lastMessageLabel.bottomAnchor, constant: -10),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(constraints)
        
        
    }
}
