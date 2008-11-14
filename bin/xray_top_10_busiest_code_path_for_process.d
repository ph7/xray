#!/usr/sbin/dtrace -s
#pragma D option quiet
#pragma D option aggsortrev
#pragma D option dynvarsize=64m
#pragma D option ustackframes=64
#pragma D option strsize=2048

profile-997
/pid == $target/ 
{ 
    @num[ustack()] = count(); 
}