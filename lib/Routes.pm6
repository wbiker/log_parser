use Cro::HTTP::Router;
use Cro::HTTP::Router::WebSocket;
use Cro::WebApp::Template;

sub routes() is export {
    route {
        get -> {
            content 'text/html', "<h1> Logs </h1>";
            template 'templates/greet.crotmp', {};
        }

        get -> 'greet', $name {
            template 'templates/greet.crotmp', { :$name };
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
