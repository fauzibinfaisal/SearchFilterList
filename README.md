# SearchFilterList

## Overview

A Simple Search Filter List Single Page IOS App Project. This Project builds using MVC architectural patterns.

## Usage

Clone the Project. You need API KEY to run the project. You can put the API KEY in /resources/Secrets.swift .
Just email me to get the API KEY - fauzibinfaisal@gmail.com

## Structure App

- App
 - Application
 - Modules
 - Services
 - Utils
 - Resources
 
### Aplication

Application contains App level File such as AppDelegate and SceneDelegate

### Modules

Modules contain features / pages for the app. Each module has MVC Pattern. for example:
  - Doctor List
    - Model (Doctor)
    - View (DoctorList.storyboard, DoctorCell)
    - Controller (DoctorListViewController)
    
### Services

Services contain A bunch of services that implemented in this project, such as API Handler / Network Manager.

### Utils

Utils contain some functions that will use accross the project.

### Resources

Resources contain assets, constants, strings, etc.
