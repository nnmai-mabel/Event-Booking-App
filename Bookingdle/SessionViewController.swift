//
//  SessionViewController.swift
//  Bookingdle
//
//  Created by Mai Nguyen on 17/10/2023.
//

import UIKit

class SessionViewController: UIViewController {

    // Add delegate to reload sessions available
    var delegate: SessionsViewController?
    
    // Outlet for items on screen
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var sessionTime: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var customerName: UITextField!
    @IBOutlet weak var bookEventButton: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!
    
    // Action to book event
    @IBAction func bookEventAction(_ sender: Any) {
        var eventSessions = [Session]()
        let storedSessions = DataManager.shared.sessions
        for s in storedSessions{
            if s.eventID == String(eventID){
                eventSessions.append(s)
            }
        }
        
        // Get session information
        let sessionText = eventSessions[sessionID].sessionTime
        let sessionTimeInUrl = sessionTime.text!.replacingOccurrences(of: " ", with: "%20")
        let customerNameText = customerName.text!
        let phoneNumberText = phoneNumber.text!
        let sessionUUID = DataManager.shared.events[eventID].uuid
        
        // Get url
        let url = NSURL(string: "https://easterbilby.net/compdle.wtf/api.php?action=register&uuid=" + sessionUUID + "&session=" + sessionTimeInUrl + "&name=" + customerName.text!.replacingOccurrences(of: " ", with: "%20"))
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        print(url!)
        let task = session.dataTask(with: url! as URL, completionHandler:
                                        {(data, response, error) in
            
            if (error != nil) { return; }
            if let data = data{
                do {
                    let json = try? JSON(data: data)
                    
                    // If api returns success is true, book the session
                    if(json!["success"] == "true"){
                        DataManager.shared.addBookedEvents(eventNumber: self.eventID, sessionNumber: self.sessionID, sessionTimeContent: sessionText, theCustomerName: customerNameText, thePhoneNumber: phoneNumberText)
                        
                        // Alert for successful booking
                        DispatchQueue.main.async {
                            self.delegate?.collectionView.reloadData()
                            let alertController = UIAlertController(title: "Booking Successful", message: "Your event has been successfully booked.", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                            
                        }
                    }
                    else{
                        
                        // Alert for unsuccessful booking
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Booking Unuccessful", message: "Please fill in all the details and make sure the session is available.", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            }
        })
        task.resume()
    }
    
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
    
    // Index for SessionViewController to know what session to display
    var sessionID = -1

    var session: Int {
        get {
            return self.sessionID
        }
        set {
          self.sessionID = newValue
        }
    }
    
    // Session time
    var sessionTimeID = ""

    var sessionTheTime: String {
        get {
            return self.sessionTimeID
        }
        set {
          self.sessionTimeID = newValue
        }
    }
    
    // Whether session is booked
    var sessionBookedBool = false
    
    var sessionAlreadyBooked: Bool {
        get {
            return self.sessionBookedBool
        }
        set {
          self.sessionBookedBool = newValue
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide keyboard
        initializeHideKeyboard()

        // Load session
        if (eventID >= 0 && sessionID >= 0) {
            
            // Get session information on screen
            imageView.image = DataManager.shared.events[eventID].photo
            eventName.text = DataManager.shared.events[eventID].title
            var eventSessions = [Session]()
            let storedSessions = DataManager.shared.sessions
            for s in storedSessions{
                if s.eventID == String(eventID){
                    eventSessions.append(s)
                }
            }
            sessionTime.text = eventSessions[sessionID].sessionTime
            sessionTime.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            
            // Check if session has already been booked
            if(DataManager.shared.bookedEvents.contains(eventID)){
                for bookedSession in DataManager.shared.bookedSessions{
                        if(bookedSession.eventID == String(eventID) && bookedSession.uuid == String(sessionID)){

                            // Show alert for unavailable session
                            sessionAlreadyBooked = true
                            let alertController = UIAlertController(title: "Unavailable Session", message: "This session has been booked. Please choose another session.", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                }
            }
        }
    }
    
    // Hide keyboard
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }

        @objc func dismissKeyboard() {
            view.endEditing(true)
         }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        let vc = segue.destination as! BookedEventsViewController
        vc.session = self.sessionID
        vc.event = self.event
        vc.sessionTheTime = self.sessionTheTime
    }
    

}
