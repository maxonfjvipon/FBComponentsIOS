//
//  BoughtTicketFirebase.swift
//  Afisha
//
//  Created by Maxim Trunnikov on 12/4/20.
//

import Foundation
import Firebase

struct UserTicket: Decodable, Hashable {
    var movie: String
    var price: String
    var cinema: String
    var time: String
    var place: String
    
    init() {
        movie = ""
        price = ""
        cinema = ""
        time = ""
        place = ""
    }
}

class FirebaseManager {
    static let shared: FirebaseManager = FirebaseManager()
    
    func downloadTickets() -> [UserTicket] {
        var tickets: [UserTicket] = []
        guard let curUser = Auth.auth().currentUser else { return tickets }
        var ticketsCount: Int = 0
        let id = curUser.uid
        let db = Firestore.firestore()
        let ref = db.collection("tickets").document(id)
        
        ref.getDocument { (snapshot, error) in
            if error != nil {
                // error
            } else {
                guard snapshot != nil else { return }
                guard let data = snapshot?.data() else { return }
                
                ticketsCount = data["tickets_count"] as? Int ?? 0
                
                for i in 0..<ticketsCount {
                    let ticketRef = ref.collection("user_tickets").document(String(i + 1))
                    ticketRef.getDocument { (sn, er) in
                        if er != nil {
                            // error
                        } else {
                            guard sn != nil else { return }
                            guard let userTicket: UserTicket = try? sn!.decoded() else { return }
                            tickets.append(userTicket)
                        }
                        
                    }
                }
            }
        }
        return tickets
    }
    
    func add(ticket: UserTicket) {
        guard let id = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let reference = db.collection("tickets").document(id)
        var count = 0;
        
        reference.getDocument { (snapshot, error) in
            if error != nil {
                // error
            } else {
                guard snapshot != nil else { return }
                guard let data = snapshot?.data() else { return }
                
                count = data["tickets_count"] as? Int ?? 0
            }
        }
        
        reference.setData(["tickets_count":count + 1]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Added successfully")
            }
        }
        
        let ticketData: [String: String] = [
            "movie": ticket.movie,
            "cinema": ticket.cinema,
            "place": ticket.place,
            "time": ticket.time,
            "price": ticket.price
        ]
        reference.collection("user_tickets").document(String(count + 1)).setData(ticketData) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Added successfully")
            }
        }
    }
    
}



extension DocumentSnapshot {
    func decoded <T: Decodable> () throws -> T {
        let jsonData = try JSONSerialization.data(withJSONObject: data() ?? ["" : ""], options: [])
        print(jsonData)
        let object = try JSONDecoder().decode(T.self, from: jsonData)
        return object
    }
}
