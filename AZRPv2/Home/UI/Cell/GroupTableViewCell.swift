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
        label.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(17))
        return label
    }()
    
    var lastMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: CGFloat(15))
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: CGFloat(15))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: CGFloat(10))
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var roomLogoLabel: UILabel = {
        let size:CGFloat = 35.0
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.white
        label.layer.cornerRadius = size / 2
        label.layer.borderWidth = 0
        label.layer.backgroundColor = UIColor.random.cgColor
        label.layer.borderColor = UIColor.black.cgColor
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
        self.contentView.addSubviews(GroupNameLabel,userNameLabel, lastMessageLabel, timeLabel,roomLogoLabel)
        setupConstraints()
    }
    
    
    private func setupConstraints() {
        let constraints = [
            contentView.heightAnchor.constraint(equalToConstant: 75),
            roomLogoLabel.widthAnchor.constraint(equalToConstant: 35),
            roomLogoLabel.heightAnchor.constraint(equalToConstant: 35),
            roomLogoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            roomLogoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            GroupNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            GroupNameLabel.leadingAnchor.constraint(equalTo: roomLogoLabel.trailingAnchor, constant: 8),
            GroupNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            userNameLabel.topAnchor.constraint(equalTo: GroupNameLabel.bottomAnchor, constant: 5),
            userNameLabel.leadingAnchor.constraint(equalTo: roomLogoLabel.trailingAnchor, constant: 8),
            
            lastMessageLabel.topAnchor.constraint(equalTo: userNameLabel.topAnchor, constant: 0),
            lastMessageLabel.leadingAnchor.constraint(equalTo:  userNameLabel.trailingAnchor, constant: 0),
//            lastMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(constraints)

    
    }
    
}
