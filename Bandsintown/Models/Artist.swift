//
//  Artist.swift
//  Bandsintown
//
//  Created by Ashley on 10/14/17.
//  Copyright © 2017 mtashley. All rights reserved.
//

import Foundation
import SwiftyJSON

@objc class Artist : NSObject {

    @objc var name: String
    @objc var media_id: Int
    @objc var thumb_url: String
    @objc var tracker_count: Int
    @objc var  upcoming_event_count: Int

    init(name: String, media_id: Int? = 0, thumb_url: String? = "", tracker_count: Int? = 0, upcomingEventCount: Int? = 0) {
        self.name = name
        self.media_id = media_id!
        self.thumb_url = thumb_url!
        self.tracker_count = tracker_count!
        self.upcoming_event_count = upcomingEventCount!
    }

    init(jsonObject: JSON) {
        self.name = jsonObject["name"].string!
        self.media_id = 0
        self.thumb_url = jsonObject["thumb_url"].string!
        self.tracker_count = jsonObject["tracker_count"].int!
        self.upcoming_event_count = jsonObject["upcoming_event_count"].int!
    }
}
