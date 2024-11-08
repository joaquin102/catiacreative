//
//  ImageBox.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 10/11/24.
//

import Foundation
import SwiftUI


enum ImageSymbol: String {
    
    case gift = "gift";
    case qrReader = "qrcode.viewfinder";
    case settings = "slider.vertical.3";
    case heartFill = "heart.fill";
    case heart = "heart";
    case restartAudio = "arrow.trianglehead.counterclockwise";
    case playAudio = "play.fill";
    case stopAudio = "stop.fill";
    case pauseAudio = "pause.fill";
    case infinity = "infinity"
}

enum ImageIcon: String {
    
    case ghost = "Ghost";
}

enum IconSize:CGFloat {
    
    case xxSmall = 15
    case xSmall = 20
    case small = 25
    case medium = 30
    case large = 35
    case xLarge = 40
    case xxLarge = 45
    case xxxLarge = 50
}



extension Image {
    
    static func symbol(_ symbol:ImageSymbol, size: IconSize = .small, color:AssetsColor = .black, weight:Font.Weight = .thin) -> some View {
        
        Image(systemName: symbol.rawValue)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size.rawValue, height: size.rawValue)
            .font(.system(size: size.rawValue, weight: weight))
            .foregroundColor(.custom(color))
    }
    
    static func icon(_ icon:ImageIcon, size: IconSize = .small, color:AssetsColor = .black, weight:Font.Weight = .thin) -> some View {
        
        Image(icon.rawValue, bundle: .main)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size.rawValue, height: size.rawValue)
            .font(.system(size: size.rawValue, weight: weight))
            .foregroundColor(.custom(color))
    }
    
    
}
