//
//  MainViewSwiftUI.swift
//  PiPifier iOS
//
//  Created by Arno Appenzeller on 25.06.20.
//  Copyright © 2020 APPenzeller. All rights reserved.
//

import SwiftUI
import MessageUI


func createButton(action:@escaping (()->()),text:String,isDisabled:Bool,isAlertPresenting:Binding<Bool>, alert:Alert) -> some View{
    return  Button(action: action) {Text(text)}
        .padding(.vertical, 3.0)
        .padding(.horizontal, 20.0)
        .frame(width:270)
        .background(isDisabled ? Color.gray : Color.blue)
        .foregroundColor(.white)
        .cornerRadius(12)
            .disabled(isDisabled)
        .alert(isPresented: isAlertPresenting) {
            alert
        }
}

struct MainViewSwiftUI: View {
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State var showButtonAlert = false

    
    var body: some View {
        ScrollView(.vertical){
            HStack(alignment: .center){
                VStack{
                    VStack(spacing:10) {
                        Text("Welcome to PiPifier")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        VStack(spacing:10) {
                            Text("Installation:")
                                .font(.title)
                                .fontWeight(.heavy)
                            Text("1. Open Safari")
                                .fontWeight(.semibold)
                            Text("2. Open the Share menu:")
                                .fontWeight(.semibold)
                            Image("shareSheet")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.all, 1.0)
                                .frame(width: 200, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            Text("3. Choose Manage Extensions")
                                .fontWeight(.semibold)
                            Image("manageExt")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.all, 1.0)
                                .frame(width: 200, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            Text("4. Enable PiPifier")
                                .fontWeight(.semibold)
                            Image("activateWebExt")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.all, 1.0)
                                .frame(width: 200, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            Text("5. Run PiPifier on a website with a video:")
                                .fontWeight(.semibold)
                            Image("RunPipifierWebExt")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.all, 1.0)
                                .frame(width: 200, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                    }
                }
            }
        }
    }
}

struct MainViewSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        MainViewSwiftUI()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
                .previewDisplayName("iPhone 11 Pro")
            
            MainViewSwiftUI()
                .preferredColorScheme(.dark)
               .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
               .previewDisplayName("iPhone 11 Pro Dark")
            
            MainViewSwiftUI()
                .previewDevice("iPhone SE (2nd generation)")
                    .previewDisplayName("iPhone SE")
            

            MainViewSwiftUI()
                .previewDevice("iPad Pro (11-inch) (2nd generation)")
                    .previewDisplayName("iPad Pro (11-inch)")
        }
    }
}
