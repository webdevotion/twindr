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