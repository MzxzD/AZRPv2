//
//  Theme.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 12/06/2018.
//  Copyright © 2018 Base MVVM Project. All rights reserved.
//
//todo: implement 
import UIKit
// import BaseKit
class Theme {
    private init(){
        //print("fonts: \(UIFont.familyNames)")
        
    }
    static let shared: Theme = Theme()
    
    func setNavigationBarColor(_ color: UIColor){
        UINavigationBar.appearance().barTintColor = color
    }
    
    
    
    //setup app theme.
//    func applyTheme() {
//        UIApplication.shared.statusBarStyle = .lightContent
//        LoaderHUD.applyColorToSpinner(color: .primaryColor)
//        let navigationBar = UINavigationBar.appearance()
//        navigationBar.isTranslucent = false
//        navigationBar.tintColor = UIColor.white
//        setNavigationBarColor(UIColor.primaryColor)
//    }
    
    /**
     Defines customation styles for the app content.
     Example:
     struct Styles {
     private init(){}
     struct Text {
     struct Regular {
     static let small = ColorStyle(font: Fonts.roboto.smallSize)
     static let normal = ColorStyle(font: Fonts.roboto.normalSize)
     static let big = ColorStyle(font: Fonts.roboto.bigSize)
     }
     struct Bold {
     static let small = ColorStyle(font: Fonts.robotoBold.smallSize)
     static let normal = ColorStyle(font: Fonts.robotoBold.normalSize)
     static let big = ColorStyle(font: Fonts.robotoBold.bigSize)
     static let extraBig = ColorStyle(font: Fonts.robotoBold.extraSize)
     
     }
     }
     */
    struct Styles {
        private init(){}
        
    }
    
    /**
     Exmaple:
     private struct Fonts{
     private init(){}
     static let roboto = FontStyle(fontName: "Roboto-Regular")
     static let robotoBold = FontStyle(fontName: "Roboto-Bold")
     }
     */
    private struct Fonts{
        //Define your fonts
        private init(){}
    }
    /**
     Example:
     
     internal struct ColorStyle {
     fileprivate  let font: UIFont
     let defaultColor: Style
     let blackColor: Style
     
     
     fileprivate init(font: UIFont){
     self.font = font
     defaultColor = Style(textColor: UIColor.normalTextColor,font: font)
     blackColor = Style(textColor: UIColor.blackTextColor, font: font)
     }
     
     }
     */
    internal struct ColorStyle {
        fileprivate  let font: UIFont
        //Define your colors!
        
        fileprivate init(font: UIFont){
            self.font = font
        }
    }
    /**
     Example :
     internal struct FontStyle {
     let smallSize: UIFont
     
     fileprivate init(fontName: String){
     smallSize = UIFont(name: fontName, size: 12)!
     }
     /**
     Initialze with default system italic font.
     */
     fileprivate init(){
     smallSize = UIFont.italicSystemFont(ofSize: 12)
     
     }
     }
     */
    internal struct FontStyle {
    }
}

