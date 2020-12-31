//
//  HallView.swift
//  Afisha
//
//  Created by Maxim Trunnikov on 10/28/20.
//

import SwiftUI

struct HallView: View {
    var ticket: Ticket
    var seat: Set<Pos>
    
    @Binding var pressed: Bool
    
    @ViewBuilder
    var body: some View {
        VStack {
            ForEach(0..<ticket.rowsCount) { row in
                HStack(alignment: .center) {
                    ForEach(0..<ticket.seatsInRow) { num in
                        if(seat.contains(Pos(row: row + 1, num: num + 1))) {
                            Button (action: {
                                self.pressed.toggle()
                            }) {
                                SeatView(seatInRowCount: ticket.seatsInRow, isSeatFree: true)
                                    .padding(.horizontal, -CGFloat(ticket.seatsInRow) / 100)
                            }
                        } else if (!seat.contains(Pos(row: row + 1, num: num + 1))) {
                            SeatView(seatInRowCount: ticket.seatsInRow, isSeatFree: false)
                                .padding(.horizontal, -CGFloat(ticket.seatsInRow) / 100)
                        }
                    }
                }.frame(height: CGFloat(ticket.rowsCount) * 3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct HallView_Previews: PreviewProvider {
    static var previews: some View {
        HallView(ticket: movies[0].cinemas[0].tickets[0], seat: Set(arrayLiteral: Pos(row: 3, num: 3)), pressed: Binding(Bool(false)))
    }
}
