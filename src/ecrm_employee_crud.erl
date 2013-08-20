-module(ecrm_employee_crud).
-author("Alexander").
-include("records.hrl").
-include("/usr/lib64/erlang/lib/stdlib-1.19.2/include/qlc.hrl").

%% API
-export([init/0, find_by_id/1, find_by_name/1, add_new/1, remove_by_id/1]).

%% CRUD operations

find_by_id(Id) ->
  {_, Result} = mnesia:transaction(fun() ->
    mnesia:read(employees, Id)
  end),
  Result.

find_by_name(Name) ->
  {_, Result} =
    mnesia:transaction(fun() ->
      Employees = mnesia:table(employees),
      Qh = qlc:q([U || U <- Employees,
        string:str(U#employee.first_name ++ " " ++ U#employee.last_name, Name) > 0]),
      qlc:eval(Qh) end),
  Result.

add_new(Employee) ->
  {_, Result} = mnesia:transaction(fun() -> mnesia:write(employees, Employee, write) end),
  Result.

remove_by_id(Id) ->
  {_, Result} = mnesia:transaction(fun() -> mnesia:delete(employees, Id, write) end),
  Result.

update(Employee = #employee{}) ->
  erlang:error(not_implemented).

update_or_create(Employee = #employee{}) ->
  erlang:error(not_implemented).


%% Utils

%% @doc checks if the element is unique (by id, mobile phone and e-mail)
%% if it isn't returns the conflicting element of the list.
check_unique(Employee = #employee{}) ->
  .

init() ->
  application:start(emongo),
  {ok, Mongo} = emongo:add_pool(pool1, "localhost", 27017, "ecrm", 1),
  Mongo.