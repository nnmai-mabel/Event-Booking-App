//
//  Session.swift
//  Bookingdle
//
//  Created by Mai Nguyen on 20/10/2023.
//

import UIKit

class Session: NSObject {
    
    // Variables for session information
    private var storedUID: String = ""
    private var storedEventID: String = ""
    private var storedSessionTime: String = ""
    private var storedCustomerName: String = ""
    private var storedPhoneNumber: String = ""
    
    // Get methods to return stored information
    var uuid: String {
        get { return storedUID }
    }
    
    var eventID: String {
        get { return storedEventID }
    }
    
    var sessionTime: String {
        get { return storedSessionTime }
    }
    
    var customerName: String {
        get { return storedCustomerName }
    }
    
    var phoneNumber: String {
        get {return storedPhoneNumber}
    }
    // Initialise session object
    init(uuid: String, eventID: String, sessionTime: String) {
        super.init()
        
        storedUID = uuid
        storedEventID = eventID
        storedSessionTime = sessionTime
    }
    
    init(uuid: String, eventID: String, sessionTime: String, theCustomerName: String, thePhoneNumber: String) {
        super.init()
        
        storedUID = uuid
        storedEventID = eventID
        storedSessionTime = sessionTime
        storedCustomerName = theCustomerName
        storedPhoneNumber = thePhoneNumber
    }
}
