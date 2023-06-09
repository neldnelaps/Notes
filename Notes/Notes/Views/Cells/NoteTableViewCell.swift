//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Natalia Pashkova on 21.03.2023.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var depictionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
