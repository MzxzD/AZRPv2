//
//  NSAttributedString+Extensions.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 31/12/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//


import Foundation
import UIKit
extension NSMutableAttributedString
{
    enum scripting : Int
    {
        case aSub = -1
        case aSuper = 1
    }
    
    func changeColorOfAStringInPopUp(string: String, stringToColor: String) -> NSMutableAttributedString{
        // Set initial attributed string
        let initialString = string
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .semibold)]
        let mutableAttributedString = NSMutableAttributedString(string: initialString, attributes: attributes)
        
        // Set new attributed string
        let newString = stringToColor
        let newAttributes = [NSAttributedString.Key.foregroundColor : UIColor.red]
        let newAttributedString = NSMutableAttributedString(string: newString, attributes: newAttributes)
        
        // Get range of text to replace
        guard let range = mutableAttributedString.string.range(of: stringToColor) else { exit(0) }
        let nsRange = NSRange(range, in: mutableAttributedString.string)
        
        // Replace content in range with the new content
        mutableAttributedString.replaceCharacters(in: nsRange, with: newAttributedString)
        return mutableAttributedString
    }
    
    func changeColorOfAStringInDisclaimer(string: String, stringToColor: String, numberToColor: String) -> NSMutableAttributedString{
        // Set initial attributed string
        let initialString = string
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.gray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
        let mutableAttributedString = NSMutableAttributedString(string: initialString, attributes: attributes)
        //        mutableAttributedString.tex
        
        // Set new attributed string
        let newString = stringToColor
        let newAttributes = [NSAttributedString.Key.foregroundColor : UIColor.red, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15) ]
        let newAttributedString = NSMutableAttributedString(string: newString, attributes: newAttributes)
        
        
        let newStringNumber = numberToColor
        let newStringNumberAttributes = [NSAttributedString.Key.foregroundColor : UIColor.red, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
        let newAttributedStringNumber = NSMutableAttributedString(string: newStringNumber, attributes: newStringNumberAttributes)
        
        // Get range of text to replace
        guard let range = mutableAttributedString.string.range(of: stringToColor) else { exit(0) }
        let nsRange = NSRange(range, in: mutableAttributedString.string)
        //        newAttributedString.addAttribute(.link, value: stringToColor, range: nsRange)
        
        guard let rangeOfNumber = mutableAttributedString.string.range(of: numberToColor) else { exit(0) }
        let nsNumberRange = NSRange(rangeOfNumber, in: mutableAttributedString.string)
        //        newAttributedString.addAttribute(.link, value: numberToColor, range: nsNumberRange)
        
        // Replace content in range with the new content
        mutableAttributedString.replaceCharacters(in: nsRange, with: newAttributedString)
        mutableAttributedString.replaceCharacters(in: nsNumberRange, with: newAttributedStringNumber)
        return mutableAttributedString
    }
    
    func characterSubscriptAndSuperscript(string:String,
                                          characters:[Character],
                                          type:scripting,
                                          fontSize:CGFloat,
                                          scriptFontSize:CGFloat,
                                          offSet:Int,
                                          alignment:NSTextAlignment)-> NSMutableAttributedString
    {
        let paraghraphStyle = NSMutableParagraphStyle()
        // Set The Paragraph aligmnet , you can ignore this part and delet off the function
        paraghraphStyle.alignment = alignment
        
        var scriptedCharaterLocation = Int()
        //Define the fonts you want to use and sizes
        let stringFont = UIFont.boldSystemFont(ofSize: fontSize)
        let scriptFont = UIFont.boldSystemFont(ofSize: scriptFontSize)
        // Define Attributes of the text body , this part can be removed of the function
        let attString = NSMutableAttributedString(string:string, attributes: [NSAttributedString.Key.font:stringFont, NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.paragraphStyle: paraghraphStyle])
        
        // the enum is used here declaring the required offset
        let baseLineOffset = offSet * type.rawValue
        // enumerated the main text characters using a for loop
        for (index,character) in string.enumerated()
        {
            // enumerated the array of first characters to subscript
            for aCharacter in characters
            {
                if character == aCharacter
                {
                    // Get to location of the first character
                    scriptedCharaterLocation = index
                    //Now set attributes starting from the character above
                    attString.setAttributes([NSAttributedString.Key.font:scriptFont,
                                             // baseline off set from . the enum i.e. +/- 1
                        NSAttributedString.Key.baselineOffset:baseLineOffset,
                        NSAttributedString.Key.foregroundColor:UIColor.black],
                                            // the range from above location
                        range:NSRange(location:scriptedCharaterLocation,
                                      // you define the length in the length array
                            // if subscripting at different location
                            // you need to define the length for each one
                            length:1))
                }
            }
        }
        return attString}
}

