//
//  DataManager.swift
//  Bandsintown
//
//  Created by Ashley on 10/14/17.
//  Copyright © 2017 mtashley. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON
import Kingfisher

@objc protocol DataManagerDelegate : class {
    
    // Swift | Refresh HomeVC TableView w/ the new Artist data.
    @objc optional func reloadData()
    
    // Objective-C | Load DetailVC w/ ArtistDetails
    @objc optional func presentArtistDetails(with artist: Artist)
}

@objc class DataManager : NSObject {
    
    @objc static let sharedInstance = DataManager()
    
    @objc weak var delegate: DataManagerDelegate!
    
    // TableView Datasources
    
    private var dataSourceSearch: [Artist] = []
    private var dataSourceFavorites: [Artist] = []
    
    func dataSource(_ viewState: ViewState) -> [Artist] {
        return (viewState == .VS_Artists) ? dataSourceSearch : dataSourceFavorites
    }
    
    // Handle JSON data fetched from the API.
    func loadArtistDetails(_ object: JSON) {
        
        let artist = Artist(jsonObject: object)
        delegate.presentArtistDetails!(with: artist)
        
        // Allow Kingfisher (Swift) to load cached images into Objective-C class (DetailVC).
        let url = URL(string: artist.image_url)
        (delegate as! DetailVC).img_image.kf.setImage(with: url)
    }
    
    func loadSearchResults(_ object: JSON) {
        
        if object["data"] != JSON.null {
            
            dataSourceSearch = []
            
            for record in object["data"].arrayObject! {
                let json = JSON(record)
                let thumb = Utilities.cleanURL(from: json["media_id"].int!, requestType: .RT_IMAGE_THUMB)
                
                let artist = Artist(name: json["name"].string!,
                                media_id: json["media_id"].int!,
                               thumb_url: thumb)
                
                dataSourceSearch.append(artist)
            }
            
            delegate.reloadData!()
        }
    }
    
    // MARK: Handling Favorites
    
    func loadFavoriteArtists() {
        
        dataSourceFavorites = []
        let request = fetch(entityName: "FavoriteArtist")
        let result = try? context().fetch(request)
        let resultData = result as! [FavoriteArtist]
        
        for object in resultData {
            
            let artist = Artist(name: object.name!,
                            media_id: Int(object.media_id),
                           thumb_url: object.thumb_url!)
            
            dataSourceFavorites.append(artist)
        }
        
        delegate.reloadData!()
    }
    
    func toggleFavorite(_ artist: Artist) {
        isFavorited(artist) ? unfavorite(artist) : favorite(artist)
    }
    
    func isFavorited(_ artist: Artist) -> Bool {
        
        let request = fetch(entityName: "FavoriteArtist", predicate: artist.name)
        request.fetchLimit = 1
        return entityExists(request: request)
    }
    
    func favorite(_ artist: Artist) {
        
        if isFavorited(artist) { return }
        
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteArtist",  in: context())!
        let favArtist = NSManagedObject(entity: entity, insertInto: context())
        
        mapEntity(favArtist as! FavoriteArtist, to: artist)
        saveContext()
        delegate.reloadData!()
    }
    
    func unfavorite(_ artist: Artist) {
        
        let request = fetch(entityName: "FavoriteArtist", predicate: artist.name)
        let result = try? context().fetch(request)
        let resultData = result as! [FavoriteArtist]
        
        for object in resultData {
            context().delete(object)
        }
        
        saveContext()
        loadFavoriteArtists()
    }
    
    // MARK: CoreData & CoreData Helpers

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Bandsintown")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in })
        return container
    }()
    
    fileprivate func context() -> NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    fileprivate func fetch(entityName: String) -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    }
    
    fileprivate func fetch(entityName: String, predicate: String) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = NSPredicate(format: "name = %@", predicate)
        return request
    }
    
    fileprivate func entityExists(request: NSFetchRequest<NSFetchRequestResult>) -> Bool {
        
        do {
            let count = try context().count(for: request)
            return count > 0
        }
        catch let error as NSError {
            print("Unable to perform action (entityExists): \(error), \(error.userInfo)")
            return false
        }
    }
    
    fileprivate func mapEntity(_ favoriteArtist: FavoriteArtist, to artist: Artist) {
        favoriteArtist.setValue(artist.name, forKeyPath: "name")
        favoriteArtist.setValue(artist.media_id, forKeyPath: "media_id")
        favoriteArtist.setValue(artist.thumb_url, forKeyPath: "thumb_url")
    }
    
    func saveContext() {
        if context().hasChanges {
            do {
                try context().save()
            } catch {
                let nserror = error as NSError
                fatalError("Unable to perform action (saveContext): \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
