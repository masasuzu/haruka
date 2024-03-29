use strict;
use warnings;
use utf8;
use 5.18.0;
use Encode;

use Twitter::API;
use YAML;

my $nt = Twitter::API->new_with_traits(
    traits              => 'Enchilada',
    consumer_key        => $ENV{CONSUMER_KEY},
    consumer_secret     => $ENV{CONSUMER_SECRET},
    access_token        => $ENV{ACCESS_TOKEN},
    access_token_secret => $ENV{ACCESS_TOKEN_SECRET},
);

sub get {
    my ($max_id) = @_;

    my $result = $nt->get('statuses/user_timeline' => +{
        count => 200,
        screen_name => 'haruka_tachiba',
        trim_user => 1,
        exclude_replies => 1,
        include_rts => 0,
        $max_id ? (max_id => $max_id ) : (),
    });


    my $data = [map {
        my $status = $_;
        my $datum = +{};

        $datum->{id}   = $status->{id};
        $datum->{text} = $status->{text};
        my ($month, $day) = $datum->{text} =~ m/([0-9]{1,2})\/([0-9]{1,2})/;
        if ($month && $day) {
            my $year = $month < 9 ? 2017 : 2016;

            $datum->{date} = "$year/$month/$day";
            $datum;
        }
        else {
            ();
        }
    } grep {
        $_->{text} =~ m/#橘カレンダー/
    } (@{$result}) ];

    return ($data, undef) unless scalar @{$result};

    return ($data, $result->[-1]->{id} -1);
}

my @statuses;
{
    my ($data, $id) = get();
    push @statuses, @{$data};
    while(1) {
        sleep 1;
        ($data, $id) = get($id);
        last unless $id;
        push @statuses, @{$data};
    }
}
say YAML::Dump(\@statuses);

