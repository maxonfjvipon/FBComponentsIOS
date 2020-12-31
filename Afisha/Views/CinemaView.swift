//
//  CinemaView.swift
//  Afisha
//
//  Created by Maxim Trunnikov on 10/24/20.
//

import SwiftUI

struct CinemaView: View {
    var movie: Movie
    var cinema: Cinema
    @ViewBuilder
    var body: some View {
        VStack(alignment: .leading) {
            Text(cinema.name)
                .font(.title2)
            Text(cinema.address)
                .font(.callout)
                .foregroundColor(Color.gray)
            VStack {
                ForEach(0..<timeRowCount(for: cinema)) { i in
                    HStack {
                        ForEach(0..<4) { j in
                            if (i * 4 + j < cinema.tickets.count) {
                                NavigationLink(
                                    destination: SeatsView(movie: movie, cinema: cinema, ticket: cinema.tickets[i * 4 + j])) {
                                    TimeView(ticket: cinema.tickets[i * 4 + j])
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct CinemaView_Previews: PreviewProvider {
    static var previews: some View {
        CinemaView(movie: movies[0], cinema: movies[0].cinemas[0])
    }
}
