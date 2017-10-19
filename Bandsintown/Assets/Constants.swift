//
//  Constants.swift
//  Bandsintown
//
//  Created by Ashley on 10/13/17.
//  Copyright © 2017 mtashley. All rights reserved.
//

enum ViewState {
    case VS_Artists
    case VS_Favorites
}

enum ArtistFavoriteState {
    case AFS_FAVORITE_ON
    case AFS_FAVORITE_OFF
}

enum RequestType {
    case RT_ARTIST_SEARCH
    case RT_ARTIST_DETAIL
    case RT_IMAGE_THUMB
    case RT_IMAGE_LARGE
}

struct Constants {
    static let BASE_URL_ARTIST_SEARCH = "https://news.bandsintown.com/searchArtists?search="
    static let BASE_URL_ARTIST_DETAIL_PREFIX = "https://rest.bandsintown.com/artists/"
    static let BASE_URL_ARTIST_DETAIL_SUFFIX = "?app_id=1"
    static let BASE_URL_IMAGE_THUMB = "https://s3.amazonaws.com/bit-photos/thumb/"
    static let BASE_URL_IMAGE_LARGE = "https://s3.amazonaws.com/bit-photos/large/"
    static let DEFAULT_IMG_TYPE = ".jpeg"
    static let NAV_TITLE_ARTISTS = "Artists"
    static let NAV_TITLE_FAVORITES = "Favorites"
    
}
