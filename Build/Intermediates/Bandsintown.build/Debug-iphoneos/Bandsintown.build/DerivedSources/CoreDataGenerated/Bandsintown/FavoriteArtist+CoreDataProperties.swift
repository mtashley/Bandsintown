//
//  FavoriteArtist+CoreDataProperties.swift
//  
//
//  Created by Ashley on 10/20/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension FavoriteArtist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteArtist> {
        return NSFetchRequest<FavoriteArtist>(entityName: "FavoriteArtist")
    }

    @NSManaged public var media_id: Int64
    @NSManaged public var name: String?
    @NSManaged public var thumb_url: String?

}
