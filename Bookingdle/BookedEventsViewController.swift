//
//  BookedEventsViewController.swift
//  Bookingdle
//
//  Created by Mai Nguyen on 17/10/2023.
//

import UIKit

class BookedEventsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        self.configureCollectionView()
    }
       
    func configureCollectionView() {
        collectionView!.dataSource = self
        collectionView!.delegate = self
    }
       
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.shared.bookedEvents.count
    }

    // Collection view to show booked session information
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! EventCell
        let imageNumberToDisplay = DataManager.shared.bookedEvents[indexPath.row]
        cell.imageView.image = DataManager.shared.events[imageNumberToDisplay].photo
        
        // Get the index of the current event in bookedEvents -> indexPath.row
        cell.sessionLabel.text = DataManager.shared.bookedSessions[indexPath.row].sessionTime
        cell.nameLabel.text = DataManager.shared.bookedSessions[indexPath.row].customerName
        cell.eventTitle.text = DataManager.shared.events[imageNumberToDisplay].title
        cell.phoneNumberLabel.text = DataManager.shared.bookedSessions[indexPath.row].phoneNumber
        return cell
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPaths = collectionView.indexPathsForSelectedItems! as NSArray
        let indexPath = indexPaths[0] as! IndexPath
        
        let vc = segue.destination as! BookedEventViewController
        vc.eventImage = DataManager.shared.bookedEvents[indexPath.row]
        vc.event = Int(DataManager.shared.bookedSessions[indexPath.row].eventID) ?? -2
        vc.bookedSession = indexPath.row
        vc.session = Int(DataManager.shared.bookedSessions[indexPath.row].uuid) ?? -2
        vc.stringEvent = DataManager.shared.bookedSessions[indexPath.row].eventID
        vc.sessionTheTime = DataManager.shared.bookedSessions[indexPath.row].sessionTime
        
        vc.delegate = self
    }

}
