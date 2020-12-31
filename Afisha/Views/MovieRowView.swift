//
//  MovieRowView.swift
//  MobLab3
//
//  Created by Maxim Trunnikov on 10/23/20.
//

import SwiftUI

struct MovieRowView: View {
    var movie: Movie
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            Text(movie.name)
                .font(.title)
            Text(movie.description)
                .font(.caption)
                .foregroundColor(.blue)
                .lineLimit(3)
            
        }
        .padding()
    }
}

struct MovieRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MovieRowView(movie: movies[0])
        }
    }
}
