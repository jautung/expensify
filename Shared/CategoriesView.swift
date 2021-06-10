import SwiftUI

struct CategoriesView: View {
    @ObservedObject var expensifyData: ExpensifyData
    @State var addCategoryShowAlert: Bool = false
    @State var editCategoryShowAlert: Bool = false
    @State var editCategoryId: String = ""
    @State var deleteCategoryShowAlert: Bool = false
    @State var deleteCategoryId: String = ""

    var body: some View {
        let categories = expensifyData.getCategories()
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
                                H2Text(text: categories[categoryIndex].name).frame(width: 280, height: 40, alignment: .leading)
                                Button(action: { // edit button
                                    editCategoryId = categories[categoryIndex].id
                                    editCategoryShowAlert = true
                                }) { SystemImage(name: "pencil.circle.fill", size: 30) }
                                Button(action: { // delete button
                                    deleteCategoryId = categories[categoryIndex].id
                                    deleteCategoryShowAlert = true
                                }) { SystemImage(name: "xmark.circle.fill", size: 30) }
                                Spacer(minLength: 5)
                            }
                        }
                        CustomDivider()
                        Button(action: { // add button
                            addCategoryShowAlert = true
                        }) { SystemImage(name: "plus.circle.fill", size: 30) }
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
                    submitCallback: { (newName: String) in
                        expensifyData.addCategory(newName: newName)
                    }
                )
            }
            if editCategoryShowAlert {
                AlertControlView(
                    showAlert: $editCategoryShowAlert,
                    title: "Edit Category (\(expensifyData.getCategory(id: editCategoryId)))",
                    message: "Warning: This will modify \(expensifyData.getCategoryCount(id: editCategoryId)) expense entries!",
                    confirmation: "Edit",
                    placeholder: "New name",
                    submitCallback: { (newName: String) in
                        expensifyData.editCategory(id: editCategoryId, newName: newName)
                    }
                )
            }
            if deleteCategoryShowAlert {
                AlertControlView(
                    showAlert: $deleteCategoryShowAlert,
                    title: "Delete Category (\(expensifyData.getCategory(id: deleteCategoryId)))",
                    message: "Warning: This will irreversibly move \(expensifyData.getCategoryCount(id: deleteCategoryId)) expense entries to 'Others'!",
                    confirmation: "Delete",
                    placeholder: nil,
                    submitCallback: { _ in
                        expensifyData.deleteCategory(id: deleteCategoryId)
                    }
                )
            }
        }
    }
}
