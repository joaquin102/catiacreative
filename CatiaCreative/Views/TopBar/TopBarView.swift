//
//  TopBarView.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 10/23/24.
//
import SwiftUI

enum ButtonType {
    
    case gifts
    case nfcScanner
    case settings
}

typealias ButtonTappedBlock = (_ buttonType:ButtonType) -> Void;

struct TopBarView: View {
    
    var buttonTappedBlock:ButtonTappedBlock?
    
    var body: some View {
        HStack {
            
            Button(action: {
                
                self.buttonTappedBlock?(.gifts);
                
            }) {
                
                Image.symbol(.gift, size: .medium, color: .white);
            }
            
            Spacer()
            
            Button(action: {
                
                print("NFC scanner tapped");
                
                self.buttonTappedBlock?(.nfcScanner);
                
            }) {
                
                Image.symbol(.qrReader, size: .medium, color: .white);
            }
            .padding(.trailing, 20);
            
            Button(action: {
                
                self.buttonTappedBlock?(.settings);
                
            }) {
                
                Image.symbol(.settings, size: .medium, color: .white);
            }
        }
        .padding(.horizontal, 20)
    }
}
