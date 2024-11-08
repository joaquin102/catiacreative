//
//  SpotifyController.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 10/28/24.
//

import SwiftUI
import SpotifyiOS
import Combine

@Observable
class SpotifyKit: NSObject {
     
    var track:Track?
    var accessToken: String? = nil
    var appRemote: SPTAppRemote?
    
    var currentPlaybackPosition: TimeInterval = 0
    var trackDuration: TimeInterval = 0
    private var playbackTimer: Timer?
    
    private var connectCancellable: AnyCancellable?
    private var disconnectCancellable: AnyCancellable?
    
    private var isPlaying = false {
        didSet {
            self.isPlayingBlock?(self.isPlaying);
        }
    }
    
    public var isPlayingBlock:isPlayingBlock?
    
    
//    @Published var currentTrackURI: String?
//        @Published var currentTrackName: String?
//        @Published var currentTrackArtist: String?
//        @Published var currentTrackDuration: Int?
//        @Published var currentTrackImage: UIImage?

    
    var configuration = SPTConfiguration(
        clientID: "8e02283303804cf38deb4e4b940ba94a",
        redirectURL: URL(string:"spotify-ios-quick-start://spotify-login-callback")!
    )
    
    //MARK: - INIT
    
    
    override init() {
        super.init()
        
        connectCancellable = NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
//                self.connect()
            }
        
        disconnectCancellable = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
//                self.disconnect()
            }
        
        //Setup appRemote to interact with spotify
        
        let configuration = SPTConfiguration (
            clientID: "8e02283303804cf38deb4e4b940ba94a",
            redirectURL: URL(string:"spotify-ios-quick-start://spotify-login-callback")!
        );
        
        self.appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        self.appRemote?.connectionParameters.accessToken = self.accessToken
        self.appRemote?.delegate = self
    }
    
    //MARK: - SUBSCRIPTION
    
    func isSpotifyAppInstalled() -> Bool {
        guard let spotifyURL = URL(string: "spotify://") else {
            return false
        }
        return UIApplication.shared.canOpenURL(spotifyURL)
    }
    
    //MARK: - APP LIFE CYCLE
    
    func connect(songId:String?) {
        guard let _ = self.appRemote?.connectionParameters.accessToken else {
            self.appRemote?.authorizeAndPlayURI(songId == nil ? "" : "spotify:track:\(songId!)")
            return
        }
        
        appRemote?.connect()
    }

    func disconnect() {
        if appRemote?.isConnected ?? false {
            appRemote?.disconnect()
        }
    }
    
    func setAccessToken(from url: URL) {
        
        //This one is called when spotify opens this app back
        
        let parameters = appRemote?.authorizationParameters(from: url)
        
        if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote?.connectionParameters.accessToken = accessToken
            self.accessToken = accessToken
            
            self.connect(songId: nil);
            
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print(errorDescription)
        }
    }
    
    //MARK: - TRACK CONTROL
    
    // Play a specific track
    func playSong(id: String) {
        appRemote?.playerAPI?.play("spotify:track:\(id)", callback: { result, error in
            if let error = error {
                print("Error playing track: \(error.localizedDescription)")
            } else {
                print("Playing spotify track: \(id)")
            }
        })
    }

    // Pause playback
    func pause() {
        appRemote?.playerAPI?.pause({ result, error in
            if let error = error {
                print("Error pausing playback: \(error.localizedDescription)")
            } else {
                print("Playback paused")
            }
        })
    }

    // Resume playback
    func resume() {
        appRemote?.playerAPI?.resume({ result, error in
            if let error = error {
                print("Error resuming playback: \(error.localizedDescription)")
            } else {
                print("Playback resumed")
            }
        })
    }

    // Toggle play/pause based on current state
    func togglePlayPause() {
        appRemote?.playerAPI?.getPlayerState({ result, error in
            if let error = error {
                print("Error fetching player state: \(error.localizedDescription)")
                return
            }
            
            if let playerState = result as? SPTAppRemotePlayerState {
                playerState.isPaused ? self.resume() : self.pause()
            }
        })
    }
    
    //MARK: - TIMER
    
    // Start a timer to increment playback position
    private func startTimer() {
        stopTimer() // Ensure any previous timer is invalidated
        playbackTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.currentPlaybackPosition += 1
            if self.currentPlaybackPosition >= self.trackDuration {
                self.stopTimer() // Stop timer when track ends
            }
        }
    }

    // Stop the timer
    private func stopTimer() {
        playbackTimer?.invalidate()
        playbackTimer = nil
    }
    
    
    //MARK: - IMAGE
    
    func fetchImage() {
        appRemote?.playerAPI?.getPlayerState { (result, error) in
            
            if let error = error {
                print("Error getting player state: \(error)")
                
            } else if let playerState = result as? SPTAppRemotePlayerState {
                
                self.appRemote?.imageAPI?.fetchImage(forItem: playerState.track, with: CGSize(width: 300, height: 300), callback: { (image, error) in
                    if let error = error {
                        
                        print("Error fetching track image: \(error.localizedDescription)")
                        
                    } else if let image = image as? UIImage {
                        
                        print();
                        
                        DispatchQueue.main.async {
                            
                            print();
//                            self.currentTrackImage = image
                        }
                    }
                })
            }
        }
    }
}

extension SpotifyKit: SPTAppRemoteDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote = appRemote
        self.appRemote?.playerAPI?.delegate = self
        self.appRemote?.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            
        })
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("failed")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("disconnected")
    }
}

extension SpotifyKit: SPTAppRemotePlayerStateDelegate {
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {

        //Assign track if needed
        if track == nil || (self.track?.spotifyTrack?.uri != playerState.track.uri) {
            
            self.track = Track(spotifyTrack: playerState.track);
            fetchImage()
        }

        //Keep timer up to date
        currentPlaybackPosition = TimeInterval(playerState.playbackPosition) / 1000
        trackDuration = TimeInterval(playerState.track.duration) / 1000

        if playerState.isPaused {
            stopTimer()
        } else {
            startTimer()
        }
    }

}

