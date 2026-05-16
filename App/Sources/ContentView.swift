import SwiftUI
import PopupView

public struct ContentView: View {
    public init() {}
    
    @State var showPopupView = false
    @State var customAlertTrigger = false
    @State var showDropDown = false
    @State var showToast = false

    public var body: some View {
        ScrollView {
            VStack {
                Text("커스톰 드롭다운 메뉴")
//                    .asLiquidGlassButton {
//                        showDropDown.toggle()
//                    }
                    .asButton(style: BounceButtonStyle()) {
                        showDropDown.toggle()
                    }
                    .showDropDown(
                        isPresented: $showDropDown,
                        triggerGap: 0
                    ) {
                        customDropDownView
                    }
                Text("커스텀 얼럿")
                    .asLiquidGlassButton {
                        customAlertTrigger.toggle()
                    }

                Text("커스텀 토스트")
                    .asLiquidGlassButton {
                        showToast.toggle()
                    }
                
                Text("라이브러리 팝업")
                    .asLiquidGlassButton {
                        showPopupView.toggle()
                    }

                Text("Hello, World!")
                    .padding()
                
                Color.clear
                    .frame(height: 600)
                
                #if Dev
                Text("Dev Mode")
                #endif
                
                #if Prod
                Text("Prod Mode")
                #endif
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // Popup 예시
        .popup(isPresented: $showPopupView) {
            customPopupView
        } customize: {
            $0
                .animation(.bouncy)
                .appearFrom(.centerScale)
        }
        
        // Alert 예시
        .customAlert(isPresented: $customAlertTrigger) {
            VStack {
                Text("닫기").asButton {
                    customAlertTrigger.toggle()
                }
            }
            .frame(width: 300, height: 200)
            .background(Color.red)
        }
        // Toast 예시
        .showToast(isPresented: $showToast, position: .bottom) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                Text("저장되었습니다")
                    .foregroundStyle(.white)
            }
            .font(.system(size: 14, weight: .semibold))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.85))
            )
            .shadow(color: .black.opacity(0.18), radius: 8, y: 4)
        }
    }
}

// MARK: Custom
extension ContentView {
    /// DropDown 예시
    private var customDropDownView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("앨범 열기")
                .asButton {
                    showDropDown.toggle()
                }
            Text("이름 변경")
            Text("공유")
            Text("삭제")
                .foregroundStyle(.red)
        }
        .font(.system(size: 14, weight: .medium))
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.12), radius: 10, y: 4)
    }
    
    private var customPopupView: some View {
        VStack(alignment: .center) {
            Text("타이틀")
            Text("메시지")
            HStack {
                Text("OK")
                    .asButton {
                        showPopupView = false
                    }
                Text("cancel")
                    .asButton {
                        showPopupView = false
                }
            }
        }
        .background(Color.blue)
        .shadow(color: .black.opacity(0.12), radius: 10, y: 4)
    }
}

#Preview {
    ContentView()
}
