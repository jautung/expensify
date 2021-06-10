import SwiftUI

struct CategoriesView: View {
    @Binding var categories: Array<String>
    @State var addCategoryShowAlert: Bool = false
    @State var editCategoryShowAlert: Bool = false
    @State var editCategoryIndex: Int = -1
    @State var deleteCategoryShowAlert: Bool = false
    @State var deleteCategoryIndex: Int = -1

    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                H1Text(text: "Categories")
                ScrollView(showsIndicators: true) {
                    VStack {
                        ForEach(categories.indices, id: \.self) { categoryIndex in
                            CustomDivider()
                            HStack {
                                Spacer()
                                H2Text(text: categories[categoryIndex]).frame(width: 280, height: 40, alignment: .leading)
                                Button(action: { // edit button
                                    editCategoryIndex = categoryIndex
                                    editCategoryShowAlert = true
                                }) { SystemImage(name: "pencil.circle.fill") }
                                Button(action: { // delete button
                                    deleteCategoryIndex = categoryIndex
                                    deleteCategoryShowAlert = true
                                }) { SystemImage(name: "xmark.circle.fill") }
                                Spacer(minLength: 5)
                            }
                        }
                        CustomDivider()
                        Button(action: { // add button
                            addCategoryShowAlert = true
                        }) { SystemImage(name: "plus.circle.fill") }
                    }
                }
            }
            if addCategoryShowAlert {
                AlertControlView(
                    showAlert: $addCategoryShowAlert,
                    title: "Add Category",
                    message: "",
                    confirmation: "Add",
                    placeholder: "New category",
                    submitCallback: { (addCategory: String) in
                        categories.append(addCategory)
                    }
                )
            }
            if editCategoryShowAlert {
                AlertControlView(
                    showAlert: $editCategoryShowAlert,
                    title: "Edit Category (\(categories[editCategoryIndex]))",
                    message: "Warning: This will modify XXX expense entries!",
                    confirmation: "Edit",
                    placeholder: "New name",
                    submitCallback: { (editedName: String) in
                        categories[editCategoryIndex] = editedName
                    }
                )
            }
            if deleteCategoryShowAlert {
                AlertControlView(
                    showAlert: $deleteCategoryShowAlert,
                    title: "Delete Category (\(categories[deleteCategoryIndex]))",
                    message: "Warning: This will irreversibly move XXX expense entries to 'Others'!",
                    confirmation: "Delete",
                    placeholder: nil,
                    submitCallback: { _ in
                        categories.remove(at: deleteCategoryIndex)
                    }
                )
            }
        }
    }
}
