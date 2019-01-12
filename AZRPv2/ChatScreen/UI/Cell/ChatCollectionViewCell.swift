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
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
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
    
    var imageView : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "logo")
        image.backgroundColor = UIColor.red
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
//        image.isHidden = true
        return image
    }()
    
    var textBubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    
    func setupView() {
        
        self.addSubview(textBubbleView)
        self.textBubbleView.addSubviews(MessageLabel,userNameLabel,timeLabel, locationButton, imageView)
        var isMessageFromSender: Bool!
        if self.messagePosition != nil{
            guard let positionBool = self.collectionCellDelegate?.sortChatBubbles(messagePosition: self.messagePosition!) else {return}
            isMessageFromSender = positionBool

        }

        if isMessageFromSender {
            textBubbleView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
            MessageLabel.textColor = UIColor.white
            userNameLabel.textColor = UIColor.white
            timeLabel.textColor = UIColor.white
        }else {
            textBubbleView.backgroundColor = UIColor(red: 241/255, green: 240/255, blue: 240/255, alpha: 1)
            MessageLabel.textColor = UIColor.black
            userNameLabel.textColor = UIColor.black
            timeLabel.textColor = UIColor.black
        }
        
        setupConstraints(isMessageSender: isMessageFromSender)

    }
    
    private func setupConstraints(isMessageSender: Bool){
        var constraints = [
            textBubbleView.widthAnchor.constraint(equalToConstant: 170),
            textBubbleView.heightAnchor.constraint(equalToConstant: 170),
            
            userNameLabel.topAnchor.constraint(equalTo: textBubbleView.topAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: textBubbleView.leadingAnchor, constant: 8),
            
            imageView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            imageView.centerXAnchor.constraint(equalTo: textBubbleView.centerXAnchor),
            
            MessageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            MessageLabel.leadingAnchor.constraint(equalTo:  textBubbleView.leadingAnchor, constant: 20),
            MessageLabel.trailingAnchor.constraint(equalTo: textBubbleView.trailingAnchor , constant: -8),

            locationButton.heightAnchor.constraint(equalToConstant: 35),
            locationButton.widthAnchor.constraint(equalToConstant: 35),
            locationButton.topAnchor.constraint(equalTo: userNameLabel.topAnchor, constant: 25),
            locationButton.leadingAnchor.constraint(equalTo: textBubbleView.leadingAnchor, constant: 8),

            timeLabel.trailingAnchor.constraint(equalTo: textBubbleView.trailingAnchor, constant: -20),
            timeLabel.bottomAnchor.constraint(equalTo: textBubbleView.bottomAnchor, constant: -8)

        ]
        constraints[6].priority = UILayoutPriority(999)
        if !self.imageView.isHidden {
            constraints += [
            
                imageView.heightAnchor.constraint(equalToConstant: 80),
                imageView.widthAnchor.constraint(equalToConstant: 80),
                MessageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),

            ]
            constraints.last?.priority = UILayoutPriority(1000)
        }
        
        if isMessageSender{
            constraints.append(textBubbleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10))
        }else {
            constraints.append(textBubbleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10))
        }
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
//    override func layoutIfNeeded() {
//        self.setupView()
//    }

//    override func setNeedsLayout() {
//        var isMessageFromSender: Bool = false
//
//        if self.messagePosition != nil{
//            guard let positionBool = self.collectionCellDelegate?.sortChatBubbles(messagePosition: self.messagePosition!) else {return}
//            isMessageFromSender = positionBool
//
//        }
//        setupConstraints(isMessageSender: isMessageFromSender)
//    }
}
