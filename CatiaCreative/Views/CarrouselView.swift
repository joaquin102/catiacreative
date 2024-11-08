
//  CarrouselView.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 10/23/24.
//

import SwiftUI
import MusicKit
import MarqueeText
import Combine

struct CarrouselView: View {
    
    @State var track: Track?
    @State var song: Song?
    @State private var selectedTab = 0
    private let tabCount = 5 // Number of tabs in the carousel
    private let delay = 5.0 // Delay in seconds
    @State private var timer: AnyCancellable? // Timer subscription
    @State private var isAutoScrolling = false // Flag to track if it's auto-scrolling
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            Group {
                TrackArtworkView(song: song)
                    .tag(0)
                PolaroidView()
                    .tag(1)
                PolaroidView()
                    .tag(2)
                PolaroidView()
                    .tag(3)
                PolaroidView()
                    .tag(4)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
        }
        .tabViewStyle(PageTabViewStyle())
        .onAppear {
            startAutoScroll()
        }
        .onDisappear {
            timer?.cancel() // Stop the timer when the view disappears
        }
        .onChange(of: selectedTab) { _,_ in
            // Only stop auto-scrolling if the change wasn't caused by the timer
            if !isAutoScrolling {
                stopAutoScroll()
            }
        }
    }
    
    // Start the timer for auto-scrolling
    private func startAutoScroll() {
        timer = Timer.publish(every: delay, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                withAnimation {
                    isAutoScrolling = true // Set the flag before the auto-scroll
                    selectedTab = (selectedTab + 1) % tabCount // Loop back to the first tab after reaching the last
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isAutoScrolling = false // Reset the flag shortly after the auto-scroll
                }
            }
    }
    
    // Stop the timer manually
    private func stopAutoScroll() {
        timer?.cancel()
        timer = nil // Clear the timer
    }
}

#Preview {
    CarrouselView(song: nil)
}

struct TrackArtworkView: View {
    
    @State var song:Song?;
    
    var body: some View {
        VStack() {
            
            if let song = song {
                
                if let artworkURL = song.artwork?.url(width: Int(UIScreen.screenWidth), height: Int(UIScreen.screenWidth)) {
                    
                    AsyncImage(url: artworkURL) { image in
                        //Show generic cover
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .clipShape(.rect(cornerRadius: 30))
                            .shadow(radius: 5) // Optional shadow for effect
                            .containerRelativeFrame(.horizontal) {  dimension, _ in
                                dimension * 0.8
                            }
                            .padding(.bottom, 10)
                        
                    } placeholder: {
                        ProgressView()
                    }
                    
                    VStack(spacing: 10) {
                        
                        //Song name
                        MarqueeText(
                            text: song.title,
                            font: .custom(style: .gilroyBold, size: .large),
                            leftFade: 16,
                            rightFade: 16,
                            startDelay: 3
                        )
                        .foregroundStyle(Color.custom(.white))
                        .padding(.horizontal, 15)
                        
                        Text(song.artistName)
                            .font(.custom(style: .gilroyRegular, size: .medium))
                            .foregroundStyle(Color.custom(.white))
                    }
                    
                }
                
            }else{
                
                //                Show generic cover
                Image("AlbumCover")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 30))
                    .shadow(radius: 5)
                    .containerRelativeFrame(.horizontal) {  dimension, _ in
                        dimension * 0.8
                    }
                    .padding(.bottom, 10)
                
                
                //                Song name
                VStack(spacing: 10) {
                    
                    VStack(spacing: 10) {
                        MarqueeText(
                            text: "Heroes (We Could be) [Feat. Tove Lo]",
                            font: .custom(style: .gilroyBold, size: .large),
                            leftFade: 16,
                            rightFade: 16,
                            startDelay: 3
                        )
                        .foregroundStyle(Color.custom(.white))
                        .padding(.horizontal, 15)
                        
                        Text("Taylor Swift")
                            .font(.custom("gilroyRegular", size: 16))
                            .foregroundColor(Color.white)
                    }
                }
            }
            
        }
    }
}

struct PolaroidView: View {
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Rectangle()
                .fill(Color.white)
                .shadow(radius: 5) // Optional shadow for effect
                .containerRelativeFrame([.horizontal, .vertical]) { length, axis in
                    
                    if axis == .horizontal {
                        return UIScreen.main.bounds.width * 0.8
                        
                    }else{
                        return UIScreen.main.bounds.width
                    }
                    
                    
                }
            
            VStack {
                
                Color.clear
                    .overlay (
                        Image("AlbumCover")
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                    )
                    .clipped()
                    .frame(width: UIScreen.main.bounds.width * 0.73, height: UIScreen.main.bounds.width * 0.73) // 60% of screen width for the image
                    .padding(.top, ((UIScreen.main.bounds.width * 0.8) - UIScreen.main.bounds.width * 0.73) / 2) // Space between the top of the rectangle and the image
                
                
                TypeWriterView(finalText: "Happy Birthday!")
                    .font(.custom(style: .breathing, size: .large))
            }
            
            
        }
        
    }
}


struct TypeWriterView: View {
    
    @State private var text: String = ""
    @State var finalText: String = "" // Example text
    @State private var task: Task<Void, Never>? // Store the Task so it can be canceled
    
    var body: some View {
        VStack(spacing: 16.0) {
            Text(text)
        }
        .onAppear {
            startTypewriterEffect()
        }
        .onDisappear {
            // Cancel the task when the view disappears
            task?.cancel()
        }
    }
    
    func startTypewriterEffect() {
        // Cancel any existing task to avoid overlapping
        task?.cancel()
        
        // Start a new task for the typewriter effect
        task = Task {
            await typeWriter()
        }
    }
    
    func typeWriter() async {
        text = ""
        for (_, character) in finalText.enumerated() {
            // Check for cancellation before each delay
            try? Task.checkCancellation()
            text.append(character)
            
            // Add delay to simulate typing
            try? await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
            
            // Check again to ensure the task is not canceled after the delay
            if Task.isCancelled {
                break
            }
        }
    }
}

