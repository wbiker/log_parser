use Cro::HTTP::Router;
use Cro::HTTP::Router::WebSocket;
use Cro::WebApp::Template;

sub routes() is export {
    route {
        get -> {
            template 'templates/greet.crotmp', {};
        }

        get -> 'data' {
            content 'application/json', {
                labels => [1, 2, 3, 4],
                values => [23, 54, 23, 22],
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
