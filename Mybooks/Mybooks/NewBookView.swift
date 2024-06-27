//
//  NewBookView.swift
//  Mybooks
//
//  Created by PEDRO PAULO DA SILVA on 25/06/24.
//

import SwiftUI

struct NewBookView: View {
    //chamamos a wrapper para utilizar o contexto do container
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var author = ""

    var body: some View {
        NavigationStack{
            Form{
                TextField("Book Title", text: $title)
                TextField("Author", text: $author)
                Button("Create"){
                    //cria um obj livro com os valores inseridos no imput
                    let newBook = Book(title: title, author: author)
                    //salva o obj no bd atraves do contexto do container
                    context.insert(newBook)
                    dismiss()
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                .padding(.vertical)
                .disabled(title.isEmpty || author.isEmpty)
                .navigationTitle("New Book")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .topBarLeading){
                        Button("Cancel"){
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NewBookView()
}
