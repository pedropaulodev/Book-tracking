//
//  EditBookView.swift
//  Mybooks
//
//  Created by PEDRO PAULO DA SILVA on 25/06/24.
//

import SwiftUI

struct EditBookView: View {
    @Environment(\.dismiss) private var dismiss
    let book: Book
    //MARK: Propriedades de estado
    // propriedades de estado que serao vinculadas as dos livros para atualiza-los, passando valores defout, menos a rating
    @State private var status = Status.onShelf
    @State private var rating: Int?
    @State private var title = ""
    @State private var author = ""
    @State private var summary = ""
    @State private var dateAdded = Date.distantPast
    @State private var dateStarted = Date.distantPast
    @State private var dateCompleted = Date.distantPast
    @State private var firstView = true
    
    var body: some View {
        //MARK: Modificador do estado do livro
        HStack{
            Text("Status")
            Picker("Status", selection: $status){ //picker = selecionador
                ForEach(Status.allCases) {status in // o selecionador vai passar por todos os casos da propriedade status
                    Text(status.descr).tag(status)// e possibilitar a selecao de qualquer um deles
                }
            }
            .buttonStyle(.bordered)
        }
        //MARK: mostraremos as datas relevantes de acordo com o status
        VStack(alignment: .leading){
            GroupBox{ //cria uma caixa ao redor do conteudo
                LabeledContent { // permite criar um rotulo aos conteudos que no caso e um seletor de data, e vinculamos ele a variavel de estado.
                    DatePicker("", selection: $dateAdded, displayedComponents: .date)
                } label: { // o rotulo
                    Text("Date Added")
                }
                // por padrao sempre mostramos a data de criacao, porem para as datas de comeco e termino de livro colocamos condicoes
                if status == .inProgress || status == .completed {
                    LabeledContent {
                        DatePicker("", selection: $dateStarted, in: dateAdded..., displayedComponents: .date) //in dateaddes... nao permite q coloque data de comeco antes da data de adicao do livro
                    } label: {
                        Text("Date Started")
                    }
                }
                if status == .completed {
                    LabeledContent {
                        DatePicker("", selection: $dateCompleted, in: dateStarted..., displayedComponents: .date)//in: dateStarted..., nao permite que a data de completar o livro possa ser setada para antes da data de inicio
                    } label: {
                        Text("Date Completed")
                    }
                }
            }
            .foregroundStyle(.secondary)
            //MARK: utilizaremos o onChange para redefinir as datas quando por exemplo quisermos passar de em progresso para a prateleira novamente
            .onChange(of: status){ oldValue, newValue in
                if !firstView{
                    if newValue == .onShelf { // se o livro voltar pra prateleira as outras datas zeram
                        dateCompleted = Date.distantPast
                        dateCompleted = Date.distantPast
                    } else if newValue == .inProgress && oldValue == .completed { // voltou a ser lido
                        dateCompleted = Date.distantPast
                    } else if newValue == .inProgress && oldValue == .onShelf { // comecou a ler o livro
                        dateStarted = Date.now
                    } else if newValue == .completed && oldValue == .onShelf { // esqueceu de comecar
                        dateCompleted = Date.now
                        dateStarted = dateAdded
                    } else { //completou
                        dateCompleted = Date.now
                    }
                    firstView = false
                }
            }
            Divider()
            //MARK: criamos campos para atualizar o titulo
            LabeledContent{ //chamamos a view de avaliacao e passamos para ela qtd de estrelas, o vinculo(binding da nossa propriedade) e o tamanho
                RatingsView(maxRating: 5, currentRating: $rating, width: 30)
            } label: {
                Text("Rating")
            }
            LabeledContent{
                TextField("", text: $title)
            } label: {
                Text("Title").foregroundStyle(.secondary)
            }
            LabeledContent{// atualizar o autor
                TextField("", text: $author)
            } label: {
                Text("Author").foregroundStyle(.secondary)
            }
            Divider() // e criar o sumario
            Text("Sumary").foregroundStyle(.secondary)
            TextEditor(text: $summary)
                .padding(5)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2))
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if changed {
                Button("Update"){
                    book.status = status
                    book.rating = rating
                    book.title = title
                    book.author = author
                    book.summary = summary
                    book.dateAdded = dateAdded
                    book.dateStarted = dateStarted
                    book.dateCompleted = dateCompleted
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }//MARK: qndo o livro aparecer, vamos setar as propriedades de estado para aquelas que temos no nossa entidade book, assim as propriedades de estados vao ser capazes de mostrar os dados que estao no banco de dados
        .onAppear(){
            //MARK: afasdsadsaaeqqeqweqe
            status = book.status
            rating = book.rating
            title = book.title
            author = book.author
            summary = book.summary
            dateAdded = book.dateAdded
            dateStarted = book.dateStarted
            dateCompleted = book.dateCompleted
        }
    }
    //MARK: o botao de atualizar so vai aparecer se alguma das propriedades acima mudar e para isso faremos a verificacao se cada propriedade de estado esta diferente da propriedade da entidade livro
    var changed: Bool {
        status != book.status
       || rating != book.rating
       || title != book.title
       || author != book.author
       || summary != book.summary
       || dateAdded != book.dateAdded
       || dateStarted != book.dateStarted
       || dateCompleted != book.dateCompleted
    }
}

//#Preview {
//    NavigationStack{
//        EditBookView()
//    }
//}
