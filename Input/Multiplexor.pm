=head1 NAME

Input::Multiplexor - Simple multiplexer for user input

=head1 SYNOPSIS

	use Input::Multiplexor;

	# Allow choices from ui/
	$interface = Input::Multiplexor('ui');

	# Read in the UI to choose from the command line (defaulting to 'auto')
	my $ui = shift or 'auto';

	# Attempt to become that interface
	unless ($interface = $interface->load($ui)) {
		print "Invalid interface: $ui\n";
		exit 1;
	}
	
	# Now we can use $interface as a shiv for UI::Auto (or UI::*)
	$interface->foo();

=head1 DESCRIPTION

Provides a simple multiplexor for projects where the user can choose between different interface methods.

=cut

package Input::Multiplexor;
our $VERSION = '0.1.0';
my $dir;

=item new($directory = null)

Create a new Input::Multiplexor interface
If $dir is specified it is used as the valid list of interfaces, otherwise use 'dir()'.

=cut
sub new {
	my ($class, $dir) = @_;
	my $self = {};
	bless $self;
	$self->dir($dir) if ($dir);
	return $self;
}

=item dir($directory)

Specify the directory to lookin for valid interfaces.

=cut
sub dir {
	my ($self, $dir) = @_;
	use Data::Dump;
	warn("Invalid directory: $dir") unless -d $dir;
	$self->{dir} = $dir;
}

=item become($interface)

Attempt to load into the given interface object.
This must pretain to a valid module in $dir/$Interface.pm (note ucfirst for $interface)
	
	$interface = Input::Multiplexor->new('UI');

	# This will try and load UI/Debug.pm, replacing the original $interface
	$interface = $interface->load('debug');

=cut
sub load {
	my ($self, $interface, @args) = @_;
	$interface = ucfirst($interface);
	my $file = $self->{dir} . "/$interface.pm";
	warn("Invalid interface file: $file for selected interface: $interface") unless -f $file;

	require $file;
	$package = $self->{dir} . "::$interface";
	$self = $package->new();
	return $self;
}

=head1 BUGS

Quite probably.

Please report to author when found.

=head1 AUTHOR

Matt Carter <m@ttcarter.com>

=cut

1;
