#!/usr/sbin/dtrace -s
#pragma D option quiet
#pragma D option aggsortrev
#pragma D option dynvarsize=64m

/*
 * Trace Rails controller actions and database response times.
 * 
 * Report average response time, total elapsed time and invocation count
 * for all controller actions and datase queries.
 *
 * Also print response time distribution diagrams for global and individual
 * action / query.
 *
 * Usage:
 *
 *     sudo /usr/bin/xray_trace_rails_response_times.d -p <a pid>
 *
 *     sudo /usr/bin/xray_trace_rails_response_times.d -c "ruby -v"
 *
 *     sudo dtrace -s /usr/bin/xray_trace_rails_response_times.d -p <a pid>
 */ 
this string name;
this string action;
this string query;

dtrace:::BEGIN 
{
    printf("Tracing... Hit Ctrl-C to end.\n");
    depth = 0;
}

ruby$target::ruby_dtrace_probe:
/(this->name = copyinstr(arg0)) == "request-start"/ 
{
    self->request_start[copyinstr(arg1)] = timestamp;
}


ruby$target::ruby_dtrace_probe:
/(this->name = copyinstr(arg0)) == "request-end" && self->request_start[(this->action = copyinstr(arg1))]/ 
{	
    this->elapsed = timestamp - self->request_start[this->action];
    @re_count[this->action] = count();
    @re_eavg[this->action] = avg(this->elapsed);
    @re_esum[this->action] = sum(this->elapsed);
    @re_edist[this->action] = quantize(this->elapsed);
    @re_all_edist["All Requests"] = quantize(this->elapsed);
    self->request_start[this->action] = 0;
}

ruby$target::ruby_dtrace_probe:
/(this->name = copyinstr(arg0)) == "db-start"/
{
    self->db_start[copyinstr(arg1)] = timestamp;
}


ruby$target::ruby_dtrace_probe:
/(this->name = copyinstr(arg0)) == "db-end" && self->db_start[(this->query = copyinstr(arg1))]/ 
{	
    @db_count[this->query] = count();
    this->elapsed = timestamp - self->db_start[this->query];
    @db_eavg[this->query] = avg(this->elapsed);
    @db_esum[this->query] = sum(this->elapsed);
    @db_edist[this->query] = quantize(this->elapsed);
    @db_all_edist["All Queries"] = quantize(this->elapsed);
    self->db_start[this->query] = 0;
}

dtrace:::END
{
    normalize(@re_eavg, 1000);
    normalize(@re_esum, 1000); 
    normalize(@db_eavg, 1000);
    normalize(@db_esum, 1000);

    printf("\n================================================\n");
    printf("        Controller Response Times\n");
    printf("================================================\n\n");

    setopt("aggsortpos", "0");   /* Sort on avg time */
    printf("%-50s %s\n", " _________ Action _________", "_ Avg. (us) _  Total (us) _ Count _\n");
    printa("%-50.50s %@12d %@12d %@6d\n", @re_eavg, @re_esum, @re_count);
    

    printf("\n================================================\n");
    printf("        Database Response Times\n");
    printf("================================================\n");

    setopt("aggsortpos", "0");   /* Sort on avg time */
    printf("%-100s %s\n", " _________ Query _________", "_ Avg. (us) _  Total (us) _ Count _\n");
    printa("%-100.100s %@12d %@12d %@6d\n", @db_eavg, @db_esum, @db_count);

    printf("\n================================================\n");
    printf("        Response Time Summary\n");
    printf("================================================\n\n");
    
    printa(@re_all_edist);
    printa(@db_all_edist);

    printf("\n================================================\n");
    printf("        Controller Response Time Distribution\n");
    printf("================================================\n\n");
    
    printa(@re_edist);

    printf("\n================================================\n");
    printf("        DB Response Time Distribution\n");
    printf("================================================\n\n");
    
    printa(@db_edist);    
}

