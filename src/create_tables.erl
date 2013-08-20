-module(create_tables).
-author("Alexander").
-include("records.hrl").

%% API
-export([init_tables/0]).
%% creates tables needed for SEERP application
init_tables() ->
  mnesia:create_table(employees,
    [{type, set},{record_name, employee}, {attributes, record_info(fields, employee)}]).
