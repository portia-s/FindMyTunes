//
//  MusicDetailTableViewCell.swift
//  FindMyTunes
//
//  Created by Portia Sharma on 2/20/18.
//  Copyright © 2018 Portia Sharma. All rights reserved.
//

import UIKit

class MusicDetailTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var musicArtworkImageView: UIImageView!
    @IBOutlet weak var musicTrackNameLabel: UILabel!
    @IBOutlet weak var musicArtistNameLabel: UILabel!
    @IBOutlet weak var musicAlbumNameLabel: UILabel!
    
}
