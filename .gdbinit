handle SIGTRAP nostop noprint
target remote :4242
monitor reset
load
break main
continue
