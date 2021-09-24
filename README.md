<p align="center">
  <a href="" rel="noopener">
 <img src="https://i.imgur.com/AZ2iWek.png" alt="Project logo"></a>
</p>
<h3 align="center">Drink & Talk</h3>

<div align="center">

[![Hackathon](https://img.shields.io/badge/hackathon-IH-orange.svg)](http://hackathon.url.com)
[![Status](https://img.shields.io/badge/status-done-success.svg)]()

</div>

---

## 📝 Table of Contents

- [📝 Table of Contents](#-table-of-contents)
- [🧐 Problem Statement <a name = "problem_statement"></a>](#-problem-statement-)
- [💡 Idea / Things I did <a name = "idea"></a>](#-idea--things-i-did-)
- [🚀 Future Scope <a name = "future_scope"></a>](#-future-scope-)
- [🏁 Getting Started <a name = "getting_started"></a>](#-getting-started-)
  - [Prerequisites](#prerequisites)
  - [Recommendations](#recommendations)
- [⛏️ Built With <a name = "tech_stack"></a>](#️-built-with-)
- [✍️ Authors <a name = "authors"></a>](#️-authors-)
- [🎉 Acknowledgments <a name = "acknowledgments"></a>](#-acknowledgments-)

## 🧐 Problem Statement <a name = "problem_statement"></a>

We were given a specific design and a PDF file containing some specifications that had to be met.
It was up to us to create the mobile app fullfilling those specifications using any language/framework we wanted for both Frontend and Backend.

## 💡 Idea / Things I did <a name = "idea"></a>

Some of the many things I worked on were:
1. Making sure to fullfill all the specifications given
2. Making the design match perfectly
3. Added tests
4. Added some nice animations
5. Localization
6. Check for various edge cases, such as
   1. Users having same names
   2. Users not submitting names
   3. Users leaving rooms
   4. Hosts leaving rooms and essentially closing the rooms down
   5. Users phones closing automatically while in the room
   6. Allowing users to quickly go back to the room if they accidentally left the app

## 🚀 Future Scope <a name = "future_scope"></a>

Although I believe I covered a lot of edge cases, I unfortunately couldn't cover them all in such a short time period. 
Three main things I'd focus on if I were to continue working on this project are:

1. Cron function to programatically delete the firestore data - Currently, the Cron function is being done from Flutter, which isn't necessarily that bad of a thing, but I would've still prefered if it was a proper Cron function
2. Look more into what the app looks like on different screen sizes, it looked perfect on the two phones I tried it on, but its likely to not work properly on smaller screens
3. Handle users turning off their phones. I had an idea of how to combat this, but I didn't have enough time to execute the idea. The idea was for the users in the room to update their own timestamps every 10 seconds or so, and the host (or everyone), would kick anyone out that didn't update their own timestamp in the past 35/45 seconds

## 🏁 Getting Started <a name = "getting_started"></a>

These instructions will get you a copy of the project up and running on your local machine for development
and testing purposes. 

### Prerequisites

In order for you to run this program, you will need Flutter and Dart SDK installed.

If you want to run the app on iOS, this is a necessity. If, however, you wish to run it on Android, and you do not wish to install Flutter, feel free to simply use the app-release.apk file provided in this folder

### Recommendations

Personally, I like using VSCode for Flutter, but it might be a bit easier if you set everything on Android Studio and test everything through that.
## ⛏️ Built With <a name = "tech_stack"></a>

- [Flutter](https://www.flutter.dev/) - Frontend
- [Firebase](https://firebase.google.com/) - Backend

## ✍️ Authors <a name = "authors"></a>

- [@SirBepy](https://github.com/SirBepy) - Josip Mužić
## 🎉 Acknowledgments <a name = "acknowledgments"></a>

- Ida Marija Mužić - testing the application