//
//  ChatCollectionViewCell.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 05/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {

//    weak var indexPathDelegate: CollectionIndexPathDelegate?
    weak var collectionCellDelegate: CollectionViewCellDelegate?
    var messagePosition: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var MessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: CGFloat(20))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        
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
//        addSubview(textBubbleView)
        self.textBubbleView.addSubviews(MessageLabel,userNameLabel,timeLabel, locationButton, imageView)
      //  addSubview(userNameLabel, userNameLabel, timeLabel)
//        self.contentView.backgroundColor = UIColor.clear
        var chatBubblePositionBool: Bool = false
        
        if self.messagePosition != nil{
            guard let positionBool = self.collectionCellDelegate?.sortChatBubbles(messagePosition: self.messagePosition!) else {return}
            chatBubblePositionBool = positionBool

        }


        
        
        if chatBubblePositionBool {
            textBubbleView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
//            contentView.backgroundColor = UIColor.blue
            MessageLabel.textColor = UIColor.white
            userNameLabel.textColor = UIColor.white
            timeLabel.textColor = UIColor.white
        }else {
            textBubbleView.backgroundColor = UIColor(red: 241/255, green: 240/255, blue: 240/255, alpha: 1)
            MessageLabel.textColor = UIColor.black
            userNameLabel.textColor = UIColor.black
            timeLabel.textColor = UIColor.black
        }
        
        setupConstraints(chatBubblePositionBool: true)

    }
    
    func setupLayout(room: Room, indexPath: IndexPath, isSender: Bool, viewFrame: CGFloat) {
        
        let messageText = room.messages[indexPath.row].content
        let messageTime = String(room.messages[indexPath.row].time)
        let messageSender = room.messages[indexPath.row].sender
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let estimatedFrameForSender = NSString(string: messageSender ?? .empty).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 20)!], context: nil)
        
        
        let estimatedFrameForTime = NSString(string: messageTime).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 15)!], context: nil)
        
        
        let estimatedFrameForText = NSString(string: messageText ?? "khgfjghjdjfdhfdhfdh").boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 20)!], context: nil)
        
        
         let sumSize = CGRect(x: 0, y: 0, width: estimatedFrameForText.width + estimatedFrameForTime.width + estimatedFrameForSender.width , height: estimatedFrameForText.height + estimatedFrameForTime.height + estimatedFrameForSender.height)
        
//        let cgPointMessage = CGPoint(x: 8, y: 0)
//        let cgPoint = CGPoint(x: 0, y: 0)
//        let senderSize = createCGSizeForCell(indexPath: indexPath, text: userNameLabel.text ?? .empty)
//        //        cell.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0)
//        textBubbleView.frame = CGRect(origin: cgPoint, size: createCGSizeForCell(indexPath: indexPath))
//        MessageLabel.frame = CGRect(origin: cgPointMessage, size: createCGSizeForCell(indexPath: indexPath, text: cell.MessageLabel.text ?? .empty))
//        userNameLabel.frame = CGRect(origin: CGPoint(x: senderSize.width, y: 0), size: createCGSizeForCell(indexPath: indexPath, text: cell.userNameLabel.text ?? .empty))
//        contentView.frame.size.width = viewFrame
//
//        MessageLabel.frame = CGRect(x: viewFrame - estimatedFrameForText.width - 32 , y: 0, width: estimatedFrameForText.width, height: estimatedFrameForText.height)
        
//        textBubbleView.frame = CGRect(x: viewFrame - sumSize.width  , y: 20, width: estimatedFrameForText.width, height: sumSize.height + 50)
//
//        userNameLabel.frame = CGRect(x: viewFrame - estimatedFrameForSender.width - 32 , y: 0, width: estimatedFrameForSender.width, height: estimatedFrameForSender.height)
//
//        timeLabel.frame = CGRect(x: viewFrame - estimatedFrameForTime.width - 32 , y: 0, width: estimatedFrameForTime.width, height: estimatedFrameForTime.height)
//        self.contentView.frame = CGRect()
  
    }
    
//    override func layoutIfNeeded() {
//        self.setupView()
//    }
    
    
    private func setupConstraints(chatBubblePositionBool: Bool){
//
        var constraints = [
            textBubbleView.widthAnchor.constraint(equalToConstant: 250),
            textBubbleView.heightAnchor.constraint(equalToConstant: 200),
//            textBubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 3),
//            textBubbleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textBubbleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//
            userNameLabel.topAnchor.constraint(equalTo: textBubbleView.topAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: textBubbleView.leadingAnchor, constant: 8),
//            userNameLabel.trailingAnchor.constraint(equalTo: textBubbleView.leadingAnchor, constant: 0),
            
            imageView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            imageView.bottomAnchor.constraint(equalTo: MessageLabel.topAnchor, constant: -8),
            
            MessageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            MessageLabel.leadingAnchor.constraint(equalTo:  textBubbleView.leadingAnchor, constant: 20),
            MessageLabel.trailingAnchor.constraint(equalTo: textBubbleView.trailingAnchor , constant: -8),


            //
//
            locationButton.heightAnchor.constraint(equalToConstant: 35),
            locationButton.widthAnchor.constraint(equalToConstant: 35),
            locationButton.topAnchor.constraint(equalTo: userNameLabel.topAnchor, constant: 25),
            locationButton.leadingAnchor.constraint(equalTo: textBubbleView.leadingAnchor, constant: 8),
            //            locationButton.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -8),
//            locationButton.bottomAnchor.constraint(equalTo: textBubbleView.bottomAnchor, constant: -8),

            
            timeLabel.trailingAnchor.constraint(equalTo: textBubbleView.trailingAnchor, constant: -20),
            timeLabel.bottomAnchor.constraint(equalTo: textBubbleView.bottomAnchor, constant: -8)
            
 
            
        ]
        constraints[7].priority = UILayoutPriority(999)
        if !self.imageView.isHidden {
            constraints += [
            
                imageView.heightAnchor.constraint(equalToConstant: 80),
                imageView.widthAnchor.constraint(equalToConstant: 80),
                MessageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),

            ]
            constraints.last?.priority = UILayoutPriority(1000)
        }
        
        NSLayoutConstraint.activate(constraints)
        
    }
}
