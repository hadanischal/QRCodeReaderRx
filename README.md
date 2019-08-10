# QRCodeReaderRx

**QRCodeReaderRx** is a simple code reader for iOS in Swift. It is based on the `AVFoundation` framework from Apple in order to replace ZXing or ZBar for iOS 8.0 and over. It use [QRCodeReader.swift](https://github.com/yannickl/QRCodeReader.swift) as dependency. It can decodes these [format types](https://developer.apple.com/library/ios/documentation/AVFoundation/Reference/AVMetadataMachineReadableCodeObject_Class/index.html#//apple_ref/doc/constant_group/Machine_Readable_Object_Types).

It provides a default view controller to display the camera view with the scan area overlay.

## Requirements:
* iOS 11.0+
* Xcode 10.2.1
* Swift 5.0

## Compatibility
This demo is expected to be run using Swift 5.0 and Xcode 10.2.1


## Usage

In iOS10+, we will need first to reasoning about the camera use. For that we'll need to add the **Privacy - Camera Usage Description** *(NSCameraUsageDescription)* field in your Info.plist:

<p align="center">
  <img alt="privacy - camera usage description" src="https://cloud.githubusercontent.com/assets/798235/19264826/bc25b8dc-8fa2-11e6-9c13-17926384ebd1.png" height="28">
</p>

## Objective:
This is a simple Demo project which aims to display simple code reader for iOS in Swift using MVVM + rxSwift pattern in Swift.
* This project was intended to work as a QRCode scan demo projects for iOS using Swift. 
* The demo uses the [QRCodeReader.swift](https://github.com/yannickl/QRCodeReader.swift) as an dependency.