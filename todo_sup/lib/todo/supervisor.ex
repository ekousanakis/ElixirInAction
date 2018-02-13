defmodule Todo.Supervisor do
    use Supervisor
    
    def start_link do
        Supervisor.start_link(__MODULE__, nil)

        # {:ok, sup } = Supervisor.start_link(__MODULE__, nil)
        # Supervisor.start_child(sup, worker(Todo.Cache, []))

    end

    def init(_) do
        # supervise [], strategy: :one_for_one
         processes = [worker(Todo.Cache,[])]
        supervise( processes, strategy: :one_for_one)
    end
end