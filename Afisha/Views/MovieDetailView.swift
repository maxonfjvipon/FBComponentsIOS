//
//  MovieDetailView.swift
//  MobLab3
//
//  Created by Maxim Trunnikov on 10/23/20.
//

import SwiftUI

struct MovieDetailView: View {
    var movie: Movie
    
    func outOfBounds(index: Int) -> Bool {
        return true
        //        return movie.tickets.count > index
    }
    
    var body: some View {
        VStack() {
            ScrollView {
                // todo image
                Divider()
                Text("Description: ").bold() + Text(movie.description)
                Divider()
                NavigationLink(destination: ScheduleView(movie: movie)) {
                    ZStack {
                        RoundedRectangle(cornerRadius:20)
                            .foregroundColor(.yellow)
                            .frame(width: 300, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding()
                        Text("Билеты от " + String(minPrice(for: movie)) + " руб.")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                }
                
            }
        }
        .padding(.horizontal)
        .navigationBarTitle(movie.name, displayMode: .inline)
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: movies[0])
    }
}
