#!/usr/sbin/dtrace -s 
#pragma D option quiet
#pragma D option dynvarsize=64m

/*
 * Trace all the probes of the ruby provider
 *
 * Usage:
 *
 *     sudo /usr/bin/xray_trace_all_ruby_probes.d -p <a pid>
 *
 *     sudo /usr/bin/xray_trace_all_ruby_probes.d -c "ruby -v"
 *
 *     sudo dtrace -s /usr/bin/xray_trace_all_ruby_probes.d -p <a pid>
 */

ruby$target::: 
{ 
    printf("=> cpu %2d == %-15.15s == %-15.15s == %s\n", cpu, probename, copyinstr(arg0), copyinstr(arg1)) 
}
