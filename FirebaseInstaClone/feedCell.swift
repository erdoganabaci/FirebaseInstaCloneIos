//
//  feedCell.swift
//  FirebaseInstaClone
//
//  Created by Erdo on 16.01.2019.
//  Copyright © 2019 Erdo. All rights reserved.
//

import UIKit

class feedCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userCommentLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
