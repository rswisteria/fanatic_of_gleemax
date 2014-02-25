%%%-------------------------------------------------------------------
%%% @author wisteria
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 2 2014 1:46
%%%-------------------------------------------------------------------
-module(my_behaviour).
-author("wisteria").

%% API
-export([behaviour_info/1]).

behaviour_info(callbacks) -> [{init, 1}, {some_fun, 0}, {other, 3}];
behaviour_info(_) -> undefined.
