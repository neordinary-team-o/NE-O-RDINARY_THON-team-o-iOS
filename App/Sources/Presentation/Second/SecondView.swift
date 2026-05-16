import SwiftUI

struct SecondView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("second")
                .font(.title2.bold())
            Text("Second tab placeholder")
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    SecondView()
}
