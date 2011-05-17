#!/usr/bin/perl
# Note that this package has a 'TestPackage' prefix
package TestPackage::Animals::Dog;

sub new {
	my $self = {};
	bless $self;
	return $self;
}

sub sound {
	return 'woof';
}

1;
