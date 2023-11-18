//
//  DataManager.swift
//  Bookingdle
//
//  Created by Mai Nguyen on 13/10/2023.
//

import UIKit
import CoreData

class DataManager: NSObject {
    
    // Singleton to access from all of Views
    static let shared = DataManager()
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Store events and sessions
    private var storedBookedEvents = [Int]()
    private var storedBookedSessions = [Session]()
    private var storedEventNames = [Event]()
    private var storedSessionTimeNames = [Session]()
    
    // Get methods
    var events: [Event] {
        get { return storedEventNames }
    }
    
    var sessions: [Session] {
        get { return storedSessionTimeNames }
    }
    
    var bookedEvents : [Int]{
        get { return storedBookedEvents}
    }
    
    var bookedSessions : [Session]{
        get {return storedBookedSessions}
    }
    
    // Load booked events from core data
    func loadBookedEventsFromCoreData() {

        // Fetch booked events entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookedEvents")

        do {
            let results = try managedContext.fetch(fetchRequest)
            for result in results {
                let record = result as! NSManagedObject
                
                // Store booked events from core data into store
                storedBookedEvents.append(record.value(forKey: "eventID") as! Int)
                
                // Prepare information of events to store into booked session store
                let eid = record.value(forKey: "eventID") as! Int
                let sid = record.value(forKey: "sessionID") as! Int
                let sTime = record.value(forKey: "sessionTime") as! String
                let cName = record.value(forKey: "customerName") as! String
                let phoneNumber = record.value(forKey: "phoneNumber") as! String
                let sessionBooked = Session(uuid: String(sid), eventID: String(eid), sessionTime: sTime, theCustomerName: cName, thePhoneNumber: phoneNumber)
                
                // Store session into store
                storedBookedSessions.append(sessionBooked)
            }
        }
        catch let error as NSError {
            print("Could not load. \(error), \(error.userInfo)")
        }
    }
    
    // Add booked events
    func addBookedEvents(eventNumber eventID: Int, sessionNumber sessionID: Int, sessionTimeContent sessionTime: String, theCustomerName customerName: String, thePhoneNumber phoneNumber: String) {
        
        // EventID not in store, add events and add sessions to store
        if (!storedBookedEvents.contains(eventID)) {
            let entity = NSEntityDescription.entity(forEntityName: "BookedEvents", in: managedContext)
            let bookedEvent = NSManagedObject(entity: entity!, insertInto: managedContext)
            bookedEvent.setValue(eventID, forKey: "eventID")
            bookedEvent.setValue(sessionID, forKey: "sessionID")
            bookedEvent.setValue(sessionTime, forKey: "sessionTime")
            bookedEvent.setValue(customerName, forKey: "customerName")
            bookedEvent.setValue(phoneNumber, forKey: "phoneNumber")
            do {
                try managedContext.save()
                
                // Store event id in booked events store
                storedBookedEvents.append(eventID)
                let newSessionBooked = Session(uuid: String(sessionID), eventID: String(eventID), sessionTime: sessionTime, theCustomerName: customerName, thePhoneNumber: phoneNumber)
                
                // Store new session in booked sessions
                storedBookedSessions.append(newSessionBooked)
            }
            catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        else{ //EventID in store, check whether sessionID is in store
            
            let sessionIDExistsInArray = bookedSessions.contains{
                object in return object.uuid == String(sessionID)
            }
            let entity = NSEntityDescription.entity(forEntityName: "BookedEvents", in: managedContext)
            let bookedEvent = NSManagedObject(entity: entity!, insertInto: managedContext)
            bookedEvent.setValue(eventID, forKey: "eventID")
            bookedEvent.setValue(sessionID, forKey: "sessionID")
            bookedEvent.setValue(sessionTime, forKey: "sessionTime")
            bookedEvent.setValue(customerName, forKey: "customerName")
            bookedEvent.setValue(phoneNumber, forKey: "phoneNumber")
            // If session has not been booked, book the session
            if !sessionIDExistsInArray{
                do {
                    try managedContext.save()
                    storedBookedEvents.append(eventID)
                    let newSessionBooked = Session(uuid: String(sessionID), eventID: String(eventID), sessionTime: sessionTime, theCustomerName: customerName, thePhoneNumber: phoneNumber)
                    storedBookedSessions.append(newSessionBooked)
                    
                }
                catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
            else{
                print("SESSION ID ALREADY EXISTed")
            }
            
            print("session id exist ",sessionIDExistsInArray)
        }
    }
    
    // Cancel booked events
    func cancelBookedEvents(eventNumber eventID: Int, sessionNumber sessionID: Int, sessionTimeContent sessionTime: String, theCustomerName customerName: String){

        // Find booked sessions
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookedEvents")
        fetchRequest.predicate = NSPredicate(format: "eventID == %d AND sessionID == %d AND sessionTime == %@", eventID, sessionID, sessionTime)
        
        do {
                let fetchedObjects = try managedContext.fetch(fetchRequest)
                
                if let objectToDelete = fetchedObjects.first as? NSManagedObject {
                    
                    // Delete the booked session
                    managedContext.delete(objectToDelete)
                    
                    do {
                        try managedContext.save()
                        
                        // Update booked events store
                        if let index = storedBookedEvents.firstIndex(of: eventID) {
                            storedBookedEvents.remove(at: index)
                        }
                        
                        if let sessionIndex = storedBookedSessions.firstIndex(where: { $0.eventID == String(eventID) && $0.uuid == String(sessionID) }) {
                            storedBookedSessions.remove(at: sessionIndex)
                        }
                    } catch let error as NSError {
                        print("Could not save after deletion. \(error), \(error.userInfo)")
                    }
                } else {
                    print("Object not found in Core Data.")
                }
            } catch let error as NSError {
                print("Fetch failed. \(error), \(error.userInfo)")
            }
    }
    
    // Load events from core data
    func loadEventsFromCoreData() {
        
        // Fetch event and session
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Events")
        let fetchSessions = NSFetchRequest<NSFetchRequestResult>(entityName: "Sessions")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            let sessionsResults = try managedContext.fetch(fetchSessions)
    
            let loadedEvents = results as! [NSManagedObject]
            let loadedSessions = sessionsResults as! [NSManagedObject]
            
            for event in loadedEvents {
                
                // Get data to add to store
                let binaryData = event.value(forKey: "photo") as! Data
                let photo = UIImage(data: binaryData)
                let shortDescription = event.value(forKey: "shortDesc") as! String
                let longDescription = event.value(forKey: "longDesc") as! String
                let title = event.value(forKey: "title") as! String
                let uuid = event.value(forKey: "uuid") as! String
                let loadedEvent = Event(uuid: uuid, title: title, photo: photo!, shortDescription: shortDescription, longDescription: longDescription);
                    
                // Add event to store
                storedEventNames.append(loadedEvent)
            }
            
            for session in loadedSessions {
                
                // Get data to add to store
                let eventID = session.value(forKey: "eventID") as! String
                let sessionTime = session.value(forKey: "sessionTime") as! String
                let uuid = session.value(forKey: "uuid") as! String
                let customerName = session.value(forKey: "customerName")
let phoneNumber = session.value(forKey: "phoneNumber")
                let loadedSession = Session(uuid: uuid, eventID: eventID, sessionTime: sessionTime, theCustomerName: customerName as! String, thePhoneNumber: phoneNumber as! String);
                    
                // Add session time name to store
                storedSessionTimeNames.append(loadedSession)
            }
        }
        catch let error as NSError {
            print("Could not load. \(error), \(error.userInfo)")
        }
    }
    
    // Refresh events
    func refreshEvents() {
        
        // Fetch data from api
        let url = NSURL(string: "https://easterbilby.net/compdle.wtf/api.php")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
            
        let task = session.dataTask(with: url! as URL, completionHandler:
                                        { [self](data, response, error) in
            if (error != nil) { return; }
            if let json = try? JSON(data: data!) {
                
                // Get eventID and sessionID
                for count in 0...json["events"].count - 1 {
                    let jsonEvent = json["events"][count]
                    let newEvent = Event(
                        uuid: jsonEvent["uuid"].string!,
                        title: jsonEvent["title"].string!,
                        shortDescription: jsonEvent["shortdesc"].string!,
                        longDescription:  jsonEvent["longdesc"].string!)
                    for countSession in 0...jsonEvent["sessions"].count - 1{
                        let jsonSession = jsonEvent["sessions"][countSession]
                        let uuid = String(countSession)
                        let sessionEventID = String(count)
                        let newSession = Session(uuid: uuid, eventID: sessionEventID, sessionTime: jsonSession.rawValue as! String)
                        self.storedSessionTimeNames.append(newSession)
                    }
                    
                    // Fetch image from api
                    let imageURLString = "https://easterbilby.net/compdle.wtf/events/" + jsonEvent["image"].string!
                    self.addItemToEvents(newEvent, imageURL: imageURLString)
                }
            }
        })
        task.resume()
    }
    
    // Add item to events
    func addItemToEvents(_ newEvent: Event!, imageURL: String) {

        if !checkForEvent(newEvent) {
        
            // Get the photo
            newEvent.photo = loadImage(imageURL)
            
            let entity = NSEntityDescription.entity(forEntityName: "Events", in: managedContext)
            let eventToAdd = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            // Add event to core data
            eventToAdd.setValue(newEvent.photo.pngData(), forKey: "photo")
            eventToAdd.setValue(newEvent.title, forKey: "title")
            eventToAdd.setValue(newEvent.shortDescription, forKey: "shortDesc")
            eventToAdd.setValue(newEvent.longDescription, forKey: "longDesc")
            eventToAdd.setValue(newEvent.uuid, forKey: "uuid")
        
            do {
                try managedContext.save()
            }
            catch let error as NSError
            {
                print("Could not save. \(error), \(error.userInfo)")
            }

            // Add event to store
            storedEventNames.append(newEvent)
        }
    }
    
    // Check whether event exist
    func checkForEvent(_ searchItem: Event) -> Bool {
            var found = false
            
            if (events.count > 0) {
                for event in events {
                    if (event.uuid.isEqual(searchItem.uuid)) {
                        found = true
                    }
                }
            }
            return found
    }
    
    // Turn image url to image
    func loadImage(_ imageURL: String) -> UIImage
        {
            var image: UIImage!
            if let url = NSURL(string: imageURL)
            {
                if let data = NSData(contentsOf: url as URL)
                {
                    image = UIImage(data: data as Data)
                }
            }
            return image!
        }
    
    override init() {
        super.init()
        print("Start")
        
        // Load events, booked events, and refresh events
        loadEventsFromCoreData()
        loadBookedEventsFromCoreData()
        refreshEvents()
    }
}
