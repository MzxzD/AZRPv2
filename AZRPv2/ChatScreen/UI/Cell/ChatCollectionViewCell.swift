//
//  ChatCollectionViewCell.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 05/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {

    weak var collectionCellDelegate: CollectionViewCellDelegate?
    var messagePosition: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var MessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: CGFloat(15))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byCharWrapping
        label.numberOfLines = 0
        
        return label
    }()
    
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(15))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: CGFloat(10))
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var locationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "GpsImage"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
//        button.isHidden = true
        return button
    }()
    
    var imageButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.clear
        button.setTitle(" yeeey", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(10))
        button.layer.borderColor = UIColor.clear.cgColor

        return button
    }()
    
    var textBubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 15
//        view.layer.masksToBounds = true
        return view
    }()
    
    
    func setupView() {
        
//        self.addSubview(textBubbleView)
        self.addSubviews(MessageLabel,userNameLabel,timeLabel, locationButton, imageButton)
        var isMessageFromSender: Bool!
        if self.messagePosition != nil{
            guard let positionBool = self.collectionCellDelegate?.sortChatBubbles(messagePosition: self.messagePosition!) else {return}
            isMessageFromSender = positionBool

        }

        if isMessageFromSender {
            self.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
            MessageLabel.textColor = UIColor.white
            userNameLabel.textColor = UIColor.white
            timeLabel.textColor = UIColor.white
            imageButton.titleLabel?.textColor = UIColor.white
        }else {
            self.backgroundColor = UIColor(red: 241/255, green: 240/255, blue: 240/255, alpha: 1)
            MessageLabel.textColor = UIColor.black
            userNameLabel.textColor = UIColor.black
            timeLabel.textColor = UIColor.black
            imageButton.titleLabel?.textColor = UIColor.black
        }
        
        setupConstraints(isMessageSender: isMessageFromSender)

    }
    
    private func setupConstraints(isMessageSender: Bool){
        var constraints = [
            
            userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            userNameLabel.heightAnchor.constraint(equalToConstant: 17),
            
            MessageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            MessageLabel.leadingAnchor.constraint(equalTo:  leadingAnchor, constant: 20),
            MessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor , constant: -20),


            timeLabel.topAnchor.constraint(equalTo: MessageLabel.bottomAnchor, constant: 8),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            timeLabel.heightAnchor.constraint(equalToConstant: 8),
            
            locationButton.heightAnchor.constraint(equalToConstant: 25),
            locationButton.widthAnchor.constraint(equalToConstant: 25),
            locationButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            locationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            imageButton.widthAnchor.constraint(equalToConstant: 50),
            imageButton.heightAnchor.constraint(equalToConstant: 25),
            imageButton.topAnchor.constraint(equalTo: MessageLabel.bottomAnchor, constant: 8),
            imageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageButton.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: 8),

        ]
//        constraints[6].priority = UILayoutPriority(999)
        if !self.imageButton.isHidden {
            constraints += [
//
//                imageButton.heightAnchor.constraint(equalToConstant: 80),
//                imageButton.widthAnchor.constraint(equalToConstant: 80),
//                MessageLabel.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 8),

            ]
//            constraints.last?.priority = UILayoutPriority(1000)
        }
        
//        if isMessageSender{
//            constraints.append(textBubbleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10))
//        }else {
//            constraints.append(textBubbleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10))
//        }
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    
    override func layoutIfNeeded() {
        self.setupView()
    }

//
//    override func setNeedsLayout() {
//        self.setupView()
//    }
}
