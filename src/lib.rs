#![feature(lang_items)]
#![no_std]

extern crate  rlibc;

#[no_mangle]
pub extern fn kmain () {}

#[lang = "eh_personality"] extern fn eh_personality () {}
#[lang = "panic_fmt"] extern fn panic_fmt () -> ! { loop {} }
