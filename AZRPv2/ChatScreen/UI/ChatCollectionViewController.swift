//
//  ChatCollectionViewController.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 05/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ChatCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout,CollectionIndexPathDelegate {
    
    let alarmCollectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    var messageInputController : KeyboardView = KeyboardView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
    
    var viewModel: ChatViewModelProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToBottom()
    }

    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.viewModel.room.messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatCollectionViewCell
        //        cell.indexPathDelegate = self
        cell.collectionCellDelegate = viewModel
        cell.messagePosition = indexPath.row
//        let cgPointMessage = CGPoint(x: 8, y: 0)
//        let cgPoint = CGPoint(x: 0, y: 0)
//        let senderSize = createCGSizeForCell(indexPath: indexPath, text: cell.userNameLabel.text ?? .empty)
////        cell.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0)
//        cell.textBubbleView.frame = CGRect(origin: cgPoint, size: createCGSizeForCell(indexPath: indexPath))
//        cell.MessageLabel.frame = CGRect(origin: cgPointMessage, size: createCGSizeForCell(indexPath: indexPath, text: cell.MessageLabel.text ?? .empty))
//        cell.userNameLabel.frame = CGRect(origin: CGPoint(x: senderSize.width, y: 0), size: createCGSizeForCell(indexPath: indexPath, text: cell.userNameLabel.text ?? .empty))
//
//        cell.contentView.frame.size.width = view.frame.width
        
//        cell.setupLayout(room: self.viewModel.room, indexPath: indexPath, isSender: true, viewFrame: view.frame.width)
        
        cell.setupView()
        let messageItem = self.viewModel.room.messages[indexPath.row]
        // Configure the cell
        cell.MessageLabel.text = messageItem.content
        cell.userNameLabel.text = messageItem.sender
        cell.timeLabel.text = dayStringFromTime(unixTime: (messageItem.time ) / 1000) + " " +  timeStringFromUnixTime(unixTime: (messageItem.time) / 1000)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        return createCGSizeForCell(indexPath: indexPath)
         return CGSize(width: 250, height: 200)
        
    }
    
    func getIndexPath(forTableCell cell: ChatCollectionViewCell) -> IndexPath? {
        let returnvalue = collectionView.indexPath(for: cell)
        return returnvalue
    }
    
    private func setupView() {
        
        self.title = viewModel.room.name
        collectionView.backgroundColor = UIColor.white
        
        messageInputController.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageInputController)
        messageInputController.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        messageInputController.heightAnchor.constraint(equalToConstant: 48).isActive = true
        messageInputController.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView!.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -48).isActive = true
 
        

    }
    
    private func scrollToBottom() {
        let item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
        let lastItemIndex = NSIndexPath(item: item, section: 0)
        self.collectionView?.scrollToItem(at: lastItemIndex as IndexPath, at: UICollectionView.ScrollPosition.bottom, animated: false)
        
        
    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat(integerLiteral: 50)
//    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat(integerLiteral: 100)
//    }
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}

protocol CollectionIndexPathDelegate: class {
    func getIndexPath(forTableCell cell: ChatCollectionViewCell ) -> IndexPath?
    
}

extension ChatCollectionViewController {
    func createCGSizeForCell(indexPath: IndexPath, text: String) -> CGSize {
        
        //        if let messageText = viewModel.room.messages[indexPath.row].content {
        //            let messageTime = String(viewModel.room.messages[indexPath.row].time)
        //            let messageSender = viewModel.room.messages[indexPath.row].sender
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        //            let estimatedFrameForSender = NSString(string: messageSender ?? .empty).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 20)!], context: nil)
        //
        //
        //            let estimatedFrameForTime = NSString(string: messageTime).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 15)!], context: nil)
        
//        textBubbleView.frame = CGRect(x: viewFrame - sumSize.width  , y: 20, width: estimatedFrameForText.width, height: sumSize.height + 50)
        
        
        let estimatedFrameForText = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 20)!], context: nil)
        
        return CGSize(width: estimatedFrameForText.width, height: (estimatedFrameForText.height))
        //        }
        //        return CGSize(width: 10, height: 100)
    }
    
    func createCGSizeForCell(indexPath: IndexPath) -> CGSize {
        
        if let messageText = viewModel.room.messages[indexPath.row].content {
            let messageTime = String(viewModel.room.messages[indexPath.row].time)
            let messageSender = viewModel.room.messages[indexPath.row].sender
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            
            let estimatedFrameForSender = NSString(string: messageSender ?? .empty).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 20)!], context: nil)
            
            
            let estimatedFrameForTime = NSString(string: messageTime).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 15)!], context: nil)
            
            
            let estimatedFrameForText = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 20)!], context: nil)
            let sumSize = CGRect(x: 0, y: 0, width: estimatedFrameForText.width + estimatedFrameForTime.width + estimatedFrameForSender.width , height: estimatedFrameForText.height + estimatedFrameForTime.height + estimatedFrameForSender.height)
            
          
            
            return CGSize(width: estimatedFrameForText.width + estimatedFrameForTime.width - 20, height: (sumSize.height + 30))
        }
        return CGSize(width: 10, height: 100)
    }
    
    
    
}
