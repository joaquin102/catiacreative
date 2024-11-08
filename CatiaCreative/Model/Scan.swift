//
//  Scan.swift
//  CatiaMusic
//
//  Created by Joaquin Pereira on 10/2/24.
//
import ParseSwift
import Foundation

struct Scan: ParseObject{
    
    enum CodingKeys: String, CodingKey {
        case originalData;
        case objectId;
        case createdAt;
        case updatedAt;
        case ACL;
        case zip;
        case countryCode;
        case org;
        case pixelRatio;
        case isp;
        case ip;
        case lon;
        case lat;
        case isMobile;
        case asProvider = "as";
        case screenWidth;
        case screenHeight;
        case region;
        case ipHash;
        case country;
        case timezone;
        case locale;
        case userInfoHash;
        case songId;
        case hash;
    }
    
    //Required
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseSwift.ParseACL?
    
    //Custom
    var zip:String?
    var countryCode:String?
    var org:String?
    var pixelRatio:Int?
    var isp:String?
    var ip:String?
    var hardwareConcurrency:String?
    var lon:Double?
    var lat:Double?
    var isMobile:Bool?
    var asProvider:String?
    var screenWidth:Int?
    var screenHeight:Int?
    var region:String?
    var ipHash:String?
    var country:String?
    var timezone:String?
    var locale:String?
    var userInfoHash:String?
    var deviceMemory:String?
    var connectionType:String?
    
    var songId: String?
    var hash: String?
    
}
