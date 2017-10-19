//
//  ViewController.swift
//  Bandsintown
//
//  Created by Ashley on 10/13/17.
//  Copyright © 2017 mtashley. All rights reserved.
//
import UIKit
import Kingfisher

class HomeVC: UIViewController {
    
    @IBOutlet weak var homeTable: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let dm = DataManager.sharedInstance
    let nm = NetworkManager.sharedInstance
    
    private var searchBarHolder: UISearchBar!
    private var viewState: ViewState = .VS_Artists
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarHolder = searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dm.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetail" {
            guard let indexPath = homeTable.indexPathForSelectedRow else { return }
            let selectedArtist: Artist = dm.dataSource(viewState)[indexPath.row]
            
            // NOTE: DataManager delegate will callback to the destination view.
            nm.requestArtistDetails(from: selectedArtist.name)
        }
    }
    
    @IBAction func segmentedControlAction(_ sender: Any) {
        
        // Artists Tab
        if segmentedControl.selectedSegmentIndex == 0 {
            self.viewState = .VS_Artists
            self.title = Constants.NAV_TITLE_ARTISTS
            self.homeTable.tableHeaderView = searchBarHolder
            self.nm.requestArtists(from: searchBar.text!)
        }
            
        // Favorites Tab
        else if segmentedControl.selectedSegmentIndex == 1 {
            self.viewState = .VS_Favorites
            self.title = Constants.NAV_TITLE_FAVORITES
            self.homeTable.tableHeaderView = nil
            self.dm.loadFavoriteArtists()
        }
        
        homeTable.reloadData()
    }
}

extension HomeVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dm.dataSource(viewState).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID = "ArtistCell"
        let cell: ArtistTableViewCell = homeTable.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            as! ArtistTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let artist : Artist = dm.dataSource(viewState)[indexPath.row]
        configureArtistCell(cell as! ArtistTableViewCell, artist: artist, row: indexPath.row)
    }
    
    // Helper Function
    func configureArtistCell(_ cell: ArtistTableViewCell, artist: Artist, row: Int) {

        cell.delegate = self
        cell.row = row
        cell.artistName.text = artist.name
        dm.isFavorited(artist) ? cell.toggleFavoriteOn() : cell.toggleFavoriteOff()
        
        // Images are loaded in background thread via Kingfisher.
        cell.artistImage.kf.setImage(with: URL(string: artist.thumb_url))
    }
}

extension HomeVC : UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        nm.requestArtists(from: searchText)
    }
}

extension HomeVC : ArtistTableViewCellDelegate {
    
    func didSelectFavoriteButton(in cell: ArtistTableViewCell) {
        let artist: Artist = dm.dataSource(viewState)[cell.row]
        dm.toggleFavorite(artist)
    }
}

extension HomeVC : DataManagerDelegate {
    
    func reloadData() {
        self.homeTable.reloadData()
    }
}

