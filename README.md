# Example Swift iOS Mobile App instrumented by New Relic
This project provides an example Swift iOS Mobile App instrumented by New Relic, which can be used for demos or as a play app. It includes two Node.js apps, which can be used to demo distributed tracing.

## How it works
The App has one simple screen that enables you to:
- Set your username.
- Send a distributed trace via the two Node.js apps.
- Create a network error.
- Send a custom event.
- Create a handled exception.
- Create a crash.

## Setup
Perform the following steps:
- Clone the repo.
- Open the app in Xcode.
- Create a Plist (Property List) file called `Keys.plist` in the `Shared` folder.
- Add your New Relic mobile key to the PList file with the name `newRelicKey`.
- On a command line go to the `backendservice_firsthop` folder and copy `newrelic.js.template` to `newrelic.js`.
- Edit the `newrelic.js` file to add your New Relic ingest key.
- Run `npm install`.
- Run `npm start` to start the `backendservice_firsthop` Node.js app.
- Repeat the above steps for the `backendservice_secondhop` Node.js app.
- Run the iOS app on your simulator.
