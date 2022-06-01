use Cro::HTTP::Log::File;
use Cro::HTTP::Server;
use Routes;

my Cro::Service $http = Cro::HTTP::Server.new(
    http => <1.1>,
    host => %*ENV<LOGS_HOST> ||
        die("Missing LOGS_HOST in environment"),
    port => %*ENV<LOGS_PORT> ||
        die("Missing LOGS_PORT in environment"),
    application => routes(),
    after => [
        Cro::HTTP::Log::File.new(logs => $*OUT, errors => $*ERR)
    ]
);
$http.start;
say "Listening at http://%*ENV<LOGS_HOST>:%*ENV<LOGS_PORT>";
react {
    whenever signal(SIGINT) {
        say "Shutting down...";
        $http.stop;
        done;
    }
}
