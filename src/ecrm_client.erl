-module(ecrm_client).
-author("Alexander").
-include("records.hrl").
-define(TIMEOUT, 1000).
%% API
-export([start_server/0, add_new/1, find_by_id/1, find_by_name/1, remove_by_id/1]).

start_server() ->
    case whereis(ecrm_server) of
        undefined ->
            Pid = spawn(ecrm_server, init, []),
            register(ecrm_server, Pid),
            {ok, Pid};
        Pid when is_pid(Pid) ->
            {ok, Pid}
    end.

add_new(Employee) ->
    bang(add_new, Employee).

find_by_id(Id) ->
    bang(find_by_id, Id).

find_by_name(Name) ->
    bang(find_by_name, Name).

remove_by_id(Id) ->
    bang(remove_by_id, Id).

%% @doc server communication abstraction
bang(Op, Data) ->
    Pid = whereis(ecrm_server),

    try
        Pid ! {self(), {Op, Data}},
        receive
            {_From, Result} ->
                Result;
            Unexpected ->
                throw({unexpected_response, Unexpected})
        after ?TIMEOUT ->
                erlang:error({time_out, "Timed out while waiting for response!"})

        end
    catch
        Exception:Reason -> {caught, Exception, Reason}
    end.