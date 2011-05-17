#!/usr/bin/perl
use Test;
BEGIN { plan tests => 8 };

use MC::Input::Multiplexor;

$multiplexor = MC::Input::Multiplexor->new;
ok($multiplexor);
ok($multiplexor->dir('Animals'));
ok($animal = $multiplexor->load('Cat'));
ok($animal->sound, 'purr');

$multiplexor = MC::Input::Multiplexor->new;
ok($multiplexor);
ok($multiplexor->dir('Animals'));
ok($multiplexor->class_prefix('TestPackage'));
ok($animal = $multiplexor->load('Dog'));
ok($animal->sound, 'woof');
