use Cro::HTTP::Log::File;
use Cro::HTTP::Server;
use Routes;

my $host = %*ENV<LOGS_HOST> || '::';
my $port = %*ENV<LOGS_PORT> || 2323;

my Cro::Service $http = Cro::HTTP::Server.new(
    http => <1.1>,
    host => $host,
    port => $port,
    application => routes(),
    after => [
        Cro::HTTP::Log::File.new(logs => $*OUT, errors => $*ERR)
    ]
);
$http.start;
say "Listening at http://$host:$port";
react {
    whenever signal(SIGINT) {
        say "Shutting down...";
        $http.stop;
        done;
    }
}
