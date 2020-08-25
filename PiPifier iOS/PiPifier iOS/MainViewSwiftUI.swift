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
                            Text("3. Choose Edit Actions...")
                                .fontWeight(.semibold)
                            Image("editActions")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.all, 1.0)
                                .frame(width: 200, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            Text("4. Enable PiPifier")
                                .fontWeight(.semibold)
                            Image("runPiPifierNew")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.all, 1.0)
                                .frame(width: 200, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            Text("5. Run PiPifier on a website with a video:")
                                .fontWeight(.semibold)
                            Image("executePiPifier")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.all, 1.0)
                                .frame(width: 200, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                    }
                    VStack(spacing:10) {
                        Text("About:")
                            .font(.title)
                            .fontWeight(.heavy)
                        Text("Pipifier is developed in the open and can be found on Github.")
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .padding()
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            HStack(spacing:10) {
                                if MFMailComposeViewController.canSendMail() {
                                    createButton(action:  {self.isShowingMailView.toggle()}, text: "Send Email", isDisabled: false, isAlertPresenting: $showButtonAlert,alert: Alert(title: Text(NSLocalizedString("Thanks!", comment: "thanks")), message: Text(NSLocalizedString("Hey it's Arno.\n I want to say a big thank you! With your tip you support me developping more cool stuff for iOS and macOS.\n Thank you for making this possible ❤️", comment: "personal notice")), dismissButton: .default(Text("OK"))))
                                }
                            }
                        }
                        else{
                            VStack(spacing:10) {
                                if MFMailComposeViewController.canSendMail() {
                                    createButton(action:  {self.isShowingMailView.toggle()}, text: "Send Email", isDisabled: false, isAlertPresenting: $showButtonAlert,alert: Alert(title: Text(NSLocalizedString("Thanks!", comment: "thanks")), message: Text(NSLocalizedString("Hey it's Arno.\n I want to say a big thank you! With your tip you support me developping more cool stuff for iOS and macOS.\n Thank you for making this possible ❤️", comment: "personal notice")), dismissButton: .default(Text("OK"))))
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingMailView) {
                    MailView(isShowing: self.$isShowingMailView, result: self.$result)
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
