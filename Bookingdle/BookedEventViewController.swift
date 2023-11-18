//
//  BookedEventViewController.swift
//  Bookingdle
//
//  Created by Mai Nguyen on 21/10/2023.
//

import UIKit

class BookedEventViewController: UIViewController {

    var delegate: BookedEventsViewController?
    
    // Outlet for items on screen
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sessionView: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cancelEventButton: UIButton!
    @IBOutlet weak var phoneNumber: UILabel!
    
    // Function to cancel event
    @IBAction func cancelEventAction(_ sender: Any) {
        
        // Cancel the event
        let customerName = nameLabel.text!
        DataManager.shared.cancelBookedEvents(eventNumber: self.event, sessionNumber: self.session, sessionTimeContent: self.sessionTheTime, theCustomerName: customerName)
        let sessionTimeInUrl = sessionView.text!.replacingOccurrences(of: " ", with: "%20")
        
        let sessionUUID = DataManager.shared.events[eventID].uuid
        
        // Get information from api
        let url = NSURL(string: "https://easterbilby.net/compdle.wtf/api.php?action=unregister&uuid=" + sessionUUID + "&session=" + sessionTimeInUrl + "&name=" + nameLabel.text!.replacingOccurrences(of: " ", with: "%20"))
        
               let config = URLSessionConfiguration.default
               let session = URLSession(configuration: config)
               let task = session.dataTask(with: url! as URL, completionHandler:
                                               {(data, response, error) in
                   if (error != nil) { return; }
                   if let data = data{
                       do {
                            let json = try? JSON(data: data)
                           
                           // Cancel the event and show successful alert
                           if(json!["success"] == "true"){
                               DataManager.shared.cancelBookedEvents(eventNumber: self.event, sessionNumber: self.session, sessionTimeContent: self.sessionTheTime, theCustomerName: customerName)
                               DispatchQueue.main.async {
                                   self.delegate?.collectionView.reloadData()
                                   
                                   // Show alert
                                   let alertController = UIAlertController(title: "Cancel Booking Successful", message: "Your event has been successfully cancelled.", preferredStyle: .alert)
                                   alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                   self.present(alertController, animated: true, completion: nil)
                               }
                           }
                           else{
                               // Show unsuccessful alert
                               let alertController = UIAlertController(title: "Cancel Booking Unsuccessful", message: "Fail to cancel event.", preferredStyle: .alert)
                               alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                               self.present(alertController, animated: true, completion: nil)
                           }
       
                       }
       
                   }
       
               })
               task.resume()
    
    }
    
    // Get information
    var eventID = -1
    
    var event: Int {
        get {
            return self.eventID
        }
        set {
          self.eventID = newValue
        }
    }
    
    var eventImageID = -1
    
    var eventImage: Int {
        get {
            return self.eventImageID
        }
        set {
          self.eventImageID = newValue
        }
    }
    
    var sessionID = -1

    var session: Int {
        get {
            return self.sessionID
        }
        set {
          self.sessionID = newValue
        }
    }
    
    var bookedSessionID = -1

    var bookedSession: Int {
        get {
            return self.bookedSessionID
        }
        set {
          self.bookedSessionID = newValue
        }
    }
    
    // Index for SessionViewController to know what session to display
    var sessionTimeID = ""

    var sessionTheTime: String {
        get {
            return self.sessionTimeID
        }
        set {
          self.sessionTimeID = newValue
        }
    }
    
    var stringEventID = ""
    
    var stringEvent: String {
        get {
            return self.stringEventID
        }
        set {
          self.stringEventID = newValue
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get information to show on screen
        imageView.image = DataManager.shared.events[eventImage].photo
        sessionView.text = DataManager.shared.bookedSessions[bookedSession].sessionTime
        nameLabel.text = DataManager.shared.bookedSessions[bookedSession].customerName
        eventName.text = DataManager.shared.events[eventImage].title
        phoneNumber.text = DataManager.shared.bookedSessions[bookedSession].phoneNumber
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination as! EventViewController
        vc.event = event
    }
    

}
