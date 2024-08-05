import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Note: Identifiable, Codable {
    var id: String
    var content: String
    var date: Date
}

struct NotesView: View {
    @State private var notes: [Note] = []
    @State private var newNoteContent: String = ""
    @State private var errorMessage: String = ""
    @State private var editingNote: Note? = nil
    @State private var editingContent: String = ""
    @State private var selectedDate: Date = Date()

    private let db = Firestore.firestore()

    var body: some View {
        VStack {
            List {
                ForEach(notes) { note in
                    VStack(alignment: .leading) {
                        if editingNote?.id == note.id {
                            HStack {
                                TextField("Edit note...", text: $editingContent)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.trailing, 8)
                                
                                Button(action: {
                                    saveEdit(note.id)
                                }) {
                                    Text("Save")
                                        .foregroundColor(.green)
                                        .fontWeight(.bold)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Button(action: {
                                    deleteNote(with: note.id)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.bottom, 5)
                            
                            DatePicker("Select Date:", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .frame(maxWidth: .infinity)
                                .padding(.top, 5)
                        } else {
                            HStack {
                                Text(note.content)
                                    .padding(.trailing, 8)
                                
                                Spacer()
                                
                                Button(action: {
                                    startEditing(note, date: note.date)
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.blue)
                                        .font(.title2)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Button(action: {
                                    deleteNote(with: note.id)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.vertical, 5)
                            
                            Text("Date: \(note.date, formatter: dateFormatter)") // Display note date
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }

            TextField("Enter your note here...", text: $newNoteContent)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: addNote) {
                Image(systemName: "plus")
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
            .padding()
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onAppear(perform: loadNotes)
    }

    private func loadNotes() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(userID).collection("notes")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    self.errorMessage = "Error fetching notes: \(error.localizedDescription)"
                    return
                }

                guard let documents = snapshot?.documents else {
                    self.notes = []
                    return
                }

                self.notes = documents.compactMap { document in
                    try? document.data(as: Note.self)
                }
            }
    }

    private func addNote() {
        guard let userID = Auth.auth().currentUser?.uid else {
            self.errorMessage = "You must be logged in to add a note."
            return
        }

        let newNote = Note(id: UUID().uuidString, content: newNoteContent, date: Date())
        do {
            _ = try db.collection("users").document(userID).collection("notes").addDocument(from: newNote)
            newNoteContent = ""
        } catch {
            self.errorMessage = "Error adding note: \(error.localizedDescription)"
        }
    }

    private func deleteNote(with id: String) {
        guard let userID = Auth.auth().currentUser?.uid else {
            self.errorMessage = "You must be logged in to delete a note."
            return
        }

        db.collection("users").document(userID).collection("notes")
            .whereField("id", isEqualTo: id)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        print("Error retrieving documents: \(error.localizedDescription)")
                        self.errorMessage = "Error retrieving documents: \(error.localizedDescription)"
                    }
                    return
                }

                guard let documents = snapshot?.documents else {
                    DispatchQueue.main.async {
                        print("No documents found for the specified id.")
                        self.errorMessage = "No documents found for the specified id."
                    }
                    return
                }

                for document in documents {
                    document.reference.delete { error in
                        if let error = error {
                            DispatchQueue.main.async {
                                print("Error deleting note: \(error.localizedDescription)")
                                self.errorMessage = "Error deleting note: \(error.localizedDescription)"
                            }
                        } else {
                            DispatchQueue.main.async {
                                print("Note successfully deleted")
                                
                                if let index = self.notes.firstIndex(where: { $0.id == id }) {
                                    self.notes.remove(at: index)
                                }
                            }
                        }
                    }
                }
            }
    }

    private func startEditing(_ note: Note, date: Date) {
        editingNote = note
        editingContent = note.content
        selectedDate = date
    }

    private func saveEdit(_ id: String) {
        guard let userID = Auth.auth().currentUser?.uid else {
            self.errorMessage = "You must be logged in to edit a note."
            return
        }

        db.collection("users").document(userID).collection("notes")
            .whereField("id", isEqualTo: id)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        print("Error retrieving documents: \(error.localizedDescription)")
                        self.errorMessage = "Error retrieving documents: \(error.localizedDescription)"
                    }
                    return
                }

                guard let documents = snapshot?.documents else {
                    DispatchQueue.main.async {
                        print("No documents found for the specified id.")
                        self.errorMessage = "No documents found for the specified id."
                    }
                    return
                }

                for document in documents {
                    document.reference.updateData([
                        "content": editingContent,
                        "date": selectedDate
                    ]) { error in
                        if let error = error {
                            DispatchQueue.main.async {
                                print("Error updating note: \(error.localizedDescription)")
                                self.errorMessage = "Error updating note: \(error.localizedDescription)"
                            }
                        } else {
                            DispatchQueue.main.async {
                                print("Note successfully updated")
                                if let index = self.notes.firstIndex(where: { $0.id == id }) {
                                    self.notes[index].content = editingContent
                                    self.notes[index].date = selectedDate
                                    editingNote = nil
                                    editingContent = ""
                                }
                            }
                        }
                    }
                }
            }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
