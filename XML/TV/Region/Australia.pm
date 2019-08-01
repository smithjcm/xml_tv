# XML::TV::Region::Australia

package XML::TV::Region::Australia;

use strict;
use warnings;
use diagnostics;

use vars qw($VERSION);

use JSON;
use XML::TV::Toolbox;
#use Data::Dumper;

my $VERSION = sprintf("%d.%d.%d.%d.%d.%d", q$Id: Australia.pm 700 2019-05-29 15:32:08Z  $ =~ /(\d+)-(\d+)-(\d+) (\d+):(\d+):(\d+)Z/);

sub new
{
	my $class = shift;
	my $self = {};
	bless $self;

	my %arg = @_;

	$self->debug(exists $arg{Debug} ? $arg{Debug} : undef);
	$self->verbose(exists $arg{Verbose} ? $arg{Verbose} : undef);
	# If we are passed a useragent use it, otherwise initialise a new one
	$self->ua(exists $arg{UA} ? $arg{UA} : XML::TV::Toolbox->new(Debug => $self->debug, Verbose => $self->verbose);

	$self->buildRegions();

	return $self;
}

# this just builds the regions array and is called on ->new()
sub buildRegions
{
	my $url = "https://www.yourtv.com.au/guide/";
	warn("XML::TV::Region::Australia fetching region list from: $url\n") if ($self->verbose);
	my $res = $ua->get($url);
	die("Unable to connect to $url.\n") if (!$res->is_success);
	my $data = $res->content;
	$data =~ s/\R//g;
	$data =~ s/.*window.regionState\s+=\s+(\[.*\]);.*/$1/;
	$self->regions(@{JSON->new->relaxed(1)->allow_nonref(1)->decode($data)});
}

# very simple return to get an array of modules used for the feeds
sub feeds
{
	return("Australia::YourTV", "Australia::ABCRadio", "Australia::SBSRadio");
}
	
sub ua
{
	my $self = shift;
	if (@_) {$self->{UA} = $_[0]};
	$self->{UA} = undef if (!defined $self->{UA});
	return $self->{UA};
}

sub debug
{
	my $self = shift;
	if (@_) {$self->{DEBUG} = $_[0]};
	$self->{DEBUG} = undef if (!defined $self->{DEBUG});
	return $self->{DEBUG};
}

sub verbose
{
	my $self = shift;
	if (@_) {$self->{VERBOSE} = $_[0]};
	$self->{VERBOSE} = undef if (!defined $self->{VERBOSE});
	return $self->{VERBOSE};
}

sub regions
{
	my $self = shift;
	if (@_) {$self->{REGIONS} = $_[0]};
	$self->{REGIONS} = undef if (!defined $self->{REGIONS});
	return $self->{REGIONS};
}

1;
