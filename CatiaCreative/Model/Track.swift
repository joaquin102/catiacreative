//
//  Track.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 10/28/24.
//
import SwiftUI
import Foundation
import MusicKit
import SpotifyiOS

struct Track {
    
    var artistName:String
    var title:String
    var imageUrl:URL?;
    var id:String?
    
    var appleMusicSong:Song? //Apple music
    var spotifyTrack:SPTAppRemoteTrack?
    
    
    init(song:Song) {
        
        self.artistName = song.artistName;
        self.title = song.title;
        self.imageUrl = song.artwork?.url(width: Int(UIScreen.screenWidth), height: Int(UIScreen.screenWidth))
        self.id = song.id.rawValue;
        
        self.appleMusicSong = song;
    }
    
    
    init(spotifyTrack:SPTAppRemoteTrack){
        
        self.artistName = spotifyTrack.artist.name;
        self.title = spotifyTrack.name;
        self.id = spotifyTrack.uri;
        
        self.spotifyTrack = spotifyTrack;
    }
}
