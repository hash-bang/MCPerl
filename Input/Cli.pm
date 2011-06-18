=head1 NAME

Input::Cli - Simple CLI based input for command line interface programming

=head1 SYNOPSIS

	use Input::Cli;

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


=head1 DESCRIPTION

Provides a simple CLI based development environment.
This module exposes a number of useful functions which aids fast scripting for CLI projects requiring a minimal interface.

=cut

package MC::Input::Cli;
our $VERSION = '0.1.1';
use Term::ReadKey;
use Term::ReadLine;
require Exporter;
@ISA = qw/Exporter/;
@EXPORT = qw/$verbose fatal say ask prompt/;

=item $verbose

Specifies the verbosity level used by the say() function to determine how chatty it should be.

=cut
our $verbose = 0;

=item $readline

Internal Term::ReadLine interface

=cut

our $readline;
eval { # Prevent Term::ReadLIne fatally exiting if it cant grab a /dev/tty
	our $readline = Term::ReadLine->new('Input::Cli') or 0;
};

=item fatal($message)

Fatally exists a script with an exit code of 1
Optionally printing $message to STDERR

=cut
sub fatal {
	# Print an error message and fatally die
	print STDERR @_, "\n";
	exit 1;
}

=item say($level, $message)

Outputs a message if the set verbosity level is equal or higher than specified

=cut
sub say {
	# Print a message to STDERR based on the verbosity level
	our $verbose;
	my $verbosity = shift;
	print STDERR @_, "\n" if $verbose >= $verbosity;
}

=item ask($question, $default = 'y', @answers = qw/y n/)

Ask the user a question with a specified default and list of acceptable answers

If all possible answers are one character in length this function will not wait for a closing CR. Instead it grabs the first keypress given by the user.

=cut
sub ask {
	my $question = shift;
	my $default = shift;
	my @answers = @_;
	$question = 'Confirm' unless $question;
	$default = 'y' unless $default;
	@answers = qw/y n/ unless @answers;
	my $maxlen = 0;
	my $validate = join('|', map {
		quotemeta;
		$maxlen = length if (length > $maxlen);
	} @answers);
	$validate = qr/$validate/;

	while (1) {
		print STDERR $question, ' [', join(',', map { # Output: Question [opt1,opt2...]?
			($_ eq $default) ? uc($_) : $_; # Capitalize the default
		} @answers), '] ';

		ReadMode(3) if ($maxlen == 1); # No point waiting for CR if the max length is 1
		my $responce = lc(substr(ReadKey(0),0,1));
		ReadMode(0);
		print STDERR "\n";
		if ($responce =~ m/$validate/) {
			return $responce;
		} elsif (!$responce) { # No answer - assume default
			return $default;
		} else { # Invalid answer - complain and loop
			say(0, "Invalid responce");
		}
	}
}

=item prompt($question, $default = '', $validator = qx//)

Ask the user to input some text. An optional validation regexp can reprompt if failed.

=cut

sub prompt {
	my $question = shift;
	my $default = shift;
	my $validator = shift;
	my @history = @_;
	$readline->addhistory(@history) if (@history);
	INPUT: {
		$_ = $readline->readline("$question: ", $default);
		if ($validator and !/$validator/) {
			say(0, "Invalid responce");
			redo INPUT;
		}
	}
	$term = 0;
	return $_;
}

=head1 BUGS

Quite probably.

Please report to author when found.

=head1 AUTHOR

Matt Carter <m@ttcarter.com>

=cut

1;
