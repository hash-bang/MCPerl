#!/usr/bin/perl

# Header {{{
package dbconflicts;
our $VERSION = '0.1.0';

use Input::Cli;
use IO::Handle;
use Getopt::Long;

Getopt::Long::Configure('bundling', 'ignorecase_always', 'pass_through');
STDERR->autoflush(1); # } Flush the output DIRECTLY to the output buffer without caching
STDOUT->autoflush(1); # }

use Data::Dump; # FIXME: Debugging modules
# }}} Header

# CLI {{{
GetOptions(
	'verbose|v+' => \$verbose,
);
# }}} CLI
