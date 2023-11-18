//
//  EventViewController.swift
//  Bookingdle
//
//  Created by Mai Nguyen on 13/10/2023.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var UUID: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var shortDescription: UITextView!
    @IBOutlet weak var longDescription: UITextView!
    
    // Index for EventViewController to know what event to display
    var eventID = -1

    var event: Int {
        get {
            return self.eventID
        }
        set {
          self.eventID = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load event information
        if (eventID >= 0) {
            imageView.image = DataManager.shared.events[eventID].photo
            UUID.text = DataManager.shared.events[eventID].uuid
            eventTitle.text = DataManager.shared.events[eventID].title
            shortDescription.text = DataManager.shared.events[eventID].shortDescription
            longDescription.text = DataManager.shared.events[eventID].longDescription
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // Show sessions under each event
        let vc = segue.destination as! SessionsViewController
        vc.event = self.event
    }

}
