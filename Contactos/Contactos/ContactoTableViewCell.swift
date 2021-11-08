//
//  ContactoTableViewCell.swift
//  Contactos
//
//  Created by Catalina on 05/11/20.
//

import UIKit

class ContactoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nombreLabelC: UILabel!
    @IBOutlet weak var numeroLabelC: UILabel!
    @IBOutlet weak var imageC: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
