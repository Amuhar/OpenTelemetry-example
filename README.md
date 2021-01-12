Example of use [OpenTelemetry](https://github.com/open-telemetry/opentelemetry-erlang).

Stepts to run project:
 1. docker-compose build
 2. docker-compose up to start
 3. docker exec -it reader iex --sname test --cookie cookie
   
   iex(test@110acb60b05f)1> :rpc.call(:node@reader, Reader, :request_book, ["Alice", "It"])

 4. Open http://127.0.0.1:9411/ and run "Run query"


