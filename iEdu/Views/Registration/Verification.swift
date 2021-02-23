//
//  Verification.swift
//  iEdu
//
//  Created by Melisa Ibric on 10/16/20.
//

import SwiftUI
import Firebase

struct Verification : View {
    
    @State var code = String()
    @State var no = String()
    @State var show = false
    @State var msg = String()
    @State var alert = false
    @State var ID = String()
    
    var body : some View {
        VStack(spacing: 20) {
            
          //  Image("edu_pic")
           //     .frame(width: 25, height: 25)
            
            Text("Verify Your Number")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            Text("Please Enter Your Number To Verify Your Account")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 12)
            
            HStack {
                
                TextField("+1", text: $code)
                    .keyboardType(.numberPad)
                    .frame(width: 45)
                    .padding()
                    .background(Color(.lightGray))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                TextField("Number", text: $no)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color(.lightGray))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
            }.padding(.top, 15)
            
            NavigationLink(destination: VerificationCode(show: $show, ID: $ID), isActive: $show) {
                Button(action: {
                    
                    Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                    
                    PhoneAuthProvider.provider().verifyPhoneNumber("+" + self.code + self.no, uiDelegate: nil) { (ID, err) in
                        
                        if err != nil {
                            self.msg = (err?.localizedDescription)!
                            self.alert.toggle()
                            return
                        }
                        
                        self.ID = ID!
                        self.show.toggle()
                    }
                }) {
                    Text("Send")
                        .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                }.background(Color.blue)
                .cornerRadius(10)
            }.navigationBarTitle(String())
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }.padding()
        .alert(isPresented: $alert) {
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
    }
}
