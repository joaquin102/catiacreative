//
//  ScanView.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 11/4/24.
//
import SwiftUI

struct ScanView: View {
    
    @Binding var musicApi:MusicApi
    
    var body: some View {
        
        ZStack {
            GradientBackgroundView()
            
            Spacer()
            
            VStack() {
                
                VStack() {
                    Image("Heart", bundle: .main)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150)
                        .padding(.bottom, 25)
                    
                    Text("Scan it!")
                        .font(.custom(style: .gilroyBold, size: .xLarge))
                        .foregroundStyle(Color.custom(.white))
                        .padding(.bottom, 5)
                    
                    Text("Tap the button below to scan your art")
                        .multilineTextAlignment(.center)
                        .font(.custom(style: .gilroyLight, size: .medium))
                        .foregroundStyle(Color.custom(.gray))
                        .containerRelativeFrame(.horizontal) { length, _ in
                            
                            length * 0.6
                        }
                }
                .padding(.bottom, 150)
                
                
                
                ButtonView(text: "Scan art") {
                    
                    //Call NFC
                    musicApi.scanMusicTag();
                }
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            
        }
    }
}

#Preview {
    struct Preview: View {
        @State var musicApi = MusicApi()
        var body: some View {
            ScanView(musicApi: $musicApi)
        }
    }

    return Preview()
}

