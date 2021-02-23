//
//  NewPost.swift
//  iEdu
//
//  Created by Melisa Ibric on 2/22/21.
//

import SwiftUI

struct NewPost: View {
    @StateObject var newPostViewModel = NewPostViewModel()
    @Environment(\.presentationMode) var present
    @Binding var updateId: String
    @AppStorage("isDarkMode") var isDarkMode: Bool = true
    
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Button(action: {
                    self.updateId = String()
                        present.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                Spacer(minLength: 0)
                
                if updateId == String() {
                    Button(action: { newPostViewModel.picker.toggle() }) {
                        Image(systemName: "photo.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
                
                Button(action: { newPostViewModel.post(updateId: updateId, present: present) }) {
                    Text("Post")
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }.padding()
            .opacity(newPostViewModel.isPosting ? 0.5 : 1)
            .disabled(newPostViewModel.isPosting)
            
            TextEditor(text: $newPostViewModel.postTxt)
                .cornerRadius(15)
                .padding()
                .opacity(newPostViewModel.isPosting ? 0.5 : 1)
                .disabled(newPostViewModel.isPosting)
            
            if newPostViewModel.imgData.count != 0 {
                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                    Image(uiImage: UIImage(data: newPostViewModel.imgData)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width / 2, height: 150)
                        .cornerRadius(15)
                    
                    Button(action: { newPostViewModel.imgData = Data(count: 0) }) {
                        Image(systemName: "xmark")
                            .padding(10)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }.padding()
                .opacity(newPostViewModel.isPosting ? 0.5 : 1)
                .disabled(newPostViewModel.isPosting)
            }
        }
        .background(isDarkMode ? Color.white.opacity(0.06) : Color.black.opacity(0.06))
        .sheet(isPresented: $newPostViewModel.picker) {
            ImagePicker(picker: $newPostViewModel.picker, imagedata: $newPostViewModel.imgData)
        }.modifier(DarkModeViewModifier())
    }
}
