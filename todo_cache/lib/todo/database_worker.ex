defmodule Todo.DatabaseWorker do
    use GenServer

    def start(db_folder) do
        GenServer.start(__MODULE__, db_folder)
    end

    def store(worker, key, data) do
        GenServer.cast(worker, {:store, key, data})
    end

    def get(worker, key) do
        GenServer.call(worker, {:get, key})
    end

    def init(db_folder) do
      File.mkdir_p(db_folder) #make sure the folder exists
      {:ok, db_folder}
    end
    
    #The handler function spawns the new worker process and immediately returns. While
    #the worker is running, the database process can accept new requests.
    def handle_cast({:store, key, data}, db_folder) do
        spawn(  fn-> 
                    file_name(db_folder, key)
                    |> File.write!(:erlang.term_to_binary(data))  
                end)

        {:noreply, db_folder}
    end

    #!!!!!!! For synchronous calls, this approach is slightly more complicated because you have
    #        to return the response from the spawned worker process:
    def handle_call({:get,key}, caller, db_folder) do
        
            data =  case File.read(file_name(db_folder, key))  do
                    {:ok, contents} -> :erlang.binary_to_term(contents)
                    _               -> nil
                    end     
        {:reply, data, db_folder}           # No reply from the database process
    end

    defp file_name(db_folder, key), do: "#{db_folder}/#{key}" 

end