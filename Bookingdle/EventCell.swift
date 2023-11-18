//
//  EventCell.swift
//  Bookingdle
//
//  Created by Mai Nguyen on 13/10/2023.
//

import UIKit

class EventCell: UICollectionViewCell {
    
    // Outlet for items on screen
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventShortDesc: UITextView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
}
