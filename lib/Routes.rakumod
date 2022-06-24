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
            my $project-data = $tests.get-project(1);

            template 'index.crotmp', { :@projects, :$project-data };
        }

        get -> 'project', Int $project_id {
            my $tests = Model::Tests.new(:$db);
            my $project-data = $tests.get-project($project_id);

            content 'application/json', {
                labels     => $project-data<labels>,
                values     => $project-data<values>,
                tests      => $project-data<numbers>,
                test_files => $project-data<test_files>,
            }
        }

        get -> 'test_files', Int $test_file_id {
            my $tests = Model::Tests.new(:$db);
            my $test-file-data = $tests.get-test-file-data($test_file_id);

            dd $test-file-data;
            content 'application/json', {
                labels => $test-file-data<labels>,
                values => $test-file-data<values>,
                tests  => $test-file-data<numbers>,
            }
        }

        get -> 'month_view' {
            my $tests = Model::Tests.new(:$db);
            my @projects = $tests.get-projects();

            template 'month_view.crotmp', { :@projects };
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
