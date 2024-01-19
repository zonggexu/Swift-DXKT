//
//  AddBluetoothKey_V.swift
//  TNXwatchOS Watch App
//  添加蓝牙钥匙页面
//  Created by 宗森 on 2023/9/11.
//

import SwiftUI

struct AddBluetoothKey_V: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var callback: (String) -> Void
    var body: some View {
        NavigationView {
            VStack {
                Image(.commonUserHeaderImagePlace)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(15)
                    .padding()

                VStack {
                    Button {
                        SLog("你好")
                        callback("你好")
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("AddKeyV_AddKey")
                            .font(.footnote)
                            .frame(width: 150, height: 30) // 自定义宽度和高度
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                    .buttonStyle(.plain)

                    Text("asdasd")
                    Spacer(minLength: 20)
                    Text("你好")
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    AddBluetoothKey_V(callback:{ _ in
        
    })
}
