use strict;
use warnings;
use utf8;
use 5.18.0;
use Encode;

use Twitter::API;

my $nt = Twitter::API->new_with_traits(
    traits              => 'Enchilada',
    consumer_key        => $ENV{CONSUMER_KEY},
    consumer_secret     => $ENV{CONSUMER_SECRET},
    access_token        => $ENV{ACCESS_TOKEN},
    access_token_secret => $ENV{ACCESS_TOKEN_SECRET},
);

use YAML;
my $result = $nt->get('statuses/user_timeline' => +{
    count => 200,
    screen_name => 'haruka_tachiba',
    trim_user => 1,
    exclude_replies => 1,
    include_rts => 0,
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

} grep {
    $_->{text} =~ m/#橘カレンダー/
} (@{$result}) ];

say YAML::Dump($data);























