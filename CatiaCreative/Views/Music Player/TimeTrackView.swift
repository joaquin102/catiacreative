//
//  TImeTrack.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 10/25/24.
//

import SwiftUI
import MusicKit

struct TimeTrackView: View {
    
    @Binding var currentTime: Double;
    @Binding var totalTime: Double;
    @Binding var isDragging: Bool;
    
    
    var body: some View {
        
        if currentTime > 0 && totalTime > 0 {
            
            //Track
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Gray track (the total track)
                    Capsule()
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 8)
                    
                    // White track (the current progress)
                    Capsule()
                        .fill(Color.white)
                        .frame(width: CGFloat(currentTime / totalTime) * geometry.size.width, height: 8)
                    
                    // Draggable circle at the end of the current progress
                    Circle()
                        .fill(Color.white)
                        .frame(width: 20, height: 20)
                        .offset(x: CGFloat(currentTime / totalTime) * geometry.size.width - 10)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    isDragging = true // Flag to indicate drag in progress
                                    let dragPosition = min(max(0, value.location.x), geometry.size.width)
                                    currentTime = Double(dragPosition / geometry.size.width) * totalTime
                                }
                                .onEnded { _ in
                                    // When the drag ends, update the player time
                                    ApplicationMusicPlayer.shared.playbackTime = currentTime
                                    isDragging = false // Drag completed
                                }
                        )
                }
            }
            .frame(height: 20) // Height of the track
            
            // Time labels for current and remaining time
            HStack {
                Text(formatTime(currentTime)) // Current time label
                    .font(.custom(style: .gilroyRegular, size: .xSmall))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(formatTime(totalTime - currentTime)) // Remaining time label
                    .font(.custom(style: .gilroyRegular, size: .xSmall))
                    .foregroundColor(.white)
            }
        }
    }
    
    
    // Helper function to format time in mm:ss
    func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
