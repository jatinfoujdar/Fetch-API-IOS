

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
            Spacer()
            Text("Contacts")
            Spacer()
            Image(systemName: "magnifyingglass")
        }
        .padding()
    }
}

#Preview {
    HeaderView()
}
