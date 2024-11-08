//
//  CatiaSong.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 10/23/24.
//
import ParseSwift
import Foundation

struct CatiaSong: ParseObject {
    
    static var className: String {
        "Song"
    }
    
    //Required
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseSwift.ParseACL?
    
    //Custom
    var songId:String?
    var sender:String?
    var startingFrom:Int?
    var liked:Bool?
    
}
