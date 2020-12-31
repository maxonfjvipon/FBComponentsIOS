//
//  LoginView.swift
//  Afisha
//
//  Created by Maxim Trunnikov on 12/4/20.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State private var error = false
    @State private var loginSuccess = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Email: ")
                        .padding(1)
                        .font(.title3)
                    Text("Password:")
                        .font(.title3)
                }
                VStack {
                    TextField("Enter email", text: $email)
                        .font(.title3)
                        .autocapitalization(.none)
                    SecureField("Enter password", text: $password)
                        .font(.title3)
                        .autocapitalization(.none)
                }
            }.padding()
            Button(action: {
                login()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.green)
                        .frame(width: 200, height: 50, alignment: .center)
                        .shadow(color: .black, radius: 5)
                    Text("Log in")
                        .foregroundColor(.black)
                }
                
            }.padding()
            .alert(isPresented: $error) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK!")))
            }
            .sheet(isPresented: $loginSuccess) {
                return ContentView()
            }
        }.padding()
        .navigationTitle(Text("Login"))
    }
    
    private func login() {
        self.error = false
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if err != nil {
                print(err!.localizedDescription)
                self.errorMessage = err!.localizedDescription
                self.error = true
            } else {
                self.loginSuccess = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
