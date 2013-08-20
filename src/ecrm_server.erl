-module(ecrm_server).
-author("Alexander").


%% API
-export([start/0]).

start() ->
  ecrm_employee_list_crud:init(),
  run_server().

run_server() ->
  receive
    {From, {add_new, Employee}} ->
      Result = ecrm_employee_list_crud:add_new(Employee),
      From ! {self(), Result},
      run_server();
    {From, {find_by_id, ID}} ->
      Result = ecrm_employee_list_crud:find_by_id(ID),
      From ! {self(), Result},
      run_server();
    {From, {find_by_name, Name}} ->
      Result = ecrm_employee_list_crud:find_by_name(Name),
      From ! {self(), Result},
      run_server();
    {From, {remove_by_id, ID}} ->
      Result = ecrm_employee_list_crud:remove_by_id(ID),
      From ! {self(), Result},
      run_server();
    {From, {update, _Employee}} ->
      From ! {self(), ok},
      run_server();
    {From, {update_or_create, _Employee}} ->
      From ! {self(), ok},
      run_server();
    stop -> {ok, "Shutdown signal received."};
    Unexpected ->
      io:format("Unexpected message recieved: ~n~p~n", Unexpected)
  end.