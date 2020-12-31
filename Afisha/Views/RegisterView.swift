//
//  RegisterView.swift
//  Afisha
//
//  Created by Maxim Trunnikov on 12/4/20.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State private var registerSuccess = false
    @State private var error = false
    @State private var haveAnAccount = false
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
                register()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.orange)
                        .frame(width: 200, height: 50, alignment: .center)
                        .shadow(color: .black, radius: 5)
                    Text("Register")
                        .foregroundColor(.black)
                }
                .padding()
            }
            .alert(isPresented: $registerSuccess) {
                Alert(title: Text("Register Success"), dismissButton: .default(Text("Got it!")))
            }
            .sheet(isPresented: $registerSuccess, content: {
                LoginView()
            })
            .alert(isPresented: $error) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK!")))
            }
            Button(action: {
                self.haveAnAccount = true
            }) {
                Text("Already have an account?")
            }.sheet(isPresented: $haveAnAccount, content: {
                LoginView()
            })
        }.padding()
    }
    
    private func register() {
        self.error = false
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if err != nil {
                print(err!.localizedDescription)
                self.errorMessage = err!.localizedDescription
                self.error = true
            } else {
                self.registerSuccess = true
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
