//
//  ScheduleView.swift
//  Afisha
//
//  Created by Maxim Trunnikov on 10/24/20.
//

import SwiftUI

struct ScheduleView: View {
    var movie: Movie
    var body: some View {
        ScrollView {
            Divider()
            VStack(alignment: .leading) {
                ForEach(movie.cinemas) { cinema in
                    
                    CinemaView(movie: movie, cinema: cinema)
                        .padding()
                    Divider()
                }
            }
        }.navigationBarTitle("Расписание")
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(movie: movies[0])
    }
}
