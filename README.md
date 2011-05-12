This is a suite of Perl modules intended for personal use.

Some of these modules are likely to be submitted to CPAN, some are not.

Installation
============

The following will create a folder called 'MC' containing all Perl modules in this repository.

	git submodule add git@github.com:hash-bang/MCPerl.git MC
	git submodule update --init

Updating
========
	cd MC
	git pull MC

Makefile
========
Dump the following into the root level Makefile

	update:
		cd MC
		git pull
