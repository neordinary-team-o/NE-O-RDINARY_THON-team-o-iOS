import SwiftUI

struct MyPageView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("myPage")
                .font(.title2.bold())
            Text("MyPage tab placeholder")
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    MyPageView()
}
