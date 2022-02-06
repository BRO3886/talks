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
---
layout: intro
hideInToc: true
title: 'About Me'
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

---
layout: section
hideInToc: true
level: 2
---

# What makes the refactored code easier to read?

---
layout: cover
---

# Small

<v-clicks>

- The first rule of functions is that they should be small. 

- The second rule of functions is that *they should be smaller than that*.

</v-clicks>

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

---
layout: default
---

# Prefer Exceptions to Returning Error Codes 

<br>

<v-clicks>

#### Command Query Separation:
Functions should either do something or answer something, but not both

* Returning error codes from command functions is a subtle violation of command query separation.


</v-clicks>

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

---
layout: statement
hideInToc: true
---
# But there's a catch
<div v-click>

If you keep your functions **small**, then the occasional multiple `return`, `break`, or `continue` statement does no harm and can sometimes even be more expressive than the single-entry, single-exit rule.

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

# Thank You!
