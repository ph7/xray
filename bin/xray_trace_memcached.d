#!/usr/sbin/dtrace -s
#pragma D option quiet
#pragma D option dynvarsize=64m


pid*:memcached:*do_item_update*:entry { 
    printf("COMMAND == %s \n", probefunc);
}

pid*:memcached:process_get_command:entry { 
    self->conn_id = arg0;
/*    self->pointer_to_string = copyin(arg1, 4); */
    printf("GET == connection %d == update %p %d\n", arg0, arg1, arg2);
}

pid*:memcached:process_update_command:entry { 
    self->conn_id = arg0;
/*    self->pointer_to_string = copyin(arg1, 4); */
    printf("UPDATE == connection %d == update %p %d\n", arg0, arg1, arg2);
}