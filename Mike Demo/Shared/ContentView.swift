//
//  ContentView.swift
//  Shared
//
//  Created by Michael Bean on 01/10/2021.
//

import SwiftUI
import NewRelic

struct ContentView: View {
    @State private var username: String = ""
    @State private var attribute1: String = ""
    @State private var attribute2: String = ""
    @State private var message = ""
    
    enum MyError: Error {
        case error
    }
    
    enum HTTPError: Error {
        case transportError(Error)
        case serverSideError(Int)
    }

    func errorThrower() throws {
        throw MyError.error
    }
    
    var body: some View {
        Text("Mike's demo").font(.title)
        VStack {
            Spacer()
            Text(message).frame(height: 50)
            Spacer()
            Form {
                Section(header: Text("Set Username")) {
                    TextField("Username", text: $username)
                }
            }
            .frame(height: 100)
            Form {
                Section(header: Text("Network")) {
                    VStack {
                        Spacer()
                        Button(action: distributedTrace) {
                            HStack {
                                Spacer()
                                Text("Distributed Trace")
                                Spacer()
                            }
                        }
                        Spacer()
                        Button(action: networkError) {
                            HStack {
                                Spacer()
                                Text("Network Error")
                                Spacer()
                            }
                        }
                        Spacer()
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            Spacer()
            Form {
                Section(header: Text("Custom Event")) {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: customEvent) {
                                Text("Send")
                            }
                            Spacer()
                        }
                        Spacer()
                        TextField("Attribute 1", text: $attribute1)
                        TextField("Attribute 2", text: $attribute2)
                        Spacer()
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .frame(height: 200)
            Spacer()
            Form {
                Section(header: Text("Exceptions")) {
                    VStack {
                        Spacer()
                        Button(action: handleException) {
                            HStack {
                                Spacer()
                                Text("Handled Exception")
                                Spacer()
                            }
                        }
                        Spacer()
                        Button(action: crash) {
                            HStack {
                                Spacer()
                                Text("Crash")
                                Spacer()
                            }
                        }
                        Spacer()
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            Spacer()
        }
    }
    func startButtun(btn: String) -> Bool {
        var rtn = false;
        if (message.isEmpty) {
            rtn = true;
            message = "Processing..."
            if (!username.isEmpty) {
                NewRelic.setAttribute("user", value: username)
            }
            else {
                NewRelic.removeAttribute("user")
            }
        }
        if (username.isEmpty) {
            NewRelic.recordBreadcrumb("Button Tap " + btn, attributes:["button" : btn, "action" : "tapped", "location": "MasterViewController"])
        }
        else {
            NewRelic.recordBreadcrumb("Button Tap " + btn, attributes:["button" : btn, "username" : username, "action" : "tapped", "location": "MasterViewController"])
            
        }
        print(btn);
        return rtn;
    }
    func endButton() {
        message = ""
    }
    func callURL(urlString: String) {
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let error = error {
                NewRelic.recordError(error)
            }
            else {
                let response = response as! HTTPURLResponse
                let status = response.statusCode
                if (200...299).contains(status) {
                    if let data = data {
                        print(String(data: data, encoding: .utf8)!)
                    }
                }
                else {
                    NewRelic.recordError(HTTPError.serverSideError(status))
                }
            }
            endButton()
        }
        task.resume()
    }
    func distributedTrace() {
        if (startButtun(btn: "Distributed Trace")) {
            callURL(urlString: "http://localhost:3001/webrequest")
        }
    }
    func customEvent() {
        if (startButtun(btn: "Custom Event")) {
            var at1 = "NULL"
            var at2 = "NULL"
            if (!attribute1.isEmpty) {
                at1 = attribute1 }
            if (!attribute2.isEmpty) {
                at2 = attribute2 }
            NewRelic.recordCustomEvent("MobileCustomAttribute", attributes: ["attribute1" : at1, "attribute2": at2])
            endButton()
        }
    }
    func networkError() {
        if (startButtun(btn: "Network Error")) {
            callURL(urlString: "https://leasestar-api.realpage.com/jsp/configElements")
        }
    }
    func handleException() {
        if (startButtun(btn: "Handle Exception")) {
            //A do-catch block to try a method and catch its error
            do {
                let randomInt = Int.random(in: 0..<10)
                if (randomInt < 3) {
                    try errorThrower()
                }
                else {
                    throw MyError.error
                }
            } catch {
                print("This error was caught, send it to NR")
                NewRelic.recordError(error)
            }
            endButton()
        }
    }
    func crash() {
        if (startButtun(btn: "Crash")) {
            let number: Int? = nil
            let val = number!
            print(val)
            endButton()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
