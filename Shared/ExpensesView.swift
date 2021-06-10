import SwiftUI

struct ExpensesView: View {
    @ObservedObject var expensifyData: ExpensifyData
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                H1Text(text: "Expenses")
                Spacer() // flushes VStack to the top
            }
        }
    }
}
