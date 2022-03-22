# RijksMuseum

# Install
* Add **API_Key** in APILinksFactory.swift


# App Structure

* App structure I use **MVP** with Input-Output approach **Delegate** to notify about updates.

* I use the **Repository** design pattern to act as a Data source from API.

* Separate the data source of UITableView to other class **PhotosCollectionViewDataSource**.

* I use **CellReusable** protocol and create 2 extensions for UICollectionView to reduce code when reusing the cell.

* Used Reachability.swift to check the internet connection state.

* Use DataLoader.swift to get data from local JSON.

* I created Extension for UIImageView to download the image from the link.

* I used [SwiftLint](https://github.com/realm/SwiftLint) to enhance Swift style.

* I create UI with code.

* I used **SPM** (Swift Package Manager).

* I supported Dark-Light Mode

* I supported Oriantation

![](ScreenShots/Screen1.png)
![](ScreenShots/Screen2.png)


# UnitTest
* I apply  **Arrange, Act and Assert (AAA) Pattern** [AAA](https://medium.com/@pjbgf/title-testing-code-ocd-and-the-aaa-pattern-df453975ab80) in Unit Testing.
* I use mocking to Test get data from  NetworkManager, I use the same JSON file to mock data.
* Test get data from API and From Local JSON.
* Code coverage +80%
![](ScreenShots/Screen3.png)

## Demo
![](Demo.gif)

## Info

Name: Dimo Hamdy

Email: dabdelaziz@mobiquityinc.com

