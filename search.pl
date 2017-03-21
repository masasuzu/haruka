use strict;
use warnings;
use utf8;
use 5.18.0;
use Encode;

use Net::Twitter;

my $nt = Net::Twitter->new(
    traits   => [qw/API::RESTv1_1/],
    consumer_key        => $ENV{CONSUMER_KEY},
    consumer_secret     => $ENV{CONSUMER_SECRET},
    access_token        => $ENV{ACCESS_TOKEN},
    access_token_secret => $ENV{ACCESS_TOKEN_SECRET},
);

use YAML;
my $result = $nt->search(+{
    q    => 'from:@haruka_tachiba #橘カレンダー',
    lang => 'ja',
    count => 100,
    result_type => 'mixed',
});
my $data = [map {
    my $status = $_;
    my $datum = +{};

    $datum->{id}         = $status->{id};
    $datum->{created_at} = $status->{created_at};
    $datum->{text}       = $status->{text};
    $datum->{media_url} = [ map {
        $_->{expanded_url};
    } (@{$status->{extended_entities}->{media}})];

    $datum;

} (@{$result->{statuses}}) ];

say YAML::Dump($data);























