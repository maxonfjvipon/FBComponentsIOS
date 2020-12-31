//
//  BoughtTicketsView.swift
//  Afisha
//
//  Created by Maxim Trunnikov on 11/24/20.
//

import SwiftUI
import Firebase

struct BoughtTicketsView: View {
    @State var ticketsLoaded = false
    @State var tickets = [UserTicket]()
    
    @ViewBuilder
    var body: some View {
        if (!ticketsLoaded) {
            Text("Пусто")
                .font(.title2)
                .onAppear() {
                    downloadTickets()
                }
                .navigationBarTitle(Text("Билеты"), displayMode: .inline)
                .navigationBarItems(trailing: NavigationLink(destination: ComponentsView(), label: {
                    Text("Компоненты")
                        .foregroundColor(.blue)
                }))
        } else {
            ScrollView {
                ForEach(tickets, id: \.self) { ticket in
                    VStack(alignment: .leading, spacing: 0.0) {
                        Text(ticket.movie)
                            .font(.title2)
                            .padding(.top)
                        Text(ticket.cinema)
                            .font(.title3)
                            .foregroundColor(.black)
                        Text("Цена: " + ticket.price)
                            .font(.body)
                        Text(String(ticket.place.split(separator: ",")[0]) + " ряд, место " + String(ticket.place.split(separator: ",")[1]))
                            .font(.title3)
                        Text("Время: " + ticket.time)
                            .font(.title3)
                            .padding(.bottom)
                        Divider()
                    }
                    .padding(.leading)
                }
            }
            .navigationBarTitle(Text("Билеты"), displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: ComponentsView(), label: {
                Text("Компоненты")
                    .foregroundColor(.blue)
            }))
        }
    }
    
    func downloadTickets() {
        print("Downloading tickets")
        guard let curUser = Auth.auth().currentUser else { return }
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
                            self.tickets.append(userTicket)
                        }
                    }
                }
                self.ticketsLoaded = true
            }
        }
    }
}

struct BoughtTicketsView_Previews: PreviewProvider {
    static var previews: some View {
        BoughtTicketsView()
    }
}
