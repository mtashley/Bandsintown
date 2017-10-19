//
//  NetManager.swift
//  Bandsintown
//
//  Created by Ashley on 10/18/17.
//  Copyright © 2017 mtashley. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    
    private let dataManager: DataManager = DataManager.sharedInstance
    
    // MARK: Private - Primary Request
    
    fileprivate func requestURL(_ encodedURL: String, success:@escaping (JSON) -> Void) {
        
        Alamofire.request(encodedURL).responseJSON { (responseObject) -> Void in
            
            // Response
            print(responseObject)
            
            // Success
            if responseObject.result.isSuccess {
                let jsonObject = JSON(responseObject.result.value!)
                success(jsonObject)
            }
        
            // Failure
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                print(error)
            }
        }
    }
    
    // MARK: Public - API Request Wrappers
        func requestArtists(from searchString: String) {
    
        let url = Utilities.cleanURL(from: searchString, requestType: .RT_ARTIST_SEARCH)
        
        let completionHandler = { jsonObject in
            self.dataManager.loadSearchResults(jsonObject)
        }
        
        requestURL(url, success: completionHandler)
    }
    
    func requestArtistDetails(from artistName: String) {
        
        let url = Utilities.cleanURL(from: artistName, requestType: .RT_ARTIST_DETAIL)
        
        let completionHandler = { jsonObject in
            self.dataManager.loadArtistDetails(jsonObject)
        }
        
        requestURL(url, success: completionHandler)
    }
}
