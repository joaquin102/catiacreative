//
//  EmptyStateView.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 11/4/24.
//

import SwiftUI

struct EmptyStateView: View {
    
    var title: String
    var subtitle: String
    var buttonText:String = ""
    var imageIcon:ImageIcon
    
    var buttonTapped:reactiveBlock?
    
    var body: some View {
        
        ZStack {
            GradientBackgroundView()
            
            Spacer()
            
            VStack() {
                
                VStack() {
                    
                    Image("Ghost", bundle: .main)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120)
                        .padding(.bottom, 30)
                    
      
                    Text(title)
                        .font(.custom(style: .gilroyBold, size: .xLarge))
                        .foregroundStyle(Color.custom(.white))
                        .padding(.bottom, 5)
                    
                    Text(subtitle)
                        .multilineTextAlignment(.center)
                        .font(.custom(style: .gilroyLight, size: .medium))
                        .foregroundStyle(Color.custom(.gray))
                        .containerRelativeFrame(.horizontal) { length, _ in
                            
                            length * 0.6
                        }
                }
                .padding(.bottom, 150)
                
                
                if buttonText.count > 0 {
                    
                    ButtonView(text: buttonText) {
                        
                        //Call NFC
                    }
                }
                
                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            
        }
    }
}

#Preview {
    EmptyStateView(title: "Oh no!",
                   subtitle: "You need an Apple Music or Spotify subscription to use this feature.", buttonText: "Get trial of Apple Music",
                   imageIcon: .ghost)
}
