//
//  RMUser.swift
//  roomate
//
//  Created by Aaron Levin on 10/31/16.
//  Copyright © 2016 RooMate. All rights reserved.
//

import Foundation

public struct RMUser : Hashable {
    
    var userObjectID: Int
    var groupID: Int?
    var dateCreatedAt: String?
    var firstName: String
    var lastName: String
    var email: String
    var profileImageURL: String
    var userGroceryLists: [RMGroceryList]?

    // BEGIN: Temporary code to test everything with different RMUsers
    static func returnTestUser() -> RMUser {
        return RMUser(userObjectID: 1, groupID: 2, dateCreatedAt: "00/00/00", firstName: "TestFirst", lastName: "UserLast", email: "testUser@trumpsucks.com", profileImageURL: "N/A", userGroceryLists: nil)
    }
    
    static func getCurrentUserFromDefaults() -> RMUser {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let email = userDefaults.valueForKey("email") as! String
        let groupID = userDefaults.valueForKey("groupID") as! Int
        let userID = userDefaults.valueForKey("userID") as! Int
        let firstName = userDefaults.valueForKey("firstName") as! String
        let lastName = userDefaults.valueForKey("lastName") as! String
        let profileImage = userDefaults.valueForKey("profilePictureURL") as! String
        
        return RMUser(userObjectID: userID, groupID: groupID, dateCreatedAt: "00/00/00", firstName: firstName, lastName: lastName, email: email, profileImageURL: profileImage, userGroceryLists: nil)
    }
    
    
    // we could also make a function that returns a specific user from 
    static func getRoomatesFromDefaults(completionHandler: (success: Bool, [RMUser]?)->()) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let otherUsersData = userDefaults.objectForKey("roomates") as? NSData
        
        if let otherUsersData = otherUsersData {
            let usersArray = NSKeyedUnarchiver.unarchiveObjectWithData(otherUsersData) as! [RMUser]?
            
            if let usersArray = usersArray {
                completionHandler(success: true, usersArray)
            } else {
                completionHandler(success: false, nil)
            }
        } else {
            completionHandler(success: false, nil)
        }
    }
 
    /*
    static func saveRoomatesToDefaults(groupID: Int, completionHandler: (success: Bool) -> ()) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        RMGroup.getUsersInGroup(groupID) { (success, users) in
            if success && users != nil {
                let usersData = NSKeyedArchiver.archivedDataWithRootObject(users! as! AnyObject)
                defaults.setObject(usersData, forKey: "otherUsers")
            } else if success {
                defaults.setObject([RMUser]() as? AnyObject, forKey: "otherUsers")
                completionHandler(success: true)
            } else {
                completionHandler(success: false)
            }
        }
    }
    */
    
    // END: Temporary code to test everything with RMUsers
    
    
    
    
    
    // Public Functions
    
    static func createUser(user: RMUser, completion: (success: Bool, userID: Int) -> ()) {
        
        var userParamDictionary = [String : AnyObject]()
        userParamDictionary["firstname"] = user.firstName
        userParamDictionary["lastname"] = user.lastName
        userParamDictionary["email"] = user.email
        userParamDictionary["profileimageurl"] = user.profileImageURL
        
        
        RMQueryBackend.post("https://damp-plateau-63440.herokuapp.com/createRMUser", params: userParamDictionary) { (succeeded, jsonResponse) in
            (succeeded) ? completion(success: true, userID: jsonResponse?["userid"] as! Int) : completion(success: false, userID: 0)
        }
    }
    
    static func editRMUserGroupID(userID: Int, newGroupID: Int?, completion: (success: Bool) -> ()) {
        var userParamDictionary = [String : AnyObject]()
        userParamDictionary["userid"] = userID
        userParamDictionary["groupid"] = newGroupID
        
        RMQueryBackend.post("https://damp-plateau-63440.herokuapp.com/editRMUserGroupid", params: userParamDictionary) { (succeeded, jsonResponse) in
            (succeeded) ? completion(success: true) : completion(success: false)
        }
    }
    
    static func doesUserExist(email: String, completion: (userExists: Bool, statusCode: Int) -> Void){
        let apiCallString = "https://damp-plateau-63440.herokuapp.com/doesUserExist"
        let httpURL = NSURL(string: apiCallString)
        let request = NSMutableURLRequest(URL: httpURL!)
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\(email)", forHTTPHeaderField: "email")
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            var statusCode = 0
            if let httpResponse = response as? NSHTTPURLResponse {
                statusCode = httpResponse.statusCode
            }
            
            if(error != nil || data == nil || statusCode != 200){
                switch statusCode {
                case 400:
                    completion(userExists: false, statusCode: statusCode)
                case 503:
                    completion(userExists: false, statusCode: statusCode)
                default:
                    completion(userExists: false, statusCode: statusCode)
                }
            } else {
                var json: NSArray
                do {
                    try json = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSArray
                } catch {
                    print("this is where we got")
                    completion(userExists: false, statusCode: statusCode)
                    return
                }
                
                if json.count == 0 {
                    print("json array was empty")
                    completion(userExists: false, statusCode: statusCode)
                    return
                }
                else {
                    var userExists = false
                    
                    for jsonItem in json {
                        guard let jsonItemDict = jsonItem as? [String : AnyObject]
                            else {
                                completion(userExists: false, statusCode: statusCode)
                                return
                        }
                        print("mycount:  \(Int(jsonItemDict["mycount"] as! String))" )
                        
                        ( Int(jsonItemDict["mycount"] as! String) == 1) ? (userExists = true) : (userExists = false)
                    }
                    
                    completion(userExists: userExists, statusCode: statusCode)
                    return
                }
            }
        }
        task.resume()
    }
    
    static func getUserFromEmail(email: String, completion: (success: Bool, statusCode: Int, user: RMUser?) -> () ) {
        RMQueryBackend.get("https://damp-plateau-63440.herokuapp.com/getRMUserByEmail", parameters: ["email":email]) { (successful, jsonResponseArray) in
            if successful {
                let jsonItem = jsonResponseArray![0]
                
                let userObjectID = jsonItem["userid"] as! Int
                
                
                let groupObjID = (jsonItem["groupid"] as? Int)
                
//                // set groupID to 0 if it's passed from JSON as nil
//                var groupObjID = (jsonItem["groupid"] as? Int)
//                if (groupObjID == nil) { groupObjID = 0 }
//                
//                if let tempVal = jsonItem["groupid"] as? Int {
//                    groupObjID = tempVal
//                } else {
//                    groupObjID = 0
//                }
                
                
                let dateCreatedAt = jsonItem["datecreatedat"] as! String
                let firstName = jsonItem["firstname"] as! String
                let lastName = jsonItem["lastname"] as! String
                let profileImageURL = "" /*jsonItem["profileimageurl"] as! String*/ // TODO: implement profileimageurl on backend
                
                completion(success: true, statusCode: 200, user: RMUser(userObjectID: userObjectID, groupID: groupObjID, dateCreatedAt: dateCreatedAt, firstName: firstName, lastName: lastName, email: email, profileImageURL: profileImageURL, userGroceryLists: []))
            } else {
                completion(success: false, statusCode: 0, user: nil)
            }
        }
    }

    static func createUserDictionary(user: RMUser) -> ([String : AnyObject]) {
        var userParamDictionary = [String : AnyObject]()
        
        userParamDictionary["userid"] = user.userObjectID
        userParamDictionary["groupid"] = user.groupID
        userParamDictionary["datecreatedat"] = user.dateCreatedAt
        userParamDictionary["firstname"] = user.firstName
        userParamDictionary["lastname"] = user.lastName
        userParamDictionary["email"] = user.email
        userParamDictionary["profileimageurl"] = user.profileImageURL
        
        return userParamDictionary
    }
    
    static func parseUserJSONObject(jsonDict: [String: AnyObject]) -> RMUser {
        let userID = jsonDict["userid"] as! Int
        let groupID = jsonDict["groupid"] as? Int
        let dateCreatedAt = jsonDict["datecreatedat"] as! String
        let firstName = jsonDict["firstname"] as! String
        let lastName = jsonDict["lastname"] as! String
        let email = jsonDict["email"] as! String
        let profileImageURL = jsonDict["profileimageurl"] as! String
        
        return RMUser(userObjectID: userID, groupID: groupID, dateCreatedAt: dateCreatedAt, firstName: firstName, lastName: lastName, email: email, profileImageURL: profileImageURL, userGroceryLists: [])
    }
    
    
    public var hashValue: Int { return userObjectID.hashValue }
    
}
// Conform RMUser to the Equatable protocol, so then RMUser can conform to Hashable.
// Ultimately, RMUser must conform to Hashable to be used as a key in dictionaries.
extension RMUser: Equatable {}

public func ==(lhs: RMUser, rhs: RMUser) -> Bool {
    
    // Two users are equal if their objectIDs are equivalent.
    return lhs.userObjectID == rhs.userObjectID
}




