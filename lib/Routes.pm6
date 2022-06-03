use Cro::HTTP::Router;
use Cro::HTTP::Router::WebSocket;
use Cro::WebApp::Template;

sub routes() is export {
    route {
        get -> {
            template 'templates/greet.crotmp', {};
        }

        get -> 'greet', $name {
            template 'templates/greet.crotmp', { :$name };
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
