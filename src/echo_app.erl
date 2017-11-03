-module(echo_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	Dispatch = cowboy_router:compile(
		[{'_',[
			{"/", cowboy_static, {priv_file, echo, "test2.html"}},
			{"/[...]", echo_handler, []}
		]}]
	),
	cowboy:start_clear(my_http_listener,
		[{port, 8080}],
		#{env => #{dispatch => Dispatch}}
	).

stop(_State) ->
	ok.
