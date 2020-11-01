bdelete_not_close.vim
---
wipe/delete/unload buffers, not windows

Author: Jo Totland\
Version: 1.0

Description
---

This plugin introduces three commands, mimicking the builtin commands
bunload, bdelete and bwipeout.

    BunloadNotClose
    BdeleteNotClose
    BwipeoutNotClose

As the builtin commands, these commands can take prefix range of buffers, or a
postfix list of buffers.

There is one difference however: these commands never close any windows (and by
transitivity, never closes any tabs either).

Algorithm
---

When a buffer is closed, for each window (on any tab) containing the buffer,
first the alternate-file is tried. If there is no alternate-file,
bprevious is tried. If there's no bprevious, then a message is printed:
"This is the last buffer". 

