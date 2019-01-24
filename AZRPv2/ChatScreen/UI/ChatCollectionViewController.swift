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
import RxSwift

private let reuseIdentifier = "Cell"

class ChatCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout,CollectionIndexPathDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let disposeBag = DisposeBag()
    var imagePicker : UIImagePickerController?
    var locationManager = CLLocationManager()

    
    let alarmCollectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    var messageInputController : KeyboardView = KeyboardView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
    
    var viewModel: ChatViewModelProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
//        initializeReloadALL()
        newEventListener()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToBottom()
    }
    
    func initializeData() {
//        let realm
    }
    
    
    func newEventListener(){
        let newMessage = self.delegate.socketController.newMessage
        newMessage
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (event) in
                if event {
                    // TODO: CREATE FUNC IN VM TO SEE IF THAT's FOR HERE if NOT NOITIFICATION
                    self.viewModel.reFetchDataFromRealm()
                    self.collectionView.reloadData()
                    self.scrollToBottom()
//                    self.viewModel.fetchSavedRooms()
                }
            })
            .disposed(by: disposeBag)
        
        
        let newRoom = self.delegate.socketController.newRoom
        newRoom
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (event) in
                if event {
                    // TODO: CREATE NOITIFICATION FOR THIS SHIT
//                    self.collectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatCollectionViewCell
        cell.collectionCellDelegate = viewModel
        cell.messagePosition = indexPath.row
        
        let messageItem = self.viewModel.messages[indexPath.row]
        cell.MessageLabel.text = messageItem.content
        cell.userNameLabel.text = messageItem.sender
        cell.timeLabel.text = dayStringFromTime(unixTime: (messageItem.time ) / 1000) + " " +  timeStringFromUnixTime(unixTime: (messageItem.time) / 1000)
        if messageItem.fileName != nil {
            cell.imageButton.setTitle(messageItem.fileName, for: .normal)
            cell.imageButton.isHidden = false
        }
        
        if messageItem.longitude != 0 && messageItem.latitude != 0 {
            cell.locationButton.isHidden = false
        }
        cell.setupView()
        cell.passIndexPathToVMOpenImageView = {
            self.viewModel.openImageView(element: indexPath.row)
        }
        
        cell.passIndexPathToVMOpenNavigationView = {
            self.viewModel.openNavigationView(element: indexPath.row)
        }
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return createCGSizeForCell(indexPath: indexPath)

//         return CGSize(width: view.bounds.width, height: 200)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func getIndexPath(forTableCell cell: ChatCollectionViewCell) -> IndexPath? {
        let returnvalue = collectionView.indexPath(for: cell)
        return returnvalue
    }
    
    
    private func initializeReloadALL(){
        let reload = self.viewModel.reinitALL
        reload
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {  (event) in
                if event {
                    self.messageInputController = KeyboardView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
                    self.setupView()
                }
            })
            .disposed(by: disposeBag)
        
        
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor.white
        self.messageInputController.imageDelegate = self
        self.messageInputController.locationDelegate = self
        self.messageInputController.viewModelDelegate = self.viewModel
        
        self.title = viewModel.messages.last?.roomName
        collectionView.backgroundColor = UIColor.white
        
        messageInputController.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageInputController)
        messageInputController.initializeImageListener()
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
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -53).isActive = true

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
    func createCGSizeForCell(indexPath: IndexPath) -> CGSize {

        if let messageText = viewModel.messages[indexPath.row].content {
            let messageTime = String(viewModel.messages[indexPath.row].time)
            let messageSender = viewModel.messages[indexPath.row].sender
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

            let estimatedFrameForSender = NSString(string: messageSender ?? .empty).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 15)!], context: nil)


            let estimatedFrameForTime = NSString(string: messageTime).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 10)!], context: nil)


            let estimatedFrameForText = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 15)!], context: nil)
            
            
            let sumSize = CGRect(x: 0, y: 0, width: estimatedFrameForText.width + estimatedFrameForTime.width + estimatedFrameForSender.width , height: estimatedFrameForText.height + estimatedFrameForTime.height + estimatedFrameForSender.height)

            return CGSize(width: self.view.bounds.width, height: (sumSize.height + 55))
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
        
        self.messageInputController.imageButton.imageView?.image = selectedImage
        self.messageInputController.imageButton.setImage( #imageLiteral(resourceName: "imageHighlited"), for: .highlighted)
        self.messageInputController.imageButton.isHighlighted = true
        self.messageInputController.image = selectedImage
        self.viewModel.image = selectedImage
  
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
        self.messageInputController.location = Coordinates(longitude: coordinate.longitude , latitude: coordinate.latitude )
        self.messageInputController.gpsButton.setImage( #imageLiteral(resourceName: "GpsHighlited"), for: .highlighted)
        self.messageInputController.gpsButton.isHighlighted = true
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
