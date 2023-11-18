//
//  SessionsViewController.swift
//  Bookingdle
//
//  Created by Mai Nguyen on 13/10/2023.
//

import UIKit

class SessionsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        var count = 0
        let storedSessions = DataManager.shared.sessions
        
        // Find out how many sessions with that eventID
        for s in storedSessions{
            if s.eventID == String(eventID){
                count += 1
            }
        }
        return count
    }

    // Collection view for showing sessions information
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionCell", for: indexPath) as! SessionCell
        
        // Create a new array to store sessions with that eventID only
        var eventSessions = [Session]()
        let storedSessions = DataManager.shared.sessions
        for s in storedSessions{
            if s.eventID == String(eventID){
                eventSessions.append(s)
            }
        }
        cell.sessionView.text = eventSessions[indexPath.row].sessionTime
        
        // Check if session has already been booked and change session color accordingly
        if sessionIsBooked(eventID: eventID, sessionTime: eventSessions[indexPath.row].sessionTime){
            cell.sessionView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.93, alpha: 0.2)
            cell.sessionView.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        }
        else {
            cell.sessionView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.93, alpha: 1)
            cell.sessionView.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        return cell
    }
    
    // Check whether the session is already booked
    func sessionIsBooked(eventID: Int, sessionTime: String) -> Bool {
        if(DataManager.shared.bookedEvents.contains(eventID)){
            for bookedSession in DataManager.shared.bookedSessions{
                if(bookedSession.eventID == String(eventID) && bookedSession.sessionTime == sessionTime){
                    return true
                    }
            }
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath){}

    func configureCollectionView()
    {
       collectionView!.dataSource = self
       collectionView!.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureCollectionView()
        if (eventID >= 0){
            
            // Get event image
            imageView.image = DataManager.shared.events[eventID].photo
            
            // Get event name
            eventName.text = DataManager.shared.events[eventID].title
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let indexPaths = collectionView.indexPathsForSelectedItems! as NSArray
        let indexPath = indexPaths[0] as! IndexPath
        let vc = segue.destination as! SessionViewController
        vc.session = indexPath.row
        vc.event = self.event
        vc.sessionTheTime = DataManager.shared.sessions[indexPath.row].sessionTime
        vc.delegate = self
    }
    

}
