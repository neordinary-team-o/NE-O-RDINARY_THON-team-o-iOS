import SwiftUI

struct WatchContentView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Hello Watch")
                .font(.headline)
            
            Text(Date(), style: .time)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    WatchContentView()
}
