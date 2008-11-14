#!/usr/sbin/dtrace -s
#pragma D option quiet
#pragma D option dynvarsize=64m

dtrace:::BEGIN 
{
    printf("Tracing... Hit Ctrl-C to end.\n");
    depth = 0;
}


profile-997 
{
    @kernel[stack(20)]=count();
}



profile-997 
/arg1/       /* user level PC. Make sure that we are in user space */
{
    printf("%d\n", arg1);
    @userspace[execname, ustack(10)]=count();
}

END {
    trunc(@kernel, 10);
    trunc(@userspace, 10); 
    
    printf("%s", "\n =========== Top 10 Busiest Kernel Path =============\n");
    printa(@kernel);
    
     printf("%s", "\n =========== Top 10 Busiest User Path =============\n");
     printa(@userspace);
}