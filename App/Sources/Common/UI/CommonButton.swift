//
//  CommonButton.swift
//  App
//
//  Created by Jae hyung Kim on 5/16/26.
//

import SwiftUI

struct CommonButton: View {
    
    
    var title: String?
    var font: Font?
    var textColor: Color?
    var img: Image?
    var imgSize: CGSize?
    var verticalPadding: CGFloat = 16
    var backgroundColor: Color = AppColor.GreenNormal.color
    var onTap: () -> Void
    
    var body: some View {
        HStack {
            if let title {
                Text(title)
                    .font(font ?? AppFont.headline.font())
                    .foregroundStyle(textColor ?? AppColor.GrayScaleBlack.color )
            }
            Group {
                if let img {
                    img
                        .resizable()
                } else {
                    Image(AppImages.arrowRight)
                        .resizable()
                }
            }
            .frame(width: imgSize?.width ?? 20, height: imgSize?.height ?? 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, verticalPadding)
        .background(backgroundColor)
        .clipShape(Capsule())
        .asButton(action: onTap)
    }
}


#if DEBUG
#Preview {
    VStack {
        Spacer()
        CommonButton(title: "다음으로") {
            
        }
        Spacer()
    }
    .background(Color.black)
}
#endif
