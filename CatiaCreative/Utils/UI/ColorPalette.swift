//
//  ColorPallette.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 10/11/24.
//
import SwiftUI

enum AssetsColor: String, CaseIterable {
//    case lightBlue
//    case lightPurple
//    case lightRed
//    case lightOrange
//    case lightGreen
//    case blue
//    case darkBlue
//    case green
//    case darkGreen
    case gray
//    case lightGray
//    case darkGray
//    case orange
//    case pink
    case red
    case purple
    case darkPurple
//    case yellow
    case black
//    case coral
//    case tableViewGray
//    case brown
    case white
}

extension Color {
    
    static func custom(_ assetColor:AssetsColor) -> Color {
        
        return Color(assetColor.rawValue);
    }
}
