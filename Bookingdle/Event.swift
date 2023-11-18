//
//  Event.swift
//  Bookingdle
//
//  Created by Mai Nguyen on 19/10/2023.
//

import UIKit

class Event: NSObject {
    
    // Create variables for event information
    private var storedUID: String = ""
    private var storedPhoto: UIImage = UIImage()
    private var storedTitle: String = ""
    private var storedShortDescription: String = ""
    private var storedLongDescription: String = ""
    
    // Get methods to return stored information
    var uuid: String {
        get { return storedUID }
    }
    
    var photo: UIImage {
        get { return storedPhoto }
        set { storedPhoto = newValue }
    }
    
    var title: String {
        get { return storedTitle }
    }
    
    var shortDescription: String {
        get { return storedShortDescription }
    }

    var longDescription: String {
        get { return storedLongDescription }
    }
    
    // Initialise the event object
    init(uuid: String, title: String, photo: UIImage, shortDescription: String, longDescription: String) {
        super.init()
        
        storedUID = uuid
        storedTitle = title
        storedPhoto = photo
        storedShortDescription = shortDescription
        storedLongDescription = longDescription
    }

    init(uuid: String, title: String, shortDescription: String, longDescription: String) {
        super.init()
        
        storedUID = uuid
        storedTitle = title
        storedShortDescription = shortDescription
        storedLongDescription = longDescription
    }
}
