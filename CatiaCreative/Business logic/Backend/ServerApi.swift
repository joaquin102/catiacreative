//
//  serverApi.swift
//  CatiaMusic
//
//  Created by Joaquin Pereira on 10/2/24.
//
import ParseSwift

class ServerApi {
    
    //MARK: - SONGS INFO
    
    static func getSong(songId:String) async -> CatiaSong? {
        
        do {
            
            let query = CatiaSong.query();
            let songs = try await query.find()
            
            print(songs.count);
            
        }catch {
            
        }

        return nil;
    }
    
    
    //MARK: - USER GEOLOCATION
    
    static func getSongId(hash:String) async -> String? {
        
        do {
            
            let query = Scan.query();
            let scans = try await query.where(equalTo(key: "hash", value: hash)).find();
            
            return scans.count > 0 ? scans[0].songId : nil
            
        } catch {
            
            print("Error getting song id: " + error.localizedDescription);
        }
        
        return nil;
    }
    
}


