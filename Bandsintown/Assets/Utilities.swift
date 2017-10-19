//
//  Utilities.swift
//  Bandsintown
//
//  Created by Ashley on 10/18/17.
//  Copyright © 2017 mtashley. All rights reserved.
//

import Foundation

class Utilities {
    
    static func cleanURL(from input: Int, requestType: RequestType) -> String {
        return cleanURL(from: String(input), requestType: requestType)
    }
    
    static func cleanURL(from input: String, requestType: RequestType) -> String {
        
        var formattedURL = ""
        
        if requestType == .RT_ArtistSearch {
            formattedURL += Constants.BASE_URL_ARTIST_SEARCH
            formattedURL += input
        }
            
        else if requestType == .RT_ArtistDetail {
            formattedURL += Constants.BASE_URL_ARTIST_DETAIL_PREFIX
            formattedURL += input
            formattedURL += Constants.BASE_URL_ARTIST_DETAIL_SUFFIX
        }
        
        else if requestType == .RT_IMAGE_THUMB {
            formattedURL += Constants.BASE_URL_IMAGE_LARGE
            formattedURL += input
            formattedURL += Constants.DEFAULT_IMG_TYPE
        }
        
        return encodeURL(formattedURL)
    }
    
    static func encodeURL(_ url: String) -> String {
        return url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}
