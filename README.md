=======
twindr
======

Grindr, but for nerds

### Idea

Easy way to find people in a closed context; for example at UIKonf
and keep track of their more personal details, especially their Twitter handler.

### Tech Challenge

Set up a mesh network of iBeacons ( iPhones ).
We can't use the network / wifi mesh because it needs invitations / permissions.

When setting up iBeacons we can create a region with a certain major/minor couple.
You have to enable Bluetooth to use iBeacons.

### Feature Ideas

- authenticate with twitter oath
- filter handles from the iBeacon network your in
- find twitter handles using the public api when someone's is not using our app

### Docs

[https://developer.apple.com/Library/ios/documentation/UserExperience/Conceptual/LocationAwarenessPG/RegionMonitoring/RegionMonitoring.html](https://developer.apple.com/Library/ios/documentation/UserExperience/Conceptual/LocationAwarenessPG/RegionMonitoring/RegionMonitoring.html)

> A *beacon region* is an area defined by the device’s proximity to Bluetooth low-energy beacons. Beacons themselves are simply devices that advertise a particular Bluetooth low-energy payload—you can even turn your iOS device into a beacon with some assistance from the Core Bluetooth framework.

> Apps can use region monitoring to be notified when a user crosses geographic boundaries or when a user enters or exits the vicinity of a beacon. While a beacon is in range of an iOS device, apps can also monitor for the relative distance to the beacon. You can use these capabilities to develop many types of innovative location-based apps.

> In iOS, regions associated with your app are tracked at all times, including when the app isn’t running. If a region boundary is crossed while an app isn’t running, that app is relaunched into the background to handle the event. Similarly, if the app is suspended when the event occurs, it’s woken up and given a short amount of time (around 10 seconds) to handle the event. When necessary, an app can request more background execution time using the beginBackgroundTaskWithExpirationHandler: method of the UIApplication class.