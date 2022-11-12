//
//  FirebaseManger+Event.swift
//  TheCoffeeApp
//
//  Created by AnhLe on 08/10/2022.
//

import Foundation

extension FirebaseManager{
    // MARK: - CREATE
    func createEvent(event: Event, completion: @escaping((Bool, String?) -> Void)){
        let event = ["title": event.title,
                    "detail_title": event.detailTitle,
                    "description": event.description,
                     "image_path": event.imagePath, "isShow": event.isShow] as [String: Any]
        
        let uuid = NSUUID().uuidString
        db.collection(FirebaseDocument.events.document).document(uuid).setData(event) { err in
            if let err = err{
                completion(false, err.localizedDescription)
                return
            }else{
                completion(true, nil)
            }
        }
    }
    
    // MARK: - FETCH
    func getEvents(completion: @escaping(([Event]?, String?) -> Void)){
        db.collection(FirebaseDocument.events.document).getDocuments { querySnapshot, err in
            var events: [Event]?
            if let err = err{
                completion(nil, err.localizedDescription)
                return
            }else{
                events = [Event]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let title = data["title"] as? String
                        ,let detailTitle = data["detail_title"] as? String
                        ,let description = data["description"] as? String
                        ,let imagePath = data["image_path"] as? String{

                        let event = Event(title: title, detailTitle: detailTitle, description: description, imagePath: imagePath)
                        events!.append(event)
                    }
                }
                completion(events, nil)
            }
        }
    }
}
