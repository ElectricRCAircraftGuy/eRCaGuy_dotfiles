# `goto` for Error Handling in C

By Gabriel Staples  
19 Apr. 2020 


## A strong argument for the constrained use of `goto` in C:

Using `goto` for general programming in C has been discouraged for decades, but for error handling, under certain, narrow constraints which put significant limitations on its use, it is a perfectly valid and useful tool. I have even been in organizations before where `goto` was *required* for error handling in C because it produces better, safer, cleaner, easier-to-read-and-maintain code, particularly in embedded C applications for safety-critical code running on microcontrollers or other low-level hardware. Again, in some of these situations, the virtues of `goto` in this use-case were made manifest again and again and again, and we were _required to use it_ in these narrow use-cases in order to produce the safest code possible. My own study and evaluation has led to the conclusion this was indeed the best practice and resulted in better, safer, more-readable, and more-maintainable code. 

[Example 6](https://vilimpoc.org/research/raii-in-c/) in the list of links below exemplifies this type of example: a lengthy initialization routine where each construction or hardware initialization could result in a unique error which requires specialized cleanup. File operations in C are also a great use-case, as nearly every single file operation possible in C can result in an error which requires you to close the file or perform some other distinct cleanup operation as a result. `goto` works perfectly for this, allowing you to jump to the end of a function and close _the correct file_ of _potentially many files you have open at once_ without having to jump through ridiculously complex and difficult-to-maintain nested `if` statements or odd state-carrying variables tested repeatedly with `if` statements. That being said, the usage of `goto` in C is highly disputed in industry because of the falsehood, I hypothesize, that it should *never* be used has been inculcated into so many people's minds by close-minded and unknowing professors. 

I do NOT encourage the use of `goto` anywhere EXCEPT in error handling and cleanup in functions, and it must follow strict limitations, usage style, and order. When used correctly, `goto` is a *powerful*, rich and *good* feature to enable *rigorous, safe, and easy-to-read and easy-to-maintain* error handling in C code. Although there is no question one can do *anything* in error handling withOUT the use of `goto` by using things such as multiple returns, cleanup macros, cleanup functions, gcc extensions for auto-cleanup, nested if statements, repeated variable testing, and other techniques, it is also undeniably true, based on my dozens of hours of study on the topic, and thousands of hours of experience with it, that `goto` is *the best tool for the job* in many error-handling and error-cleanup cases. It is so good at this that again, some organizations have standardized on its use as a *coding standard* and *enforce its usage* for *all error handling and function cleanup in C*. Perhaps you don't have to go so far as to make it mandatory in *all* cases, but I do believe it should be mandatorily used in at least *some* cases. For consistency's sake, however, you might as well just get used to using it and using it right by using it even in cases where alternatives are equally as simple (ie: making it a coding standard for your C code is probably a good idea too). Regardless of what you choose to do as a general rule of thumb for basic cleanup and error handling, when you do see your cleanup process getting complex, USE IT! DO use `goto`, just use it right!

## Here are some valuable links to learn how to properly use the `goto` statement in error handling and cleanup in C:

To learn *how* to use it properly, as well as to see many arguments and exapmles on *why* to use it for error handling and cleanup in C, here are some links which will help.

1. [Using goto for error handling in C, by Eli Bendersky](https://eli.thegreenplace.net/2009/04/27/using-goto-for-error-handling-in-c)
1. [Stack Overflow: Valid use of goto for error management in C?](https://stackoverflow.com/questions/788903/valid-use-of-goto-for-error-management-in-c)
1. [Error handling in C code](https://stackoverflow.com/questions/385975/error-handling-in-c-code/59221452#59221452) (my own answer, including a very basic `goto` usage in my example)
1. [Opaque C structs: how should they be declared?](https://stackoverflow.com/questions/3965279/opaque-c-structs-how-should-they-be-declared/54488289#54488289) (my own answer: "Option 1.5 ("Object-based" C Architecture)", incl. basic and proper `goto` usage for error handling throughout)
1. ["Linux Device Drivers, 2nd Edition" book, section "Error Handling in init_module"](https://www.xml.com/ldd/chapter/book/ch02.html#buierr), which shows `goto` used repeatedly in error handling
1. [raii in c](https://vilimpoc.org/research/raii-in-c/) (an EXCELLENT example showing a lengthy initialization _benefiting tremendously_ from the cleanup ability `goto` provides). 
    1. The author of this article says, "This article also comes from a sort of curiosity that I had to find an example of a situation where one actually _should_ use the goto command in C. I'd almost always heard it was bad practice, but it turns out actually to be very useful in extremely limited cases."
1. [Dijkstra's famous article against its use as a general tool](https://homepages.cwi.nl/~storm/teaching/reader/Dijkstra68.pdf) (I am also against its use as a general tool; error handling in C is the appropriate exception). Note: in case that link ever breaks, read a local copy of that article [in this repo here](Dijkstra68_searchable_GS_edit.pdf).



