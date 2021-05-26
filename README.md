# What To Watch App
This is my project to create a Movie DB app similar to Apple TV iOS app using TMDb API.

## Requirement
* Register for API Key at https://themoviedb.org

## Getting Started
* Copy and Clone the project
* Build the project
* Paste the API Key, API base URL and image base URL inside API-Info.plist  
Example:
    * APIKey: YOUR_API_KEY
    * APIBaseURL: api.themoviedb.org
    * ImageBaseURL: image.tmdb.org
* Run the project

## Architecture Concepts Used Here
* [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
* [MVVM](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)
* [Flow Coordinator](https://khanlou.com/2015/10/coordinators-redux)
* [Keep API Data Safe](https://betterprogramming.pub/fetch-api-keys-from-property-list-files-in-swift-4a9e092e71fa)
* Data Binding using [RxSwift](https://github.com/ReactiveX/RxSwift)
* Dependency Injection using [Swinject](https://github.com/Swinject/Swinject)
* SOLID
* Data Transfer Object (DTO)
* Response Data Caching
* Error handling

## Includes
* Unit Tests
* Dark Mode
* Pagination

## Preview
<p align="center">
  <img src="screenshots/demo.gif">
</p>
