#!/usr/sbin/dtrace -s 
#pragma D option quiet
#pragma D option aggsortrev
#pragma D option dynvarsize=64m

/* 
 * Trace all ruby function calls and display their total time, average time
 * an invocation number (slower first).
 *
 * Usage:
 *     xray_profile_ruby_function_calls.d -c "ruby -v"
 *     xray_profile_ruby_function_calls.d -p <a pid>
 *     dtrace -s xray_profile_ruby_function_calls.d -p <a pid>
 */
 
this string str;

dtrace:::BEGIN
{
   printf("Tracing, please be patient... Ctrl-C to interrupt.\n");
   depth = 0;
}

ruby$target:::function-entry
{
   self->depth++;
   self->start[copyinstr(arg0), copyinstr(arg1), self->depth] = timestamp;
}

ruby$target:::function-return
/(this->class = copyinstr(arg0)) != NULL && \
 (this->func  = copyinstr(arg1)) != NULL && \
 self->start[this->class, this->func, self->depth]/
{
    this->elapsed = timestamp - self->start[this->class, this->func, self->depth];
    @num[this->class, this->func] = count();
    @eavg[this->class, this->func] = avg(this->elapsed);
    @esum[this->class, this->func] = sum(this->elapsed);
    self->start[this->class, this->func, self->depth] = 0;
    self->depth--;
}

dtrace:::END
{
    normalize(@eavg, 1000);
    normalize(@esum, 1000);
    setopt("aggsortpos", "0");   /* Sort on total time */
    printf("%95s\n", "_______ ELAPSED ______");
    printf("%-40s %-30s %12s %10s %6s\n", "Class", "Method", "Total (us)", "Avg (us)", "Count\n");
    printa("%-40.40s %-30.30s %@12d %@10d %@6d\n", @esum, @eavg, @num);
}
