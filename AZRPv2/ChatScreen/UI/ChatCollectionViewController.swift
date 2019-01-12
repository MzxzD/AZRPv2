//
//  ChatCollectionViewController.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 05/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import CoreLocation


private let reuseIdentifier = "Cell"

class ChatCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout,CollectionIndexPathDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var imagePicker : UIImagePickerController?
    var locationManager = CLLocationManager()

    
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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.room.messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatCollectionViewCell
        cell.collectionCellDelegate = viewModel
        cell.messagePosition = indexPath.row
        let messageItem = self.viewModel.room.messages[indexPath.row]
        cell.MessageLabel.text = messageItem.content
        cell.userNameLabel.text = messageItem.sender
        cell.timeLabel.text = dayStringFromTime(unixTime: (messageItem.time ) / 1000) + " " +  timeStringFromUnixTime(unixTime: (messageItem.time) / 1000)
        cell.setupView()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return createCGSizeForCell(indexPath: indexPath)
//         return CGSize(width: view.bounds.width, height: 200)
        
    }
    
    func getIndexPath(forTableCell cell: ChatCollectionViewCell) -> IndexPath? {
        let returnvalue = collectionView.indexPath(for: cell)
        return returnvalue
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        self.messageInputController.imageDelegate = self
        self.messageInputController.locationDelegate = self
        
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
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -56).isActive = true

    }
    
    private func scrollToBottom() {
        let item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
        let lastItemIndex = NSIndexPath(item: item, section: 0)
        self.collectionView?.scrollToItem(at: lastItemIndex as IndexPath, at: UICollectionView.ScrollPosition.bottom, animated: false)
        
        
    }
    
}

protocol CollectionIndexPathDelegate: class {
    func getIndexPath(forTableCell cell: ChatCollectionViewCell ) -> IndexPath?
    
}

extension ChatCollectionViewController {
    func createCGSizeForCell(indexPath: IndexPath, text: String) -> CGSize {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
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
            
            let estimatedFrameForSender = NSString(string: messageSender ?? .empty).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 15)!], context: nil)
            
            
            let estimatedFrameForTime = NSString(string: messageTime).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 10)!], context: nil)
            
            
            let estimatedFrameForText = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 15)!], context: nil)
            let sumSize = CGRect(x: 0, y: 0, width: estimatedFrameForText.width + estimatedFrameForTime.width + estimatedFrameForSender.width , height: estimatedFrameForText.height + estimatedFrameForTime.height + estimatedFrameForSender.height)
            
            return CGSize(width: self.view.bounds.width, height: (sumSize.height + 130))
        }
        return CGSize(width: 10, height: 100)
    }
    
    
    
    
  
    
   
    
}


extension ChatCollectionViewController: ImageDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // Dismiss the picker if the user canceled
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        for cell in self.collectionView.visibleCells {
            let cello = cell as! ChatCollectionViewCell
            cello.imageView.image = selectedImage
        }
        
        //Set photoImageView to display the selected image.
        //        photoImageView.image = selectedImage
        
        // Dismiss the picker
        dismiss(animated: true, completion: nil)
        
    }
    
    
    private func prepareForImagePicker(){
        self.imagePicker = UIImagePickerController()
        self.imagePicker?.delegate = self
        self.imagePicker?.allowsEditing = false
        self.imagePicker?.sourceType = .photoLibrary
        
    }
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized: print("Access is granted by user")
        case .notDetermined: PHPhotoLibrary.requestAuthorization({
            (newStatus) in print("status is \(newStatus)")
            if newStatus == PHAuthorizationStatus.authorized {
                 print("success") }
            })
            case .restricted:  print("User do not have access to photo album.")
            case .denied:  print("User has denied the permission.")
            }
        }
    
    func getImage() {
        prepareForImagePicker()
        checkPermission()
        self.viewModel.openImagePicker(imagePicker: self.imagePicker!)
    }
    
    
}

extension ChatCollectionViewController: LocationDelegate {
    func prepareForLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
            //do whatever init activities here.
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }
        print(String(coordinate.latitude))
        print(String(coordinate.longitude))
        locationManager.stopUpdatingLocation()
        // ADD A WAY TO SAVE LOCATION INTO MODEL AND SHOW TO USER
    }
    
    func isAuthorizedtoGetUserLocation() {
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    func getLocation() {
        prepareForLocation()
        isAuthorizedtoGetUserLocation()
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.requestLocation();
        }
    }
    
    
}
