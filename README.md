# ParticleKit
A 2D particle system.

## Installation

Add the following to your Cartfile:

```
github "mattcomi/ParticleKit"
```

## Usage

Import the framework:
```swift
import ParticleKit
```

Create a `ParticleSystem`:

```swift
let system = ParticleSystem(capacity: 1024)
```

The `capacity` parameter specifies how many particles may exist at any one time. An existing particle will be replaced if a particle is emitted beyond this capacity.

The color and size of particles may vary during their lifetime. Specify these values using `Gradient` objects:

```swift
let colorGradient = Gradient<UIColor>()

colorGradient.add(location: 0, value: UIColor(red: 1, green: 0, blue: 0, alpha: 1))
colorGradient.add(location: 0.5, value: UIColor(red: 0, green: 1, blue: 0, alpha: 1))
colorGradient.add(location: 1, value: UIColor(red: 0, green: 0, blue: 1, alpha: 0))

let sizeGradient = Gradient<CGFloat>()

sizeGradient.add(location: 0, value: 0)
sizeGradient.add(location: 0.3, value: 1)
sizeGradient.add(location: 0.6, value: 0.5)
sizeGradient.add(location: 1.0, value: 0)
```

And assign them to the `ParticleSystem`:

```swift
system.colorGradient = colorGradient
system.sizeGradient = sizeGradient
```

Specify the physical properties of particles using a `ParticleSystemProperties` object:

```swift
var properties = ParticleSytemProperties()

properties.position = ParticleSystemValue(origin: .zero, spread: .zero)
properties.lifetime = ParticleSystemValue(origin: 25, spread: 0)
properties.linearVelocityAngle = ParticleSystemValue(origin: Angle(degrees: 270), spread: Angle(degrees: 5))
properties.linearVelocitySpeed = ParticleSystemValue(origin: 4, spread: 0)
properties.angle = ParticleSystemValue(origin: Angle(degrees: 0), spread: Angle(degrees: 360))
properties.angularVelocity = ParticleSystemValue(origin: Angle(degrees: 0), spread: Angle(degrees: 8))
```

And assign it to the `ParticleSystem`:

```swift
system.properties = properties
```

Emit a particle!

```swift
system.emit()
```

Update the `ParticleSystem`:

```swift
system.update()
```

Note that the time unit is updates. In other words, a lifetime of 25 specifies 25 calls to `update()`. Similarly, an angular velocity of 10 degrees indicates that the particle rotates 10 degrees each update.

And finally, render the particles:

```swift
for particle in particleSystem {
  let quad = particle.quad
  let color = particle.color
  
  // draw the quad
}
```