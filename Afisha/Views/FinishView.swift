//
//  FinishView.swift
//  Afisha
//
//  Created by Maxim Trunnikov on 10/28/20.
//

import SwiftUI
import Firebase

struct FinishView: View {    
    @State var go = false
    
    var body: some View {
        VStack {
            Text("Готово!")
                .font(.title)
                .padding()
            
            NavigationLink(
                destination: ContentView().navigationBarHidden(true), isActive: $go) { EmptyView() }
            
            Button(action: {
                self.go.toggle()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.yellow)
                        .frame(width: 200, height: 50, alignment: .center)
                        .shadow(color: .black, radius: 5)
                    Text("На главную")
                        .foregroundColor(.black)
                }
                .padding()
            }
        }
        
        
    }
}

struct FinishView_Previews: PreviewProvider {
    static var previews: some View {
        FinishView()
    }
}
