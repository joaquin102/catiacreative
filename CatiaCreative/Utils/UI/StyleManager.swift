//
//  StyleManager.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 10/11/24.
//

import SwiftUI

enum CustomFont: String {
    case lillyMae = "LillyMae-Regular"
    case gilroyBlack = "Gilroy-Black"
    case gilroyBlackItalic = "Gilroy-BlackItalic"
    case gilroyBold = "Gilroy-Bold"
    case gilroyBoldItalic = "Gilroy-BoldItalic"
    case gilroyExtraBold = "Gilroy-ExtraBold"
    case gilroyExtraBoldItalic = "Gilroy-ExtraBoldItalic"
    case gilroyHeavy = "Gilroy-Heavy"
    case gilroyHeavyItalic = "Gilroy-HeavyItalic"
    case gilroyLight = "Gilroy-Light"
    case gilroyLightItalic = "Gilroy-LightItalic"
    case gilroyMedium = "Gilroy-Medium"
    case gilroyMediumItalic = "Gilroy-MediumItalic"
    case gilroyRegular = "Gilroy-Regular"
    case gilroyRegularItalic = "Gilroy-RegularItalic"
    case gilroySemiBold = "Gilroy-SemiBold"
    case gilroySemiBoldItalic = "Gilroy-SemiBoldItalic"
    case gilroyThin = "Gilroy-Thin"
    case gilroyThinItalic = "Gilroy-ThinItalic"
    case gilroyUltraLight = "Gilroy-UltraLight"
    case gilroyUltraLightItalic = "Gilroy-UltraLightItalic"
    case breathing = "BreathingPersonalUse"
}

enum TextSize:CGFloat {
    
    case xSmall = 12.0
    case small = 16.0
    case medium = 20.0
    case large = 25.0
    case xLarge = 30.0
    case xxLarge = 35.0;
    case xxxLarge = 50.0;
}


//MARK: - COLOR

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

//MARK: - FONTS

extension Font {
    
    static func custom(style: CustomFont, size: TextSize) -> Font {
        return Font.custom(style.rawValue, size: size.rawValue)
    }
    
    static func custom(style: CustomFont, size: CGFloat) -> Font {
        return Font.custom(style.rawValue, size: size)
    }

}

extension UIFont {
    
    static func custom(style: CustomFont, size:TextSize) -> UIFont {
        
        return UIFont(name: style.rawValue, size: size.rawValue)!
    }
}



//MARK: - UI

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
