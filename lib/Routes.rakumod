use Cro::HTTP::Router;
use Cro::HTTP::Router::WebSocket;
use Cro::WebApp::Template;

use Exporter::Sqlite;

my $db = Exporter::Sqlite.new(database => 'tests.sqlite3');

sub routes() is export {
    route {
        get -> {
            template 'templates/greet.crotmp', {};
        }

        get -> 'data' {
            my $project_id = $db.get-project-id('intranet');

            my @tests = $db.get-tests("", "", "", $project_id);
            my %test_count;
            my @labels;
            my @values;
            for @tests -> %test {
                my $count = 0;
                for %test<numbers>.pairs.sort(*.key.Int) -> $number {
                    ++$count;
                }
                next unless $count > 1;

                @labels.push: %test<test>;
                @values.push: $count;
            }
            content 'application/json', {
                :@labels,
                :@values,
            };
        }

        get -> 'js',  *@path {
            static 'static/js',  @path;
        }

        my $chat = Supplier.new;
        get -> 'chat' {
            web-socket -> $incoming {
                supply {
                    whenever $incoming -> $message {
                        $chat.emit(await $message.body-text);
                    }
                    whenever $chat -> $text {
                        emit $text;
                    }
                }
            }
        }
    }
}
