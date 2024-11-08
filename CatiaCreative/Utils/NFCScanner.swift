//
//  NFCScanner.swift
//  CatiaCreative
//
//  Created by Joaquin Pereira on 10/25/24.
//

import CoreNFC
import Foundation

typealias NFCScannedBlock = (_ url:URL) -> Void;

class NFCScanner:NSObject {
    
    var session: NFCNDEFReaderSession?
    var tagScannedBlock:NFCScannedBlock?
    
    func beginScanning() {
        
        let session = NFCNDEFReaderSession(delegate: self, queue: .main, invalidateAfterFirstRead: true)
        session.alertMessage = "Hold your device near an NFC tag."
        session.begin()
    }
}

extension NFCScanner:NFCNDEFReaderSessionDelegate {
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: any Error) {
        
        print(error.localizedDescription)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
        for message in messages {
            for record in message.records {
                if let value = String(data: record.payload, encoding: .ascii) {
                    print(value)
                    
                    DispatchQueue.main.async {
                        
                        var trimmedContent = value.trimmingCharacters(in: .controlCharacters)
                        
                        if !trimmedContent.hasPrefix("https") {
                            
                            trimmedContent.insert(contentsOf: "https://", at: trimmedContent.startIndex)
                        }
                        
                        if let url = URL(string: trimmedContent) {
                            self.tagScannedBlock?(url);
                        }
                        else {
                            print("Invalid NFC Tag");
                        }
                    }
                }
            }
        }
    }
}
