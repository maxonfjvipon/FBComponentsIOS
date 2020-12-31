//
//  SeatsView.swift
//  Afisha
//
//  Created by Maxim Trunnikov on 10/24/20.
//

import SwiftUI
import Firebase

struct SeatsView: View {
    var movie: Movie
    var cinema: Cinema
    var ticket: Ticket
    
    @State private var pressed: Bool = false
    @State private var chosenSeat: Seat = movies[0].cinemas[0].tickets[0].seats[0]
    
    @ViewBuilder
    var body: some View {
        
        ZStack (alignment: .bottom) {
            ScrollView {
                Divider()
                HStack {
                    VStack (alignment: .leading) {
                        Text(movie.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 1)
                        Text("Сегодня, " + ticket.time + " | " + cinema.name)
                            .foregroundColor(Color.gray)
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .foregroundColor(.white)
                                .frame(width: 140, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .shadow(radius: 10)
                            HStack {
                                SeatView(seatInRowCount: 20, isSeatFree: true)
                                Text(String(minPrice(for: ticket)) + " - " + String(maxPrice(for: ticket)) + " руб.")
                            }
                        }
                    }.padding()
                    Spacer()
                    
                }
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.gray)
                    .frame(width: 350, height: 8, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .shadow(radius: 10)
                    .padding(.top, 30)
                Text("Экран")
                    .foregroundColor(.gray)
                HallView(ticket: ticket, seats: setSeats(ticket: ticket), pressed: $pressed, chosenSeat: $chosenSeat)
                Spacer()
            }
            ConfirmView(pressed: $pressed, movie: movie, cinema: cinema, ticket: ticket, seat: chosenSeat)
                .animation(.easeOut(duration: 0.5))
        }.navigationBarTitle("Места")
        
        
    }
    
}

struct SeatsView_Previews: PreviewProvider {
    static var previews: some View {
        SeatsView(movie: movies[0], cinema: movies[0].cinemas[0], ticket: movies[0].cinemas[0].tickets[0])
    }
}

struct ConfirmView : View {
    @Binding var pressed: Bool
    var movie: Movie
    var cinema: Cinema
    var ticket: Ticket
    var seat: Seat = movies[0].cinemas[0].tickets[0].seats[0]
    @State var ticketAdded = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(String(seat.row) + " ряд, " + String(seat.num) + " место")
                        .foregroundColor(.black)
                    Spacer()
                    Text(String(seat.price) + " руб.")
                        .foregroundColor(.black)
                }
                .padding()
                Button(action: {
                    var _ticket = UserTicket()
                    _ticket.movie = movie.name
                    _ticket.cinema = cinema.name
                    _ticket.price = String(seat.price)
                    _ticket.place = String(seat.row) + "," + String(seat.num)
                    _ticket.time = ticket.time
                    add(ticket: _ticket)
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: UIScreen.main.bounds.width - 30, height: 50, alignment: .center)
                            .foregroundColor(.yellow)
                            .shadow(color: .black, radius: 5)
                        
                        Text("Купить")
                            .foregroundColor(.black)
                    }
                }
                NavigationLink(
                    destination: FinishView(), isActive: $ticketAdded) { EmptyView() }
            }
        }
        .opacity(pressed ? 1 : 0)
        .offset(y: pressed ? 0 : 100)
        .foregroundColor(.white)
        .frame(width: UIScreen.main.bounds.width, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        
    }
    
    func add(ticket: UserTicket) {
        guard let id = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let reference = db.collection("tickets").document(id)
        var count = 0;
        
        let ticketData: [String: String] = [
            "movie": ticket.movie,
            "cinema": ticket.cinema,
            "place": ticket.place,
            "time": ticket.time,
            "price": ticket.price
        ]
        
        reference.getDocument { (snapshot, error) in
            if error != nil {
                // error
            } else {
                guard snapshot != nil else { return }
                guard let data = snapshot?.data() else { return }
                
                count = data["tickets_count"] as? Int ?? 0
                
                reference.setData(["tickets_count":count + 1]) { (error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        print("Added successfully")
                        reference.collection("user_tickets").document(String(count + 1)).setData(ticketData) { (error) in
                            if error != nil {
                                print(error!.localizedDescription)
                            } else {
                                print("Added successfully")
                                self.ticketAdded = true
                            }
                        }
                    }
                }
            }
        }
    }
}

struct HallView : View {
    var ticket: Ticket = movies[0].cinemas[0].tickets[0]
    var seats: Set<Pos> = Set(arrayLiteral: Pos(row: 5, num: 5))
    @Binding var pressed: Bool
    @Binding var chosenSeat: Seat
    
    var body: some View {
        VStack {
            ForEach(0..<ticket.rowsCount) { row in
                HStack(alignment: .center) {
                    ForEach(0..<ticket.seatsInRow) { num in
                        if(seats.contains(Pos(row: row + 1, num: num + 1))) {
                            Button (action: {
                                if pressed {
                                    for seat in ticket.seats {
                                        if seat.row == row + 1 && seat.num == num + 1 {
                                            if
                                                chosenSeat == seat {
                                                self.pressed.toggle()
                                                break
                                            }
                                            chosenSeat = seat
                                            break
                                        }
                                    }
                                } else {
                                    self.pressed.toggle()
                                }
                            }) {
                                SeatView(seatInRowCount: ticket.seatsInRow, isSeatFree: true)
                                    .padding(.horizontal, -CGFloat(ticket.seatsInRow) / 100)
                            }
                        } else if (!seats.contains(Pos(row: row + 1, num: num + 1))) {
                            SeatView(seatInRowCount: ticket.seatsInRow, isSeatFree: false)
                                .padding(.horizontal, -CGFloat(ticket.seatsInRow) / 100)
                        }
                    }
                }.frame(height: CGFloat(ticket.rowsCount) * 3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
        }
    }
}
