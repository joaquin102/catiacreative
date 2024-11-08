//
//  AppleMusicKit.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 10/28/24.
//

import SwiftUI
import Foundation
import MusicKit
import Combine


class AppleMusicKit {

    var authStatus: MusicAuthorization.Status = .notDetermined;
    var musicPlayer = ApplicationMusicPlayer.shared;
    
    var isAuthorized:Bool?
    
    var totalTime: Double = 0
    var currentTime: Double = 0
    
    var isDragging = false
    var isInfinity = false;
    var timerCancellable: AnyCancellable?
    var playbackCancellable: AnyCancellable?;
    
    var scanner = NFCScanner();
    
    var track:Track?
    
    private var isPlaying = false {
        didSet {
            self.isPlayingBlock?(self.isPlaying);
        }
    }
    
    public var isPlayingBlock:isPlayingBlock?
    
    init() {

    }
    
    //MARK: - AUTH & SUBSCRIPTION
    
    func requestAuthorization() async -> Bool {
        
        let status = await MusicAuthorization.request()
        
        switch status{
        case .authorized:
            print("Authorized");
        case .notDetermined:
            print("Error getting Apple Music Authorization: Not determined")
        case .restricted:
            print("Error getting Apple Music Authorization: Restricted")
        case .denied:
            print("Error getting Apple Music Authorization: Denied")
        default:
            print("Error getting Apple Music Authorization: Unknown (New case)")
        }
        
        authStatus = status;
        
        return status == .authorized;
    }
    

    //MARK: - SUBSCRIPTION
    
    func isSubscribed() async -> Bool {
        
        do {
            
            //Check for authorization
            self.isAuthorized = await requestAuthorization();
            
            if isAuthorized ?? false {
                
                let subscription = try await MusicSubscription.current
                return subscription.canPlayCatalogContent
                
            }else{
                
                //At this point we can check for spotify. If not available then indicate that music auth is requested
                return false;
            }
            
        }catch {
            
            print("Error checking for Apple Music subscription: \(error)");
        }
        
        return false;
        
    }
    
    //MARK: - APPLE MUSIC
    
    private func getSong(with id: MusicItemID) async -> Song? {
        
        do {
            
            let request = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: id)
            let response = try await request.response()
            
            return response.items.first;
            
        }catch {
            
            print("Unable to get song with id: \(id)");
        }
        
        return nil;
        
    }
    
    //MARK: - SONG CONTROLS
    
    public func playWithSongId(with id: String, time: TimeInterval? = nil) async -> Bool {
        
        listenToPlaybackState();
        
        do {
            
            if let song = await getSong(with: MusicItemID(id)) {
                
                if musicPlayer.queue.entries.count == 0 {
                    
                    musicPlayer.queue = [song];
                    try await musicPlayer.prepareToPlay()
                    
                }else{
                    
                    try await musicPlayer.queue.insert(song, position: .afterCurrentEntry);
                    try await musicPlayer.skipToNextEntry();
                }
                
                if let time = time {
                    musicPlayer.playbackTime = time //Time format in seconds ex: 90 seconds
                }
                
                
                self.totalTime = song.duration ?? 0;
                startTimer();
                
                try await musicPlayer.play()
                
                self.track = Track(song: song);
                
                return true;
                
            }else{
                
                //Unable to find song with that id, show empty state related
                
                return false;
                
            }
            
        } catch {
            print("Failed to play song: \(error)")
        }
        
        return false;
    }
    
    func resume() async {
        
        do {
            try await self.musicPlayer.play();
            
        }catch {
            
            print("Unable to remsume Apple music track")
        }
        
    }
    
    func pause() {
        
        self.musicPlayer.pause();
    }
    
    func restart() async {
        
        let musicPlayer = ApplicationMusicPlayer.shared
        musicPlayer.restartCurrentEntry();
        
        await resume();
    }
    
    func togglePlayPause() {
        
        Task {
            if self.isPlaying {
                self.musicPlayer.pause();
                
            }else{
                try await self.musicPlayer.play();
            }
        }
    }
    
    func playInfinity() {
        Task {
            do {
                ApplicationMusicPlayer.shared.playbackTime = 0 // Set playback time to the beginning
                try await ApplicationMusicPlayer.shared.play()
            } catch {
                print("Failed to restart song: \(error)")
            }
        }
    }
    
    func toggleInfinity() {
        
        self.isInfinity.toggle();
    }
    
    
    //MARK: - LISTENERS
    
    func listenToPlaybackState() {
        
        playbackCancellable = ApplicationMusicPlayer.shared.state.objectWillChange
            .dropFirst() // Ignore the first value (current state)
            .sink { [weak self] in
                let newState = ApplicationMusicPlayer.shared.state.playbackStatus
                
                self?.isPlaying = (newState == .playing)
                
            }
    }
    
    //MARK: - TIMERS
    
    func startTimer() {
        
        timerCancellable = Timer.publish(every: 1.0 / 30.0, on: .main, in: .common) // Update 30 times per second
            .autoconnect()
            .sink { _ in
                
                guard !self.isDragging else { return } // Don't update if the user is dragging
                self.currentTime = ApplicationMusicPlayer.shared.playbackTime
            }
    }
    
    
    func stopTimer() {
        timerCancellable?.cancel()
    }
    
}
