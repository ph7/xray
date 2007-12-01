#include "ruby.h"
static int id_push;

static VALUE t_init(VALUE self)
{
  VALUE arr;
  arr = rb_ary_new();
  rb_iv_set(self, "@arr", arr);
  return self;
}

static VALUE t_add(VALUE self, VALUE obj)
{
  VALUE arr;
  arr = rb_iv_get(self, "@arr");
  rb_funcall(arr, id_push, 1, obj);
  return arr;
}

static VALUE t_backtrace(VALUE self)
{
  return self;  
}

VALUE cTest;

void Init_xray() {
  cTest = rb_define_class("MyTest", rb_cObject);
  rb_define_method(cTest, "initialize", t_init, 0);
  rb_define_method(cTest, "add", t_add, 1);
  rb_define_method(rb_cThread, "xray_backtrace", t_backtrace, 0);
  id_push = rb_intern("push");
}

