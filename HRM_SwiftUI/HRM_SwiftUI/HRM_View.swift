//
//  HRM_View.swift
//  HRM_SwiftUI
//
//  Created by Vince Mansel on 8/30/21.
//

import SwiftUI

struct HRM_View: View {
    var body: some View {
        VStack {
            Text("DIGG Heart Rate Monitor")
                .font(.title)
                .foregroundColor(.blue)
            
            Divider()
            
            HStack {
                
                VStack {
                    Text("Heart Rate")
                    Text("----")
                }
                .padding()
                .frame( maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, idealHeight: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                Divider()
                
                VStack {
                    Text("Body Location")
                    Text("----")
                }
                .padding()
                .frame( maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, idealHeight: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            .frame(height: 200)
            
            VStack {
                Text("Status")
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15.0)
                        .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                        .padding()
                        .foregroundColor(.green)
                    
                    Text("Scrollable status")
                        .italic()
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
            }

            
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 15.0)
                    .padding()
                    .foregroundColor(.green)

                Text("Line Graph: HR vs. Time")
                    .italic()
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                
            }
        }
    }
}

struct HRM_View_Previews: PreviewProvider {
    static var previews: some View {
        HRM_View()
    }
}
