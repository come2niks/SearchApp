//
//  MovieRecordTableViewCell.swift
//  SearchApp
//
//  Created by Nikhilesh Walde on 26/03/2018.
//  Copyright © 2018 PrepayNation. All rights reserved.
//

import UIKit

class MovieRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
