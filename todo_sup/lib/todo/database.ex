defmodule Todo.Database do
    use GenServer

    def start_link(db_folder) do
        GenServer.start_link(__MODULE__, db_folder, name: :database_server)
    end

    def store(key, data) do
        get_map(key)
        |> Todo.DatabaseWorker.store(key, data)
    end

    def get(key) do
        get_map(key)
        |>Todo.DatabaseWorker.get(key)
    end

    def get_worker() do
        GenServer.call(:database_server, {:get_worker_pid})
    end

    def get_map(key) do

        worker_map  = get_worker()
        index       = :erlang.phash2(key, 3)
        worker_map[index]
    end


    def handle_call( {:get_worker_pid},_from, worker_map ) do
        {:reply, worker_map, worker_map}
    end

    def init(db_folder) do
        
      worker_map = Map.new()
      |> Map.put(0, get_pid(Todo.DatabaseWorker.start_link(db_folder)))
      |> Map.put(1, get_pid(Todo.DatabaseWorker.start_link(db_folder)))
      |> Map.put(2, get_pid(Todo.DatabaseWorker.start_link(db_folder)))
      |> IO.inspect

      {:ok, worker_map}
    end
    
    def get_pid( tuple ) do
       {:ok, pid } =  tuple
       pid
    end

end