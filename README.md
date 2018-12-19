# config-server
centralized configuration server for WaCoDiS components.

### dynamic configuration
use */actuator/refresh* endpoint to refresh the configuration of a specific service at runtime
`curl -X POST http://localhost:8080/actuator/refresh`  (localhost:8080 refers to the specific service)
  
use */actuator/bus-refresh* endpoint to refresh the configuration of every service at runtime
`curl -X POST http://localhost:8080/actuator/bus-refresh`  (localhost:8080 can refer to any service)  
By calling the */actuator/bus-refresh* endpoint of any service, a request to refresh its configuration is sent to every service via RabbitMQ broker.
  
Configuration values are only refreshed if *@RequestScope* annotation is present.
