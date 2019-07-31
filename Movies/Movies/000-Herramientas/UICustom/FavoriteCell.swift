//
//  FavoriteCell.swift
//  Movies
//
//  Created by Mauricio Caro on 7/27/19.
//  Copyright © 2019 Maccservice. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

    @IBOutlet weak var posterIMG: UIImageView!
    @IBOutlet weak var tituloLBL: UILabel!
    @IBOutlet weak var lanzamientoLBL: UILabel!
    @IBOutlet weak var descripcionTXV: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
