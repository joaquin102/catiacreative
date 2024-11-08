//
//  CatiaCreativeApp.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 10/10/24.
//

import SwiftUI
import ParseSwift

@main
struct CatiaCreativeApp: App {
    
    init() {
        ParseSwift.initialize(applicationId: "d6e1f9944d12463be74dd80a484db7cb", serverURL: URL(string: "https://server.catiacreative.com/parse")!)
    }
    
    var body: some Scene {
        WindowGroup {
            MusicPlayerView()
        }
    }
}
