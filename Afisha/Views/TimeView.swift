//
//  TimeView.swift
//  Afisha
//
//  Created by Maxim Trunnikov on 10/24/20.
//

import SwiftUI

struct TimeView: View {
    var ticket: Ticket
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.yellow)
                .frame(width: 80, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Text(ticket.time)
                .foregroundColor(.black)
        }
    }
}

struct TimeView_Previews: PreviewProvider {
    static var previews: some View {
        TimeView(ticket: movies[0].cinemas[0].tickets[0])
    }
}
