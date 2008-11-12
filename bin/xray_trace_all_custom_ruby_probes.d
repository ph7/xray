#!/usr/sbin/dtrace -s 
#pragma D option quiet

/*
 * Trace all the custom ruby probes defined in your application
 * using XRay::DTrace, Apple's DTracer or Joyent's Tracer module.
 *
 * Usage:
 *
 *     sudo /usr/bin/xray_trace_all_custom_ruby_probes.d -p <a pid>
 *
 *     sudo /usr/bin/xray_trace_all_custom_ruby_probes.d -c "ruby -v"
 *
 *     sudo dtrace -s /usr/bin/xray_trace_all_custom_ruby_probes.d -p <a pid>
 */

dtrace:::BEGIN
{
    printf("Tracing... Hit Ctrl-C to end.\n");
}

ruby$target:::ruby-probe
{
	printf("=> %d == cpu: %2d == %15s '%s'\n", timestamp, cpu, copyinstr(arg0), copyinstr(arg1))
}
