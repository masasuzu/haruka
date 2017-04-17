use strict;
use warnings;
use feature qw(say);

use YAML;
use Data::Section::Simple qw(get_data_section);
use Text::Xslate;


my $file = $ARGV[0];

my $data = YAML::LoadFile($file);
my $tx = Text::Xslate->new(
    syntax => 'Kolon', # optional
);

say $tx->render_string(get_data_section('index.tx'), +{ data => $data });

__DATA__

@@ index.tx
<!DOCTYPE html>
<html lang="ja">
  <body>
    : for $data -> $datum {
      <: $datum['date'] :><blockquote class="twitter-tweet" data-lang="ja" width="350"><p lang="ja" dir="ltr"><: $datum["text"] :></p><a href="https://twitter.com/haruka_tachiba/status/<: $datum["id"] :>"></a></blockquote>
    : }
    <script src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
  </body>
</html>
