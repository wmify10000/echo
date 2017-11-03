-module(echo_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req, State) ->
    Path = cowboy_req:path(Req),
    handle1(Path, Req, State).
handle1(<<"/cgi">>, Req, State) ->
    ModFunBin = cowboy_req:parse_qs(Req),
    {ok, Bin, Req2} = cowboy_req:read_body(Req),
    Val = binary_to_list(Bin),
    Response = call(ModFunBin, Val),
    Req3 = cowboy_req:reply(200,
		#{<<"content-type">> => <<"text/plain">>},
		Response, Req2),
    {ok, Req3, State};
handle1(Path, Req, State) ->
    Response = read_file(Path),
    Req1 = cowboy_req:reply(200,
		#{<<"content-type">> => <<"text/plain">>},
		Response, Req),
    {ok, Req1, State}.

call([{<<"mod">>,MB},{<<"func">>,FB}], X) ->
    Mod = list_to_atom(binary_to_list(MB)),
    Func = list_to_atom(binary_to_list(FB)),
    apply(Mod, Func, [X]).

read_file(Path) ->
    File = [$.|binary_to_list(Path)],
    case file:read_file(File) of
        {ok, Bin} -> Bin;
        _ -> ["<pre>cannot read:", File, "</pre>"]
    end.

