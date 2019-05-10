package LWP::UserAgent::Patch::SetUserAgent;

# DATE
# VERSION

use 5.010001;
use strict;
no warnings;

use Module::Patch qw();
use base qw(Module::Patch);

our %config;

my $p_agent = sub {
    my $agent = $config{-agent} // $ENV{HTTP_USER_AGENT} or
        die "Either set -agent configuration or HTTP_USER_AGENT environment";
    $agent;
};

sub patch_data {
    return {
        v => 3,
        config => {
            -agent => {
                schema => 'str*',
            },
        },
        patches => [
            {
                action => 'replace',
                sub_name => '_agent',
                code => $p_agent,
            },
        ],
    };
}

1;
# ABSTRACT: Set User-Agent

=head1 SYNOPSIS

In Perl:

 use LWP::UserAgent::Patch::SetUserAgent -agent => "Blah/1.0";

From command-line:

 % perl -MLWP::UserAgent::Patch::SetUserAgent=-agent,'Blah/1.0' script-that-uses-lwp.pl ...
 % HTTP_USER_AGENT=Blah/1.0 perl -MLWP::UserAgent::Patch::SetUserAgent script-that-uses-lwp.pl ...


=head1 DESCRIPTION

This patch sets L<LWP::UserAgent>'s default User-Agent string, from
C<libwww-perl/XXX> to a value from either L</-agent> configuration or from
environment variable L</HTTP_USER_AGENT>.

You can still override it using the usual:

 my $ua = LWP::UserAgent->new(
     agent => '...',
     ...
 );

or

 $ua->agent('...');


=head1 CONFIGURATION

=head2 -agent

String.


=head1 ENVIRONMENT

=head2 HTTP_USER_AGENT

String. Used to set default for L</-agent> configuration.


=head1 SEE ALSO

If you want to check the sent User-Agent header in requests, you can use
L<Log::ger::For::LWP>.

=cut
