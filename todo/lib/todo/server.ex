defmodule Todo.Server do
    use GenServer

    def start_link() do
        GenServer.start_link(__MODULE__, :no_args, name: __MODULE__)
    end

    def init(:no_args) do
        {:ok, Todo.List.new}
    end

    def add_entry(new_entry) do
        GenServer.cast __MODULE__, {:add_entry, new_entry}
    end
    
    def entries(date) do
        GenServer.call __MODULE__, {:entries, date}
    end

    def handle_cast({:add_entry, new_entry}, todo_list) do
        {:noreply, Todo.List.add_entry(todo_list, new_entry)}
    end
    def handle_call({:entries, date}, _from, todo_list ) do
        {:reply,  Todo.List.entries(todo_list, date), todo_list}
    end
end