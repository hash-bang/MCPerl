#!/usr/bin/perl
package Animals::Cat;

sub new {
	my $self = {};
	bless $self;
	return $self;
}

sub sound {
	return 'purr';
}

1;
