# AZRPv2



## About

The role of a client application is to participate in communicating with the server by accepting and processing forwarded rooms and messages, and sending a server request to create new rooms and messages when the user so requests. The client application includes a login window, a chat room, a talk room, a picture view, a location view, and a new room. The client application was created in the Xcode development environment and was written in Swift 4 programming language. Additional libraries (in Xcode CocoaPods) were used with the application code:

• Alamofire / AlamofireImage, principal author Christian Noon,
• Socket.IO-Client-Swift, principal author Damien Arrachequesne and Erik Little
• RxSwift / RxAlamofire, ReactiveX Reactive Extension for Async Programming,
• Starcream, lead author of Dalton,
• RealmSwift, principal author Nikola Irinchev and Thomas Goyne
• IQKeyboardManager, main author Mohd Iftekhar Qurashi


## Instalation

For this application to work, it needs a connection to server.
<a href="https://github.com/skomaromi/flack-server/tree/dev">Serverside</a>

After the server is installed, download the procject.
After the project is downloaded, open terminal and navigate to procjet folder.
Example:
```
cd /Users/user/Desktop/ProjectFile
```
After you have navigated, you need to run the following line in order to install CocoaPods required for the project:

```
pod install
```

After that, just open .xcworkspace file and you're ready to go!

### Note

Automatic connection to server is not fully implemented yet.
In order to connect to the server, in Xcode navigate to ProjectFile/Base/HelperValues/WebSocketAdress and in this class change the adress:

```swift
import Foundation

class WebSocketAdress {
let adress = "ws://0.0.0.0:8000/"
}
class ServerAdress {
let adress = "http://0.0.0.0:8000/"
let adressWithoutPort = "http://0.0.0.0:"

}
```
Replace the adress to the adress that the server has generated, and then run the app.


## Usage
The splash screen is displayed at the start of the application.

<img src="https://i.imgur.com/kSK4vM7.png" alt="SplashScreen" width="310" height="532">

Then a screen appears where the user asks for a login or a registration.

<img src="https://i.imgur.com/lepXKKm.png" alt="SplashScreen" width="310" height="532">


There are two buttons: Login and Register that are in the middle of the screen. If you are already a user of this service, go to Login. If you run for the first time, then press the Register key. After clicking on the Register, a screen appears as in the following picture:

<img src="https://i.imgur.com/L7PX75L.png" alt="SplashScreen" width="310" height="532">

On this screen you will find the fields that you need to fill in so that you can register. In this example, we will register as SampleUser. Enter the desired username in the field where gray letters are written. In the gray letter box, type Password, type the password you want (the length of the password must be at least 6 symbols).

<img src="https://i.imgur.com/PJs1xdG.png" alt="SplashScreen" width="310" height="532">

After you have entered your desired username and password, press Register. When you sign up successfully, the following screen opens. If there is an error, you will receive a description error as shown in the following illustration:

<img src="https://i.imgur.com/UZaeuS2.png" alt="SplashScreen" width="310" height="532">

When successful registration, the application takes you to the following screen:

<img src="https://i.imgur.com/PY4hXcC.png" alt="SplashScreen" width="310" height="532">


Here is a list of all your existing rooms (Rooms), since this is the first registration, it is necessary to create a new room. Pressing the "+" icon at the top right of the screen opens with a screen to create a new room.


<img src="https://i.imgur.com/zQKOtqb.png" alt="SplashScreen" width="310" height="532">

When creating a room, you need to write the name of the room (located under Name), and add the people you want to communicate with. Under Paricipants, there is a textField that you fill in and when you add, the "balloon" of the selected user appears. If you want to add more users, continue writing (text input indicator). When you are satisfied with the one you want to create, you can press the Create button located at the top right corner. If you want to stop creating a room, then Cancel from the top left. By adding Create, a new room is created and returns to the main screen with a newly created room. If you cancel the Cancel, just go back to the main screen without a new room.


<img src="https://i.imgur.com/kSK4vM7.png" alt="SplashScreen" width="310" height="532">

After the successful creation of the room you will see the first room on the screen of the room.

<img src="https://i.imgur.com/15sxPCq.png" alt="SplashScreen" width="310" height="532">

As can be seen from the picture, there is a room that was created and contains the name of the room, the name of the last person in the room (in this case, the person who created the room) and the time of the last message. When you click on that part, a chat screen opens.

<img src="https://i.imgur.com/rHDxVuW.png" alt="SplashScreen" width="310" height="532">

In this screen you can see the keyboard and above the toolbar to send the message. Left to right: There is a button to add an image, add a location, a large blank area is the place where a text message is entered, while the arrow on the right shows the button to send the message. Typing on the keyboard fills the void with the text that is being input:

<img src="https://i.imgur.com/qZM8YuF.png" alt="SplashScreen" width="310" height="532">

To send this message, just press the arrow above the keyboard on the gray toolbar on the right. And then the message is sent and you get the following look:


<img src="https://i.imgur.com/Lu6vAh9.png" alt="SplashScreen" width="310" height="532">

As you can see, it immediately shows who sends and which message, and when it is sent. Let's see what happens when the other side responds:

<img src="https://i.imgur.com/sQUELLz.png" alt="SplashScreen" width="310" height="532">

a person named admin answered the message. And it seems he has also sent the site. Whenever someone sends a location, the icon will appear in the upper right corner of the text "balloon". Clicking on that button opens a new screen where the user is located.

<img src="https://i.imgur.com/HxcjSdB.png" alt="SplashScreen" width="310" height="532">

In this screen, you can zoom in and out to see where the user is, when you are done, pressing the < sign in the upper left corner returns you back to the conversation.

<img src="https://i.imgur.com/ZWNoMpu.png" alt="SplashScreen" width="310" height="532">

admin has sent another message, with the picture! If you want to open an image, in the lower left corner of the textual "balloon" is the name of the image. By clicking on that name, I open a screen with you.

<img src="https://i.imgur.com/aPlpExY.png" alt="SplashScreen" width="310" height="532">

When you're done viewing a picture, pressing < sign in the upper left corner will bring you back to the conversation.
If you want to send an image, select the following button marked with a blue circle:

<img src="https://i.imgur.com/OfF534m.png" alt="SplashScreen" width="310" height="532">


After that, the application asks for permission to access your pictures, you choose OK:

<img src="https://i.imgur.com/u6w7HB5.png" alt="SplashScreen" width="310" height="532">

After selecting OK, select the image you want. When you have selected, Automatic returns to the admin chat and this time the image change icon indicates that the image is selected and ready to send

<img src="https://i.imgur.com/ykGIsyi.png" alt="SplashScreen" width="310" height="532">

Just as with the location, if you want to send the location, just click the location button next to the image button.

<img src="https://i.imgur.com/MEwOfhh.png" alt="SplashScreen" width="310" height="532">

Of course, as with the image, you must allow the app to use your location. It's up to you when and if you like, but in our case we only use it when using the app. So, we choose Only While Using the App. And then the same icon changes the color by making it known that it is ready to send!

<img src="https://i.imgur.com/wHTkUx7.png" alt="SplashScreen" width="310" height="532">

Now with all the fields filled, touch the Send button that is this arrow on the right side above the keyboard.

<img src="https://i.imgur.com/ZeFlsVG.png" alt="SplashScreen" width="310" height="532">

When you are finished typing, pressing the <sign in the upper left corner returns you back to the main message menu.

<img src="https://i.imgur.com/OIQoJ0s.png" alt="SplashScreen" width="310" height="532">
