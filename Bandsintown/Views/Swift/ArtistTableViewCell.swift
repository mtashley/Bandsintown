//
//  ArtistTableViewCell.swift
//  Bandsintown
//
//  Created by Ashley on 10/13/17.
//  Copyright © 2017 mtashley. All rights reserved.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!

    weak var delegate: ArtistTableViewCellDelegate?
    
    var row: Int = 0

    @IBAction func handleTappedFavoriteButton(_ sender: Any) {
        delegate?.didSelectFavoriteButton(in: self)
    }
    
    func toggleFavoriteOn() {
        self.favoriteButton.setTitle("★", for: UIControlState.normal)
    }
    
    func toggleFavoriteOff() {
        self.favoriteButton.setTitle("☆", for: UIControlState.normal)
    }
}

protocol ArtistTableViewCellDelegate : class {
    func didSelectFavoriteButton(in cell: ArtistTableViewCell)
}
