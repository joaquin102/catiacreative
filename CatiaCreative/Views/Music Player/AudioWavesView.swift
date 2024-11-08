//
//  AudioWavesView.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 10/23/24.
//
import SwiftUI
import Combine
import Charts

struct AudioWavesView: View {
    
    //Audio waves graph
    @Binding var isPlaying:Bool;
    @State var data: [Float] = Array(repeating: 0, count: Constants.barAmount)
        .map { _ in Float.random(in: 1 ... Constants.magnitudeLimit) }
    
    // Random timer handling
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        Chart(Array(data.enumerated()), id: \.0) { index, magnitude in
            BarMark(
                x: .value("", String(index)),
                y: .value("", magnitude)
            )
            .foregroundStyle(
                Color(hex: "A8A5FF")
            )
        }
        //                        .onReceive(timer, perform: updateData)
        .chartYScale(domain: 0 ... Constants.magnitudeLimit)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .frame(height: 50)
        .padding(.horizontal, 40)
        .onChange(of: isPlaying, { oldValue, newValue in
            if newValue {
                startRandomTimer() // Start the timer when isPlaying becomes true
            } else {
                cancellable?.cancel() // Stop the timer when isPlaying becomes false
            }
        })
    }
        
    
    
    func updateData() {
        if isPlaying {
            withAnimation(.easeOut(duration: 0.08)) {
                data = Array(repeating: 0, count: Constants.barAmount).map { _ in
                    Float.random(in: 1...Float.random(in: 1...Constants.magnitudeLimit))
                }
            }
        }
        
        // Restart the timer with a new random interval after each update
        startRandomTimer()
    }
    
    // Function to start the timer with random interval
    func startRandomTimer() {
        let randomInterval = Double.random(in: 0.09...0.1) // Random interval between 0.01 and 0.05 seconds
        
        cancellable?.cancel() // Cancel any existing timer
        
        // Set up a new timer with the new random interval
        cancellable = Timer.publish(every: randomInterval, on: .main, in: .common)
            .autoconnect()
            .first() // This will make the timer fire only once
            .sink { _ in
                updateData() // Call updateData, which will restart the timer with a new random interval
            }
    }
}
