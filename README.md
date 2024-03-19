# Dame Una Mano

<p align="left">
  <img width="473" alt="image" src="https://github.com/esteban-silvera/Dame-Una-Mano/assets/108559276/83b8b370-3230-4190-b237-99dc49c10bbd">
</p>

*"A new way to connect with professionals"*

 **Table of content:**
 - [The Story](#item-one)
 - [Getting Started](#item-two)
 - [Features](#item-three)
 - [Built With](#item-four)
 - [Future](#item-five)
 - [Authors](#item-six)
 - [Acknowledgements](#item-seven)
 


<a id="item-one"></a>
###  The Story

The inspiration for our project came from a personal experience one of our team members had with plumbing issues in a small town where word of mouth is crucial for finding services. Despite reaching out to friends for recommendations, they were unable to connect with the recommended plumber who was on vacation at the time. Instead, they had to resort to contacting plumbers from a neighboring town, who charged a hefty fee for their services.

This incident stuck with us as we brainstormed ideas for a solution to a common problem many people face. We realized that there was a clear need in the Uruguayan market for a service-based app that could connect individuals with professionals. After brainstorming several names, we settled on "Dame Una Mano," which translates to "Give me a hand" – a phrase commonly used when seeking assistance. This name resonated with us because it reflects the intention behind our project: to provide a platform where people can easily find professionals to help them with a wide range of issues, from home repairs like plumbing to car maintenance, while also contributing to the local economy. Our goal is to bridge the gap between individuals seeking services and professionals within their neighborhoods.

**Front End:**

- Flutter for cross-platform mobile app development
- Dart programming language for app logic
- Material Design for consistent UI styling
- API calls to interact with Firebase services

**Back End:**

- Firebase Firestore for real-time NoSQL database
- Firebase Storage for storing media files
- Google Maps API and Geocoding API for location services
- Google Cloud Platform for backend services and infrastructure support

**Server / Deployment:**

- Firebase Hosting for hosting the Flutter web app
- Firebase Cloud Functions for serverless functions
- Firebase Authentication for user authentication and authorization

This setup allows for a seamless integration of Flutter and Dart for the front end, Firebase and Google Cloud services for the back end, and Firebase Hosting and Cloud Functions for server deployment and management.

<a id="item-two"></a>
###  Getting Started

- Must have a github account to use Dame Una Mano.
- To explore features without logging in, check out Features.

**Use of Application**

Dame Una Mano is a user-friendly application that serves as a centralized platform for connecting users with a diverse array of professionals across various services. Professionals can easily advertise their services, while users can conveniently search and filter through profiles to find the perfect match for their needs. With a wide range of services available, from plumbing to tutoring, users can explore detailed professional profiles showcasing expertise and qualifications, ensuring they connect with the right professionals efficiently.

**Challenges**

The challenges we encountered included dedicating ample time to understand the nuances of each new technology. To address this, we divided the team between front end and backend development. Our front end developers focused on crafting the application's aesthetic using tools like Figma and Flutter, ensuring it aligned with the project's concept. Meanwhile, the backend developers concentrated on building the database infrastructure using Firebase for hosting and integrating the Google Maps API for real-time user-professional connections. Throughout this process, we relied on task-based platforms such as Trello to track weekly objectives and ensure we met our deadline for completing the app.

<a id="item-three"></a>
### Features

The initial screen of "Dame Una Mano" presents the option for the user to log in or register in order to access to the app


<p align="center">
  <img width="200" alt="image" src="https://i.ibb.co/2Fgtms1/Screenshot-1709556149.png">
</p>

We have integrated a button on the login screen that toggles between the login and registration states. Below, you can see an example of how these changes are implemented.

<p align="center">
  <img width="200" alt="image" src="https://github.com/esteban-silvera/Dame-Una-Mano/assets/108559276/786b37c0-bb6d-4cd7-a94f-1914e3142522">
  <img width="200" alt="image" src="https://github.com/esteban-silvera/Dame-Una-Mano/assets/108559276/344682f3-0930-4527-b085-dbe50e597bd3">
</p>

Upon logging in, both users and workers are provided with their own profile pages to input their respective information. For workers, we require specific details such as job title, a description of their work, as well as location information including department, city, and neighborhood.

<p align="center">
  <img width="200" alt="image" src="https://cdn.discordapp.com/attachments/1016723767659073657/1219432611731214468/image.png?ex=660b481e&is=65f8d31e&hm=55ad259a0ff527e0bcba937647cc61b63728d8790cf2fb9fc028c485522cede4&">
</p>

On the subsequent screen, users will encounter the home pages, where they will interact with various options of professionals to choose from. Upon selecting a professional, the next screen will prompt users to choose between two options: live location or neighborhood selection.

<p align="center">
  <img width="200" alt="image" src="https://i.ibb.co/mbCmcBJ/Screenshot-1710145332.png">
  <img width="200" alt="image" src="https://i.ibb.co/qn2VnGH/Screenshot-1710147240.png">
</p>

The following screen will display a live Google Maps API, showcasing real-time usage of one of our team members. Meanwhile, another screen will demonstrate how the worker's profile appears to the user, featuring a real-time responsive rating system.

<p align="center">
  <img width="200" alt="image" src="https://i.ibb.co/bN7Gxr2/Screenshot-1709766410.png">
  <img width="200" alt="image" src="https://i.ibb.co/428LWHD/Screenshot-1710146124.png">
</p>

<a id="item-four"></a>
### Built With

- [Dart](https://dart.dev/) - Frontend Language for Flutter
- [Flutter](https://flutter.dev/) - Cross-platform Mobile App Development Framework 
- [Firebase](https://firebase.google.com/) - Backend Services and Infrastructure Support
- [Firestore](https://firebase.google.com/docs/firestore) - Real-time NoSQL Database by Firebase
- [Firebase Storage](https://firebase.google.com/docs/storage) - Cloud Storage for Storing Media Files
- [Google Maps API](https://developers.google.com/maps) - For Location Services
- [Geocoding API](https://developers.google.com/maps/documentation/geocoding/overview) - For Converting Addresses into Geographic Coordinates
- [Google Cloud](https://cloud.google.com/why-google-cloud/) - Backend Services and Infrastructure Support for Firebase 

<a id="item-five"></a>

### Installation Instructions

To install and run "Dame Una Mano" on your Android device, follow these steps:

1. Clone this repository to your local machine:

    ```bash
    git clone https://github.com/esteban-silvera/Dame-Una-Mano.git
    ```

2. Open the project in your preferred development IDE, such as Android Studio or VSCode.

3. Configure your Android device or an emulator to run the application. Make sure you have USB debugging enabled on your device and that it is properly connected to your computer.

4. Make sure you have Flutter and Dart installed on your system. You can follow the installation instructions in the [official Flutter documentation](https://flutter.dev/docs/get-started/install).

5. Install all project dependencies by running the following command in the project root:

    ```bash
    flutter pub get
    ```

6. Once the dependencies downloads are complete, run the app on your device or emulator using the following command:

    ```bash
    flutter run
    ```

7. The app will be compiled and installed on your device/emulator. Once the installation is complete, you can open "Dame Una Mano" and start exploring its features.

### Future

For future development, we plan to implement:
- An agenda feature
- A booking system

<a id="item-six"></a>
### Authors
* Project Manager/ Full Stack Developer UX UI - Lucia Puppo : https://github.com/LuciaPuppo897
* Fullstack Devloper - Esteban Silvera : https://github.com/esteban-silvera
* Backend Developer - Yetzabeth Hernandez : https://github.com/yetzabeth
* Backend Developer - Carlos Franco : https://github.com/cfranco87

* Dame Una Mano: https://github.com/esteban-silvera/Dame-Una-Mano

<a id="item-seven"></a>
### Acknowledgements

- [Holberton School](https://holbertonschool.uy/) - (Staff and Students)







