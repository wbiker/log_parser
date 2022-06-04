use Cro::HTTP::Router;
use Cro::HTTP::Router::WebSocket;
use Cro::WebApp::Template;

use Exporter::Sqlite;
use Model::Tests;

my $db = Exporter::Sqlite.new(database => 'tests.sqlite3');

sub routes() is export {
    route {
        template-location 'templates/';

        get -> {
            my $tests = Model::Tests.new(:$db);
            my @projects = $tests.get-projects();

            template 'greet.crotmp', { :@projects };
        }

        get -> 'project', Int $project_id {
            my $tests = Model::Tests.new(:$db);
            my $project-data = $tests.get-project($project_id);

            content 'application/json', {
                labels => $project-data<labels>,
                values => $project-data<values>,
            }
        }

        get -> 'data' {
            content 'application/json', { };
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
