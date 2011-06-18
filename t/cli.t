#!/usr/bin/perl
use MC::Input::Cli;

say(0, "Hello there");
say(1, "Verbose greetings only");
say(2, "Debug level greetings!");

say(0, "Yey") if ask("Are you happy?");

if (ask("Heads or tails?", 'h', qw/h t/) eq 'h') {
	say(0, "You chose heads");
} else {
	say(0, "You chose tails");
}

if (ask("Delete everything?", 'n', qw/y n/)) {
	say('Ok...');
}

say(0, "Hello " . prompt("What is your name?"));
