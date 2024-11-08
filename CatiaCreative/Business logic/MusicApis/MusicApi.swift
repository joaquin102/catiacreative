//
//  MusicApi.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 11/3/24.
//
import SwiftUI
import MusicKit

enum Platform {
    
    case appleMusic
    case spotify
    case notSupported
    case notDetermined
}

@Observable
class MusicApi {
    
    var authStatus: MusicAuthorization.Status = .notDetermined;
    var platform: Platform = .notDetermined;
    
    var appleMusicKit = AppleMusicKit();
    var spotifyKit = SpotifyKit();
    var scanner = NFCScanner();
    
    var track:Track?
    var totalTime: Double = 0
    var currentTime: Double = 0
    var isPlaying = false;
    var isSongLiked = false;
    var isDragging = false
    var isInfinity = false;
//    
//    //Apple music
//    var musicPlayer = ApplicationMusicPlayer.shared;
    
    //Spotify
    
    
    
    
//    var timerCancellable: AnyCancellable?
//    var playbackCancellable: AnyCancellable?;
    
    //MARK: - INIT
    
    init() {
        
        listeners();
    }
    
    
    //MARK: - PLATFORMS
    
    func determinePlatform() {
        
        Task {
            
            if platform == .notDetermined || platform == .notSupported {
                
                if await appleMusicKit.isSubscribed() {
                    
                    self.platform = .appleMusic;
                    
                }else if spotifyKit.isSpotifyAppInstalled() {
                    
                    self.platform = .spotify;
                    
                }else {
                    
                    self.platform = .notSupported;
                }
                
            }
        }
    }
    
    
    //MARK: - PLAY
    
    func playSong(id: String, from: TimeInterval?) async {
        
        if platform == .appleMusic {
            
            let success = await appleMusicKit.playWithSongId(with: id, time: from);
            self.track = appleMusicKit.track;
            
            if !success {
                
                //Potential error here
            }
        }
        
        
        if platform == .spotify {
            
            //Check if we are connected to spotifyKit
            if !spotifyKit.appRemote!.isConnected {
                spotifyKit.connect(songId: id)
                
            }else{
                
                spotifyKit.playSong(id: id) //3c8iiZGfEammKJuWTErE5x
            }
        }
    }
    
    
    func listeners() {
        
        appleMusicKit.isPlayingBlock = { [weak self] isPlaying in
            
            DispatchQueue.main.async {
                
                self?.isPlaying = isPlaying;
            }
        }
        
        spotifyKit.isPlayingBlock = { [weak self] isPlaying in
            
            DispatchQueue.main.async {
                
                self?.isPlaying = isPlaying;
            }
        }
    }
    
    
    
    //MARK: - SONG CONTROL
    
    func resume() {
        
        Task {
            
            if platform == .appleMusic {
                
                await appleMusicKit.resume()
            }
            
            
            if platform == .spotify {
                
                spotifyKit.resume()
            }
        }
    }
    
    func pause() {
        
        if platform == .appleMusic {
            
            appleMusicKit.pause()
        }
        
        
        if platform == .spotify {
            
            spotifyKit.pause()
        }
    }
    
    func togglePlayPause() {
        
        Task {
            if platform == .appleMusic {
                
                appleMusicKit.togglePlayPause();
            }
            
            
            if platform == .spotify {
                
                spotifyKit.togglePlayPause()
            }
        }
    }
    
    
    //MARK: - NFC MUSIC TAGS
    
    func scanMusicTag() {
        
        scanner.beginScanning();
    }

    func listenToNFC() {
        
        scanner.tagScannedBlock = { [weak self] url in
            
            self?.handleIncomingURL(url: url);
        }
    }
    
    
    //MARK: - UNIVERSAL LINK HANDLE
    
    func handleIncomingURL(url: URL) {
        
        Task {
         
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            
            var songId: String?
            var startingTime: TimeInterval?
            
            if components?.path == "/play", let queryItems = components?.queryItems {
                
                if let id = queryItems.first(where: { $0.name == "songid" })?.value {
                    
                    songId = id
                }
                
                if let seconds = queryItems.first(where: { $0.name == "starting" })?.value {
                    
                    startingTime = TimeInterval(Int(seconds) ?? 0);
                }
                
                if let songId = songId {
                    
                    await self.playSong(id: songId, from: startingTime);
                    return;
                }
                
                //Show error
            }
            
            //Show error
        }

    }
    
    //MARK: - SPOTIFY
    
    func setSpotifyAccessToken(from url: URL) {
        
        //This one is called when spotify opens this app back
        
        spotifyKit.setAccessToken(from: url);
    }
}
