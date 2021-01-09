# parkWhere?

parkWhere? is a mobile applicaton that allows drivers to check the current (and projected) availability of public car park lots. 

The application is built using Flutter and Dart. It uses a TFLite model to determine the projected availability and the Google Maps API for mapping related requests.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 

### Prerequisites

  * The latest version of Flutter and Dart installed on your local machine.
  * A valid Google Maps API key.
  * A valid LTA Datamall API key.

**Step 1:**

Download or clone this repo.

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```

**Step 3:**

Go to project root and create a new file `.env`. In that file, add the following lines

```
MAPS_API_KEY=YOUR_GOOGLE_MAPS_API_KEY
ACCOUNT_KEY=YOUR_LTA_API_KEY
```

**Step 4:**

Run the project.

## Authors
  
* **Balasubramaniam Praveen** -  [pr4aveen](https://github.com/pr4aveen)
* **Bryan Wong Hong Liang** - [bryanwhl](https://github.com/bryanwhl)
* **Farrell Nah Jun Hao** - [boundtotheearth](https://github.com/boundtotheearth)
* **Foong Xin Yu** - [Uxinnn](https://github.com/Uxinnn)
