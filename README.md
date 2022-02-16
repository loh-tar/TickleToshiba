## TickleToshiba - An evil daemon to keep drowsy hard drives alive

This little bash script is my *"solution"* to *"fix"* my in Jan 2022 new purchased
**Toshiba DTX140** USB drive. All efforts to persuade the drive by *hdparm* or *hd-idle*
not to go to sleep after a few minutes of idle time was a wild-goose chase.

I was not amused!

On the Toshiba webside was a tool offered *ToshibaStorageDiagnosticTool*. Fine, but for
Microsoft Windows. I took that tool anyway, or rather I downloaded the zib-archive. Perhaps
I'm near some Windows PC in the future. Then we can see if it can fix the issue or if it
is for other purposes. To be fair, it wasn't promoted to fix the issue.

I noticed on the *world wide web* that other has the same problem, with other drive
manufacturers. I can't remember where, sorry, was noted that this approach here should be
a workaround. Hm...

I started with a minimal three-line-script which did the job well and ended up with this
fancy tool. It was my form of frustration management.

### How it works

    $ tickle-toshiba --help
    This is TickleToshiba version 0.8 - Feb 2022

    Usage: tickle-toshiba <seconds> <mount-point-to-tickle>
           tickle-toshiba --stop <mount-point-to-tickle>
           tickle-toshiba [--license] [--help|-h|-?]

    Task : Once started I will 'tickle' the given mount-point as an evil daemon until it's gone
           or I'm called to stop tickling at a given mount-point
    How? : I will write every <seconds> some data about my doing into a 'tickle-file',
           so write access is needed. Don't Panik! The file will not grow above a few byte
    Hint : Of cause I not only work with blasted Toshiba drives

But because running a daemon manually becomes quickly annoying, there are also handy systemd
service files available. See [tickle-toshiba.txt](./tickle-toshiba.txt) for details.

### Requierments

- bash >= 4.2

## Installation

### Manually

- Get and extract the source
- `cd` into the tree
- `sudo make install`

## License

    $ tickle-toshiba --license

    TickleToshiba - An evil daemon to keep drowsy hard drives alive

    The MIT License (MIT) Copyright © 2022 loh.tar@googlemail.com

    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the “Software”), to deal in
    the Software without restriction, including without limitation the rights to
    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
    the Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


## Which drive exactly?

    kernel: usb 2-1: new SuperSpeed USB device number 3 using xhci_hcd
    kernel: usb 2-1: New USB device found, idVendor=0480, idProduct=a301, bcdDevice= 0.00
    kernel: usb 2-1: New USB device strings: Mfr=2, Product=3, SerialNumber=1
    kernel: usb 2-1: Product: EXTERNAL_USB
    kernel: usb 2-1: Manufacturer: TOSHIBA

### Which command I tried?

Various. But I think the ultimate *hdparm* possible should be:

    # hdparm -B 255 -S 0 /dev/sda

    /dev/sda:
    setting Advanced Power Management level to disabled
    setting standby to 0 (off)
    APM_level      = off

At least according to the [Arch Wiki](https://wiki.archlinux.org/title/Hdparm#Power_management_configuration).
But after ~3min the drive shut down.

Then tried *hd-idl*:

    # hd-idle -d -i 0 -a sda -i 600
    probing sda: reads: 244436, writes: 0
    probing sda: reads: 244436, writes: 0   <-- the list was updated ~1/min
    probing sda: reads: 244436, writes: 0
    probing sda: reads: 244439, writes: 0
    probing sda: reads: 244439, writes: 0
    probing sda: reads: 244439, writes: 0   <-- ~5m30sec the drive shot down
    probing sda: reads: 244439, writes: 0
    ^C

## TODO/BUGS

- `tickle-@.service` has hard coded `<seconds>` parm of 160sec, so I guess a config file may helpful
- `tickle-@.service` did not support drive label with hyphen
- Convert `tickle-toshiba.txt` into a nice man page

## Thanks To

- stackoverflow.com, stackexchange.com for their great knowledge base
- dict.cc and deepl.com without which my english would be even worse
- github.com for kindly hosting
- Mom&Dad and archlinux.org

## Release History

### Very first version was 0.8 - Feb, 2022

- Hello World!
- We start with 0.8 because I think there is only little left what could be improved,
it's already more comprehensive as needed for the task. But some surprises may pop up
- I decided to choose seconds as sleep time parameter to avoid the possible cause that
a drive may just at a minute boundary attempt to go down
- To keep it reasonably simple is not the full *sleep* parameter setting supported
- The given `<seconds>` parm will sliced into short 5sec naps for better responding.
The drawback may that the given `<seconds>` will not kept accurate. Who cares?
- In theory should it also work to read from the drive to avoid the shut down. But
I guess not when always the same file is read, or directory e.g. by *ls &>/dev/null*.
But feel free to try it

