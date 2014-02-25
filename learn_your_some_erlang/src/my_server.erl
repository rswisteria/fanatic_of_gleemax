%%%-------------------------------------------------------------------
%%% @author wisteria
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 2 2014 1:19
%%%-------------------------------------------------------------------
-module(my_server).
-author("wisteria").

%% API
-export([start/2, start_link/2, call/2, cast/2, reply/2]).

start(Module, InitialState) ->
  spawn(fun() -> init(Module, InitialState) end).

start_link(Module, InitialState) ->
  spawn_link(fun() -> init(Module, InitialState) end).

call(Pid, Msg) ->
  Ref = erlang:monitor(process, Pid),
  Pid ! {sync, self(), Ref, Msg},
  receive
    {Ref, Reply} ->
      erlang:demonitor(Ref, [flush]),
      Reply;
    {'Down', Ref, process, Pid, Reason} ->
      erlang:error(Reason)
  after 5000 ->
    erlang:error(timeout)
  end.

cast(Pid, Msg) ->
  Pid ! {async, Msg},
  ok.

reply({Pid, Ref}, Reply) ->
  Pid ! {Ref, Reply}.

init(Module, InitialState) ->
  loop(Module, Module:init(InitialState)).

loop(Module, State) ->
  receive
    {async, Msg} ->
      loop(Module, Module:handle_cast(Msg, State));
    {sync, Pid, Ref, Msg} ->
      loop(Module, Module:handle_call(Msg, {Pid, Ref}, State))
  end.
