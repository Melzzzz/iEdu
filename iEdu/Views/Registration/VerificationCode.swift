//
//  VerificationCode.swift
//  iEdu
//
//  Created by Melisa Ibric on 10/16/20.
//

import SwiftUI
import Firebase

struct VerificationCode : View {
    
    @State private var code = String()
    @Binding var show: Bool
    @Binding var ID: String
    @State private var msg = String()
    @State private var alert = false
    @State private var creation = false
    @State private var loading = false
    
    var usersViewModel = UsersViewModel()
    
    var body : some View {
        
        ZStack(alignment: .topLeading) {
            GeometryReader { _ in
                VStack(spacing: 20) {
                    
                  //  Image("edu_pic")
                    
                    Text("Verification Code")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    
                    Text("Please Enter The Verification Code")
                        .font(.body)
                        .foregroundColor(Color(.lightGray))
                        .padding(.top, 12)
                    
                    TextField("Code", text: $code)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.lightGray))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.top, 15)
                    
                    if self.loading {
                        HStack {
                            Spacer()
                            Indicator()
                            Spacer()
                        }
                    } else {
                        Button(action: {
                            self.loading.toggle()
                            
                            let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code)
                            
                            Auth.auth().signIn(with: credential) { (res, err) in
                                
                                if err != nil {
                                    self.msg = (err?.localizedDescription)!
                                    self.alert.toggle()
                                    self.loading.toggle()
                                    return
                                }
                                
                                usersViewModel.checkUser { (exists, user, uid, pic) in
                                    if exists {
                                        UserDefaults.standard.set(true, forKey: "status")
                                        UserDefaults.standard.set(user, forKey: "UserName")
                                        UserDefaults.standard.set(uid, forKey: "UID")
                                        UserDefaults.standard.set(pic, forKey: "pic")
                                        
                                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                                    } else {
                                        self.loading.toggle()
                                        self.creation.toggle()
                                    }
                                }
                            }
                        }) {
                            Text("Verify")
                                .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                        }.foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                }
            }
            
            Button(action: {
                self.show.toggle()
            }) {     
                Image(systemName: "chevron.left")
                    .font(.title)
            }.foregroundColor(.blue)
        }
        .padding()
        .navigationBarTitle(String())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $alert) {
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
        .sheet(isPresented: $creation) {
            AccountCreation(show: $creation)
        }
    }
}
