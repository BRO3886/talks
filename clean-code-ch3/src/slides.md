---
theme: apple-basic
highlighter: shiki
lineNumbers: false
info: |
  ## Clean Code - Chapter 3
  Made by Siddhartha Varma (sidv.dev)
drawings:
  persist: false
layout: fact
title: Clean Code - Chapter 3
hideInToc: true
---

# Clean Code
Chapter 3: Functions

<!-- So this is Clean code, Chapter 3 - Functions -->
---
layout: intro
hideInToc: true
title: About Me
---

# Siddhartha Varma

<div class="leading-8 opacity-80">
SDE Intern - backend<br>
Core Team<br>
</div>

<div class="my-10 grid grid-cols-[40px,1fr] w-min gap-y-4">
  <ri-github-line class="opacity-50"/>
  <div><a href="https://github.com/BRO3886" target="_blank">BRO3886</a></div>
  <ri-twitter-line class="opacity-50"/>
  <div><a href="https://twitter.com/sidv_22" target="_blank">sidv_22</a></div>
  <ri-user-3-line class="opacity-50"/>
  <div><a href="https://sidv.dev" target="_blank">sidv.dev</a></div>
</div>

<img src="https://raw.githubusercontent.com/BRO3886/sidv.dev/0d0df5d432dad9e2c4321f6250b4b9d176c75750/public/assets/me.webp" class="rounded-full w-40 abs-tr mt-16 mr-12"/>

<!--
I am Siddhartha, an SDE intern - backend, in the core team.
-->

---
layout: default
hideInToc: true
level: 2
---

## HtmlUtil.java

```java
public static String testableHtml(PageData pageData,
    boolean includeSuiteSetup
) throws Exception {
    WikiPage wikiPage = pageData.getWikiPage();
    StringBuffer buffer = new StringBuffer();
    if (pageData.hasAttribute("Test")) {
        if (includeSuiteSetup) {
            WikiPage suiteSetup =
                PageCrawlerImpl.getInheritedPage(SuiteResponder.SUITE_SETUP_NAME, wikiPage);
            if (suiteSetup != null) {
                WikiPagePath pagePath = suiteSetup.getPageCrawler().getFullPath(suiteSetup);
                String pagePathName = PathParser.render(pagePath);
                buffer.append("!include -setup .")
                    .append(pagePathName).append("\n");
            }
        }
        WikiPage setup = PageCrawlerImpl.getInheritedPage("SetUp", wikiPage);
        if (setup != null) {
            WikiPagePath setupPath =
                wikiPage.getPageCrawler().getFullPath(setup);
            String setupPathName = PathParser.render(setupPath);
            buffer.append("!include -setup .")
                .append(setupPathName).append("\n");
        }
    }
```

<!--
Let's see this function - called testableHtml, present in the file called HtmlUti.java, take a minute to read through this function
-->

---
layout: default
hideInToc: true
level: 2
---

## Contd.

```java
    buffer.append(pageData.getContent());
    if (pageData.hasAttribute("Test")) {
        WikiPage teardown = PageCrawlerImpl.getInheritedPage("TearDown", wikiPage);
        if (teardown != null) {
            WikiPagePath tearDownPath =
                wikiPage.getPageCrawler().getFullPath(teardown);
            String tearDownPathName = PathParser.render(tearDownPath);
            buffer.append("\n")
                .append("!include -teardown .").append(tearDownPathName).append("\n");
        }
        if (includeSuiteSetup) {
            WikiPage suiteTeardown =
                PageCrawlerImpl.getInheritedPage(SuiteResponder.SUITE_TEARDOWN_NAME, wikiPage);
            if (suiteTeardown != null) {
                WikiPagePath pagePath = suiteTeardown.getPageCrawler().getFullPath(suiteTeardown);
                String pagePathName = PathParser.render(pagePath);
                buffer.append("!include -teardown .")
                    .append(pagePathName).append("\n");
            }
        }
    }
    pageData.setContent(buffer.toString());
    return pageData.getHtml();
}
```

<!--
Here's the rest of it

So, do you all think this function is easily understandable?

I dont think so too

basically, it returns an HTML. It is used for setting up some tests on an HTML page with a junit like test suite

and after that, since after a test you also have to tear-down, it does that too
-->

---
layout: default
hideInToc: true
level: 2
---

# Refactored

```java
public static String renderPageWithSetupsAndTeardowns(
      PageData pageData, 
      boolean isSuite
) throws Exception {
    boolean isTestPage = pageData.hasAttribute("Test"); 
    
    if (isTestPage) {
      WikiPage testPage = pageData.getWikiPage(); 
      StringBuffer newPageContent = new StringBuffer(); 
      includeSetupPages(testPage, newPageContent, isSuite); 
      newPageContent.append(pageData.getContent()); 
      includeTeardownPages(testPage, newPageContent, isSuite); 
      pageData.setContent(newPageContent.toString());
    }
    
    return pageData.getHtml(); 
}
```

<!--
Here is the refactored version of the function
-->

---
layout: section
hideInToc: true
level: 2
---

# What makes the refactored code easier to read?

<!--
So, what makes the refactored code easier to read?
-->

---
layout: cover
---

# Small

<v-clicks>

- The first rule of functions is that they should be small. 

- The second rule of functions is that *they should be smaller than that*.

</v-clicks>

<!--
It is small
-->

---
layout: fact
hideInToc: true
level: 2
---

<div class="text-5xl py-2">
How short should a function be?<br>
</div>
<div v-click class="py-2">Three, or four, or five lines long.</div>
<div v-click class="py-2">Every once in a while, even six lines long.</div>

<!--

-->

---
layout: default
hideInToc: true
level: 2
---

## Red Flags 🚩

```java {1|5|6|7-25}
public static String testableHtml(PageData pageData,
    boolean includeSuiteSetup
) throws Exception {
    WikiPage wikiPage = pageData.getWikiPage();
    StringBuffer buffer = new StringBuffer();
    if (pageData.hasAttribute("Test")) {
        if (includeSuiteSetup) {
            WikiPage suiteSetup =
                PageCrawlerImpl.getInheritedPage(SuiteResponder.SUITE_SETUP_NAME, wikiPage);
            if (suiteSetup != null) {
                WikiPagePath pagePath = suiteSetup.getPageCrawler().getFullPath(suiteSetup);
                String pagePathName = PathParser.render(pagePath);
                buffer.append("!include -setup .")
                    .append(pagePathName).append("\n");
            }
        }
        WikiPage setup = PageCrawlerImpl.getInheritedPage("SetUp", wikiPage);
        if (setup != null) {
            WikiPagePath setupPath =
                wikiPage.getPageCrawler().getFullPath(setup);
            String setupPathName = PathParser.render(setupPath);
            buffer.append("!include -setup .")
                .append(setupPathName).append("\n");
        }
    }
```

<!--
Now lets analyze some obvious red flags in it

First of all, it's name. It's a noun.

Functions do something, there is no need to name it a noun, instead it should be a verb.

Now, along with user defined classes (like WikiPage), it is also using StringBuffer, a core concept of java. 
So this function has different levels of abstraction

This function also has a big if statement which is not very clear when you're going through it

And there is some obvious code duplication

Now, lets analyze what we can do to make this function better
-->

---
layout: default
hideInToc: true
level: 2
---

## More Red Flags 🚩

```java {2-21}
    buffer.append(pageData.getContent());
    if (pageData.hasAttribute("Test")) {
        WikiPage teardown = PageCrawlerImpl.getInheritedPage("TearDown", wikiPage);
        if (teardown != null) {
            WikiPagePath tearDownPath =
                wikiPage.getPageCrawler().getFullPath(teardown);
            String tearDownPathName = PathParser.render(tearDownPath);
            buffer.append("\n")
                .append("!include -teardown .").append(tearDownPathName).append("\n");
        }
        if (includeSuiteSetup) {
            WikiPage suiteTeardown =
                PageCrawlerImpl.getInheritedPage(SuiteResponder.SUITE_TEARDOWN_NAME, wikiPage);
            if (suiteTeardown != null) {
                WikiPagePath pagePath = suiteTeardown.getPageCrawler().getFullPath(suiteTeardown);
                String pagePathName = PathParser.render(pagePath);
                buffer.append("!include -teardown .")
                    .append(pagePathName).append("\n");
            }
        }
    }
    pageData.setContent(buffer.toString());
    return pageData.getHtml();
}
```

---
layout: default
---

# Do One Thing

- It should be very clear that `testableHtml()` is doing lots more than one thing.

<v-clicks>

- Creating buffers
- fetching pages
- searching for inherited pages
- rendering paths
- appending arcane strings
- and generating HTML, among other things.

</v-clicks>


<div v-click class="py-6">
<img class="h-32 " src="https://c.tenor.com/GVHE94wLwG4AAAAM/whet-what.gif">
</div>

<!--
It should be very clear that `testableHtml()` is doing lots more than one thing.

It is doing all this (read out all)

Now let's see some more rules for writing good functions
--> 

---
layout: quote
hideInToc: true
level: 2
---

# "Functions should do one thing. They should do it well. They should do it only."
Robert C. Martin (Uncle Bob)

---
layout: default
hideInToc: true
level: 2
---

# How would I know if I'm doing it right?

<v-clicks>

- It is hard
- If a function does only those steps that are <ins>one level below</ins> the stated name of the function
- The reason we write functions is to decompose a larger concept 
- (in other words, the name of the function)

</v-clicks>

<!--
But how would you know if you're doing it right?

Yes, it is hard
Your function is doing one thing if a function does only those steps that are one level below the stated name of the function
The reason we write functions is to decompose a larger concept, which in another words, is the name of the function

-->

---
layout: default
hideInToc: true

---

# Indenting

<v-clicks>

- Functions should not be large enough to hold nested structures
- Therefore the indent level of a function should not be greater than one or two
- This makes the function easier to read and understand 
- (reads just like a well-written prose)

</v-clicks>

<!-- 
Indenting is simple enough
Functions should not be large enough to hold nested structures.
The indent level thus should be 1 or 2
This will make your function easier to read and understand
It reads just like a well-written prose
-->

---
layout: default
---

# One Level of Abstraction per Function

<v-clicks>

- Read like a top-down narrative
- Every function to be followed by those at the next level of abstraction
- Descending one level of abstraction at a time
- The Step-down Rule
- Key to keeping functions short and making sure they do “one thing”
- It is hard.

</v-clicks>

<!-- 
So we saw before how testableHtml() is doing lots of things, and it has multiple levels of abstraction

Your functions should read like a top-down narrative
WHen you're reading, the functions are to be followed by those at the next level of abstraction, descending one level of abstraction at a time

This is called the Step-down Rule

And it is the key to keeping functions short and making sure they do "one thing"

Again, it is hard
-->

---
layout: statement
---

# Avoid Switch Statements

<div v-click class="py-2">
They Break.
</div>

<div v-click>
Use polymorphism instead.
</div>

<!--
Avoid switch statements

They break.

Use polymorphism instead.

For example, if you have a shape enum and you're using switch-case or if else to take decisions based on the shape, it causes a lot of problems when you want to add more shapes. Let's say you have to add rhombus. You'll have to add a lot of if else statements or switch-case statements. This is a source of error, leads to a lot of code duplication too.

Instead what you should do is have a base class called shape and then derived classes like square, circle, and rhombus etc.
-->

---
layout: quote
hideInToc: true
---

# "You know you are working on clean code when each routine turns out to be pretty much what you expected."
Ward Cunningham (inventor of the Wiki)

---
layout: default
---

# Use descriptive names

>public static String ~~testableHtml~~ renderPageWithSetupsAndTeardowns(PageData pageData,...

<v-clicks>

- Better describes what the function does
- Don’t be afraid to make a name long
- It is better than a short enigmatic name
- It is better than a long descriptive comment

</v-clicks>

<!-- 
You should always use a verb which describe what your function does
instead of testableHtml, we should name the function you saw earlier as renderPageWithSetupsAndTeardowns

Better describes what the function does

Don't be afraid to make a name long

It is better than a short enigmatic name

It is better than a long descriptive comment about the function

-->

---
layout: default
---

# Number of Function Arguments

<v-clicks>

- Zero, One, Two
- Three (should avoid where possible)
- More than three (yikes)

</v-clicks>

<v-clicks>

## Flag Arguments (booleans)
<p class="text-red-500">
NO <br>
Complicates the signature of the method (function does more than one thing). <br>
It does one thing if the flag is true and another if the flag is false.
</p>


</v-clicks>

<!-- 
This is an easy one

The number of function arguments should be zero, one, two, or three (max)

Dont have more than three function arguments

Flag arguments - try to avoid where possible, since it complicates the signature of the method (function does more than one thing). 
It does one thing if the flag is true and another if the flag is false.
-->

---
layout: default
---

# Have no side effects

* Your function promises to do one thing, but it also does other _hidden things_. 

```java {all|4|10}
public class UserValidator {
  private Cryptographer cryptographer;
  
  public boolean checkPassword(String userName, String password) { 
    User user = UserGateway.findByName(userName);
    if (user != User.NULL) {
      String codedPhrase = user.getPhraseEncodedByPassword(); 
      String phrase = cryptographer.decrypt(codedPhrase, password); 
      if ("Valid Password".equals(phrase)) {
        Session.initialize();
        return true; 
      }
    }
    return false; 
  }
}
```

<!-- 
Your function should not have any side effects. It promises to do one thing, but it also does other _hidden things_. 

Can you spot the side effect in this function called `checkPassword`?

So it's name is checkPassword, it should be obvious that it's only meant for returning a boolean corresponding to whether the password is valid or not.

But it has a hidden side effect of initializing the session. Which is not what we want. It makes the code more complex and harder to understand. It makes debugging harder.

-->

---
layout: default
---

# Prefer Exceptions to Returning Error Codes 

<br>

<v-clicks>

#### Command Query Separation:
Functions should either <span class="text-yellow-500">do something</span> or <span class="text-yellow-500">answer something</span>, but not both.

> Returning error codes from functions is a subtle violation of <span class="text-yellow-500">command query separation</span>


</v-clicks>

<!-- 
There is a concept called Command Query Separation.

Functions should either do something or answer something, but not both

Returning error codes from command functions is a subtle violation of it.
-->

---
layout: two-cols
hideInToc: true
---

<div v-click class="mr-8">

## Error

```java
if (deletePage(page) == E_OK) {
  if (registry.deleteReference(page.name) == E_OK) {
    if (configKeys.deleteKey(page.name.makeKey()) == 
    E_OK){ 
      logger.log("page deleted");
    } else {
      logger.log("configKey not deleted");
    }
  } else {
    logger.log("deleteReference from registry 
    failed"); 
  }  
} else {
  logger.log("delete failed"); 
  return E_ERROR;
}
```

* `Error` enum == _Dependency Magnet_

</div>


::right::

<div v-click class="ml-2">

## Exception

```java
try {
  deletePage(page); 
  registry.deleteReference(page.name); 
  configKeys.deleteKey(page.name.makeKey());
} catch (Exception e) {
  logger.log(e.getMessage()); 
}

```

* Yes, try-catch is ugly and confusing
* Only have one method call in try-catch block
* The call is what should be causing the exception
* <p class="text-red-500">Never use nested try-catch</p>

</div>

<!-- 
Here is a code which returns error codes.

Error codes are a source of dependency magnet. Any programmer would not want to change error codes or add new codes. Instead they'll stick to re-using them which becomes a source of problem.

Here is the same function in try-catch block.

Yes, I understand try catch blocks are ugly and confusing. But the key to solving this problem is to have only one method call in try-catch block.

This method call is what should be causing the exception.

Never ever use nested try-catch blocks.
-->

---
layout: quote
hideInToc: true
---
# "Duplication may be the root of all evil in software"
Robert C. Martin (Uncle Bob)

---
layout: default
---

# Don’t Repeat Yourself

<v-clicks>

* Codd’s normal forms
* Structured programming, Aspect Oriented Programming, Component Oriented Programming
* Strategies for eliminating duplication

</v-clicks>

<!--
So friends, don't repeat yourself.

We have concepts like codd's normal forms component oriented programming, aspect oriented programming, structured programming.

These are all strategies for eliminating duplication.
-->

---
layout: default
hideInToc: true
---

# Not Clean Coder Sid 🙅‍♂️

```java
@Service
public class SomeServiceImpl implements SomeService {
  @Override
  public Response doSomething() {
    try {
      Success success = feignClient.doSomethingInternal();
      return SuccessResponse.create(success);
    } catch (FeignException e) {
      log.error(e.getMessage());
      return ErrorResponse.create(e);
    }
  }

  @Override
  public Response doSomethingElse() {
    try {
      OtherSuccess success = feignClient.doSomethingElseInternal();
      return SuccessResponse.create(success);
    } catch (FeignException e) {
      log.error(e.getMessage());
      return ErrorResponse.create(e);
    }
  }

  ...
}
```
<!--
This is some code I was writing till a few days ago. There is obvious code repetition.

So how did I fix this? I implemented a global exception handler to catch all FeignExceptions. How does my code look now?
-->

---
layout: default
hideInToc: true
---

# Clean Coder Sid 😎

```java
@Service
public class SomeServiceImpl implements SomeService {
  @Override
  public Response doSomething() {
    Success success = feignClient.doSomethingInternal();
    return SuccessResponse.create(success);
  }

  @Override
  public Response doSomethingElse() {
    OtherSuccess success = feignClient.doSomethingElseInternal();
    return SuccessResponse.create(success);
  }

  ...
}
```
<!-- 
Now, it was possible to do so in this case because I knew all exceptions I had to catch were FeignExceptions.

-->
---
layout: default
---

# Structured Programming

<v-clicks>

* Edsger Dijkstra’s rules of structured programming
> Every function and every block within a function, should have one entry and one exit.
* There should only be one return statement
* No break or continue statements in a loop
* and never, ever, any goto statements.

</v-clicks>

<!-- 
* Edsger Dijkstra’s rules of structured programming
> Every function and every block within a function, should have one entry and one exit.
* There should only be one return statement
* No break or continue statements in a loop
* and never, ever, any goto statements.
-->
---
layout: statement
hideInToc: true
---
# But there's a catch
<div v-click>

If you keep your functions <span class="text-green-500">small</span>, then the occasional multiple `return`, `break`, or `continue` statement does no harm and can sometimes even be more expressive than the single-entry, single-exit rule.

</div>

---
title: 'Recap'
hideInToc: true
layout: default
---

# Recap
<Toc />

---
layout: center
hideInToc: true
class: 'text-center pb-5 :'
---

# These slides are available online at
<a href="https://talks.sidv.dev/2022/clean-code-ch3">talks.sidv.dev/2022/clean-code-ch3</a>

---
layout: center
hideInToc: true
class: 'text-center pb-5 :'
---

# Thank You!
