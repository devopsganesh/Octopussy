package OneTool::Web::Template::Plugin::LogManagement::LogLevel;

=head1 NAME

OneTool::Web::Template::Plugin::LogManagement::LogLevel

=cut

use strict;
use warnings;
use base 'Template::Plugin';

use Mojo::UserAgent;

=head1 SUBROUTINES/METHODS

=head2 new()

=cut

sub new
{
    my ($class, $context, $params) = @_;

    bless {
        _CONTEXT    => $context,
        config      => $params,
        ua          => Mojo::UserAgent->new(),
        color       => undef
    }, $class;
}

=head2 configuration()

=cut

sub configuration
{
    my $self = shift;

    my $servers = $self->{config}->{applications}->{LogManagement}->{servers};

    foreach my $s (@{$servers})
    {
        my $res = $self->{ua}->get("$s/loglevel")->res;
        return ($res->json) if (defined $res->json);
    }

    return (undef);
}

=head2 label_color

=cut

sub label_color
{
    my ($self, $loglevel) = @_;
    
    if (!defined $self->{color})
    {
        my $list = $self->configuration();
        my %color = ();
        foreach my $l (@{$list})
        {
            $color{$l->{value}} = $l->{color};
        }
        $self->{color} = \%color;
    }
    
    return (qq{<font color='} . $self->{color}->{$loglevel} . qq{'>$loglevel</font>});
}

1;

=head1 AUTHOR

Sebastien Thebert <octopussy@onetool.pm>

=cut