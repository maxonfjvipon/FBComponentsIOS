//
//  ContentView.swift
//  MobLab3
//
//  Created by Maxim Trunnikov on 10/23/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(movies) { movie in
                    VStack {
                        NavigationLink(
                            destination: MovieDetailView(movie: movie)) {
                            MovieRowView(movie: movie)
                        }.foregroundColor(.black)
                        Divider()
                    }
                }
            }
            .navigationBarTitle(Text("Фильмы"), displayMode: .inline)
            .navigationBarItems(
                leading: NavigationLink(destination: MapView(), label: {
                    Text("Контакты")
                        .foregroundColor(.blue)
                }),
                trailing: NavigationLink(
                    destination: BoughtTicketsView(),
                    label: {
                        Text("Билеты")
                            .foregroundColor(.blue)
                    }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
