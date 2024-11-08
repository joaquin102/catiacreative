//
//  MusicPlayerView.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 10/10/24.
//
import SwiftUI
import MusicKit
import Charts
import AVFoundation
import Accelerate
import Combine
import LoaderUI

enum Constants {
    
    static let barAmount = 50
    static let magnitudeLimit: Float = 30
}


struct MusicPlayerView: View {

    @State private var musicApi = MusicApi();
    @State private var openedWithNFC: Bool = false;
    
    var body: some View {
        
        
        ZStack {
            GradientBackgroundView()
            
            VStack() {
                
                TopBarView { buttonType in
                    
                    switch buttonType {
                    case .nfcScanner:
                        musicApi.scanMusicTag()
                        break;
                        
                    case .settings:
                        break;
                        
                    case .gifts:
                        break;
                    }
                    
                }
                
                //From
                HStack() {
                    
                    Spacer()
                    
                    Text("From Joshua...")
                        .font(.custom(style: .lillyMae, size: 45))
                        .foregroundStyle(Color.custom(.white))
                    
                    Spacer()
                    
                    Button(action: {
                        
                        musicApi.isSongLiked = true;
                        
                    }){
                        
                        Image.symbol(musicApi.isSongLiked ? .heartFill : .heart, size: .medium, color: .red)
                    }
                    
                    Spacer()
                    
                }
                .padding(.bottom, 10)
                
                
                //Carrousel
                if musicApi.track != nil {
                    
//                    CarrouselView(song: musicApi.track)
//                        .frame(maxHeight: 480)
                }
                
                
                Spacer()
                
                //Audo waves
                
                AudioWavesView(isPlaying: $musicApi.isPlaying)
                    .padding(.bottom, 10)
                
                Spacer()
                
                //Time Track
                
                TimeTrackView(currentTime: $musicApi.currentTime, totalTime: $musicApi.totalTime, isDragging: $musicApi.isDragging)
                    .padding(.horizontal, 30);
                
                Spacer()
                
                //Controls
                
                HStack(spacing: 50) {
                    
                    Button(action:{
                        
//                        viewModel.restart();
                        
                    }) {
                        
                        Image.symbol(.restartAudio,size: .medium,  color: .white)
                    }
                    
                    Button(action:{
                        
                        musicApi.togglePlayPause();
                        
                    }) {
                        
                        ZStack {
                            
                            let _ = print("isPlaying: \(musicApi.isPlaying)");
                            
                            //Play button
                            Image.symbol(.playAudio, size: .large, color: .white)
                                .scaleEffect(musicApi.isPlaying ? 0.3 : 1.0)
                                .opacity(musicApi.isPlaying ? 0 : 1)
                            
                            //Pause button
                            Image.symbol(.pauseAudio, size: .large, color: .white)
                                .scaleEffect(musicApi.isPlaying ? 1.0 : 0.1)
                                .opacity(musicApi.isPlaying ? 1 : 0)
                        }
                    }
                    
                    Button(action:{
                        
//                        viewModel.toggleInfinity();
                        
                    }) {
                        
                        Image.symbol(.infinity,size: .medium,  color: musicApi.isInfinity ? .red : .white);
                    }
                }
                
                Spacer()
                
            }
            
            if openedWithNFC {
                
                //Show animation
                
                GradientBackgroundView()
                    .opacity(musicApi.platform == .notDetermined  ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5).delay(0.5), value: musicApi.platform != .notDetermined )
                
                LineScalePulseOutRapid()
                    .foregroundStyle(Color.custom(.white))
                    .frame(width: 80)
                    .opacity(musicApi.platform == .notDetermined  ? 1 : 0)
                    .transition(.scale) // Adds a scale transition for when it hides
                    .animation(.easeInOut(duration: 0.5).delay(0.5), value: musicApi.platform != .notDetermined )
                
                
            }else{
                
                if musicApi.platform == .notDetermined {
                    
                    Text("Checking platform");
                    
                }else if musicApi.platform == .notSupported {
                    
                    EmptyStateView(title: "Oh no!",
                                   subtitle: "You need an Apple Music or Spotify subscription to use this feature.", buttonText: "Get trial of Apple Music",
                                   imageIcon: .ghost)
                    
                }else{
                    
                    ScanView(musicApi: $musicApi)
                }
                    

            }
            
        }
        .onAppear() {
            
            //Determine if music subscription is available
            musicApi.determinePlatform();
            
        }
        .onOpenURL { url in
            
            //This one will be called when the app is not open
            
            musicApi.setSpotifyAccessToken(from: url)
            musicApi.handleIncomingURL(url: url)
        }
        .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
            
            //This will be called if the app is open and a code is scanned
            
            guard let url = userActivity.webpageURL else {
                return
            }
            
            musicApi.handleIncomingURL(url: url);
        }
        .onDisappear {
//            musicApi.stopTimer() // Stop the timer when the view disappears
        }
    }
}

#Preview {
    MusicPlayerView()
}

