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

package MC::Input::Multiplexor;
use File::Basename qw/basename/;
our $VERSION = '0.1.0';
my $dir;
my $class_prefix;

=item new($directory = null)

Create a new Input::Multiplexor interface
If $dir is specified it is used as the valid list of interfaces, otherwise use 'dir()'.

=cut
sub new {
	my ($class, $dir, $prefix) = @_;
	my $self = {};
	bless $self;
	$self->dir($dir) if ($dir);
	$self->prefix($prefix) if ($prefix);
	return $self;
}

=item dir($directory)

Specify the directory to lookin for valid interfaces.

=cut
sub dir {
	my ($self, $dir) = @_;
	warn("Invalid directory: $dir") unless -d $dir;
	$self->{dir} = $dir;
}

=item class_prefix($prefix = null)

Use a specific prefix when invoking the new() method when using load()
This is useful if multiplexable module you are wanting to load exists in one directory but requires a prefix to its class name.

Without class_prefix set:

	package MyModule;
	$multiplexor = MC::Input::Multiplexor->new;
	$multiplexor->dir('UI');
	$multiplexor->load('GTK');
	# Tries to load a module called UI/GTK.pm with the class name UI::GTK;

With class_prefix set:

	package MyModule;
	$multiplexor = MC::Input::Multiplexor->new;
	$multiplexor->dir('UI');
	$multiplexor->class_prefix('MyModule');
	$multiplexor->load('GTK');
	# Tries to load a module called UI/GTK.pm with the class name B<MyModule::>UI::GTK;

Or:

	package MyModule;
	$multiplexor = MC::Input::Multiplexor->new('UI', 'MyModule');
	$multiplexor->load('GTK');

=cut
sub class_prefix {
	my ($self, $cprefix) = @_;
	$self->{class_prefix} = $cprefix;
}

=item load($interface)

Attempt to load into the given interface object.
This must pretain to a valid module in $dir/$Interface.pm (note ucfirst for $interface)
	
	$interface = MC::Input::Multiplexor->new('UI');

	# This will try and load UI/Debug.pm, replacing the original $interface
	$interface = $interface->load('debug');

=cut
sub load {
	my ($self, $interface, @args) = @_;
	$interface = ucfirst($interface);
	my $file = $self->{dir} . "/$interface.pm";
	warn("Invalid interface file: $file for selected interface: $interface") unless -f $file;

	require $file;
	$package = ($self->{class_prefix} ? $self->{class_prefix} . '::' : '') . $self->{dir} . "::$interface";
	$self = $package->new();
	return $self;
}

=item choices()

Returns an array of possible interfaces.
This equates to pretty much the glob of "$dir/*.pm"

=cut
sub choices {
	my ($self) = @_;
	warn("Directory not specified before choices() call") unless $self->{dir};
	return map { basename($_, '.pm') } glob($self->{dir} . '/*.pm');
}

=head1 BUGS

Quite probably.

Please report to author when found.

=head1 AUTHOR

Matt Carter <m@ttcarter.com>

=cut

1;
