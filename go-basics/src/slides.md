---
theme: apple-basic
highlighter: shiki
lineNumbers: false
info: |
  ## Go Basics
  Made by Siddhartha Varma (sidv.dev)
drawings:
  persist: false
layout: fact
title: Go Basics
hideInToc: true
---

# Go basics

---
hideInToc: true
title: About me
---
# About Me
<div class="flex flex-row mt-20 items-center">
    <div class="flex flex-col w-1/2 items-center">
        <img src="https://raw.githubusercontent.com/BRO3886/sidv.dev/0d0df5d432dad9e2c4321f6250b4b9d176c75750/public/assets/me.webp" class="rounded-full w-40"/>
        <p>Siddhartha Varma</p>
    </div>
    <div class="flex flex-col ">
        <ul>
            <li>SDE Intern - backend, Core Team</li>
            <li>Cinephile (Currently watching: Stranger Things S4) </li>
        </ul>
        <div class="my-10 grid grid-cols-[40px,1fr] w-min gap-y-4">
            <ri-github-line class="opacity-50"/>
            <div><a href="https://github.com/BRO3886" target="_blank">BRO3886</a></div>
            <ri-user-3-line class="opacity-50"/>
            <div><a href="https://sidv.dev" target="_blank">sidv.dev</a></div>
        </div>
    </div>
</div>

---
hideInToc: true
title: Less is exponentially more
layout: statement
---

# Less is (exponentially) more
Rob Pike

---
hideInToc: true
title: Why Go
---
# Why Go
* Created by Rob Pike, Robert Griesemer, Ken Thompson
* Replacement of C++, at Google
* Plagued by slow compilation, not impressed by unecessary features
* need of _concurrency_ on fingertips (imagine scale of Google)
* Less boilerplate code (not exactly object-oriented)
* Less is (exponentially) more

---
hideInToc: true
title: Basics of Go title slide
layout: statement
---
# Be more expressive with less
Only 25 keywords (+1 after go1.18)

---
hideInToc: true
title: Go
---
# Go
* Fast (compiled to native code)
* Concurrency
* Simple
* Easy to learn
* Easy to write "good" code which needs to be maintained by large teams (set of default rules)

---
hideInToc: true
title: Basics of Go title slide
layout: section
---

# Basics of Go
[go.dev/play](https://go.dev/play/)

---
hideInToc: true
title: Basics of Go
---
## main.go
```go {1|3-5|all}
package main

func main() {
}
```

---
hideInToc: true
title: Imports and fmt
---
## Imports and fmt

```go {3|6}
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
```

---
hideInToc: true
title: Factored import statement and exported variables
---

## Factored import statement and exported variables

```go {3-6|all|10}
package main

import (
    "fmt"
    "math"
)

func main() {
    fmt.Println("I got %d problems", math.Sqrt(9801))
    fmt.Println("value of pi: ", math.pi) //wrong, should be math.Pi
}
```

---
hideInToc: true
title: Functions
---
## Functions
```go{1-3|5-7|9-11|13-16|all}
func add(x int, y int) int {
    return x + y
} 

func subtract(x, y int) int {
    return x - y
}

func swap(x, y string) (string, string) {
    return y, x
}

func main() {
	a, b := swap("hello", "world")
	fmt.Println(a, b)
}
```
---
hideInToc: true
title: Variables
---
## Variables
```go {all|2-3|5-6}
func main() {
    var b string
    b = "hello"

    // type inference, shorthand
    a := 10
}
```
---
hideInToc: true
title: Zero values
---
## Zero values
```go
var a bool // false

var b int // 0

var c float64 // 0

var c string // ""
```
---
hideInToc: true
title: Loops
---
## Loops
```go {1-6|7-11|13-16|all}
sum := 0
for i := 0; i < 10; i++ {
    sum += i
}
fmt.Println(sum)

sum := 1
for sum < 1000 {
    sum += sum
}
fmt.Println(sum)

for  {
    // do something
    // runs indefinitely
}
```

---
hideInToc: true
title: If-else
---
```go
if 7%2 == 0 {
    fmt.Println("7 is even")
} else {
    fmt.Println("7 is odd")
}
```

---
hideInToc: true
title: Switch
---
## Switch statements
```go{9-18|20-25|all}
package main

import(
    "fmt"
    "time"
)

func main() {
    i := 2
    fmt.Print("Write ", i, " as ")
    switch i {
    case 1:
        fmt.Println("one")
    case 2:
        fmt.Println("two")
    case 3:
        fmt.Println("three")
    } // prints "Write 2 as two"

    switch time.Now().Weekday() {
    case time.Saturday, time.Sunday:
        fmt.Println("It's the weekend")
    default:
        fmt.Println("It's a weekday")
    }
}
```
---
hideInToc: true
title: Pointers
---
## Pointers
```go{all|8|9|10|11|13-15|all}
package main

import "fmt"

func main() {
	i, j := 42, 2701

	p := &i         // point to i
	fmt.Println(*p) // read i through the pointer
	*p = 21         // set i through the pointer
	fmt.Println(i)  // see the new value of i

	p = &j         // point to j
	*p = *p / 37   // divide j through the pointer
	fmt.Println(j) // see the new value of j
}

```
---
hideInToc: true
title: Structs
---
## Structs

Remeber C?

```go {all|5-9|12|13|all}
package main

import "fmt"

type Person struct {
    Firstname string
    Lastname string
    Age int
}

func main() {
    p := Person{"Siddhartha", "Varma", 22}
    fmt.Println(p.Firstname) // prints "Siddhartha"
}
```
---
hideInToc: true
title: Arrays and slices
---
## Arrays and slices
```go {all|6-10|12-15|14|all}
package main

import "fmt"

func main() {
	var a [2]string
	a[0] = "Hello"
	a[1] = "World"
	fmt.Println(a[0], a[1])
	fmt.Println(a)

    var primes []int
    primes = append(primes, 2, 3, 5, 7, 11)
    fmt.Println(primes)
    primes = append(primes, 13, 17, 19, 23, 29)
    fmt.Println(primes)
}
```
---
hideInToc: true
title: Questions?
layout: fact
---
# Questions?

---
hideInToc: true
title: Moving forward
layout: statement
---
# Do explore
concurrency, channels, interface, and goroutines

---
hideInToc: true
title: Resources
---
# Resources

* [go.dev/doc/](https://go.dev/doc/)
* [go.dev/blog/](https://go.dev/blog/)
* [dave.cheney.net/](https://dave.cheney.net/)
* [github.com/avelino/awesome-go](https://github.com/avelino/awesome-go)
* [youtube.com/c/GolangDojo](https://www.youtube.com/c/GolangDojo)
* [youtube.com/c/Tutorialedge/](https://www.youtube.com/c/Tutorialedge/)
* [Creating web applications with Go - Mike Van Sickle](https://www.pluralsight.com/courses/creating-web-applications-go-update)
* [Go - The Complete Developer's Guide - Stephen Grider](https://www.udemy.com/course/go-the-complete-developers-guide/)



---
layout: center
hideInToc: true
class: 'text-center pb-5 :'
---
# These slides are available online at
<a href="https://talks.sidv.dev/2022/go-basics">talks.sidv.dev/2022/go-basics</a>

---
layout: center
hideInToc: true
class: 'text-center pb-5 :'
---

# Thank You!
