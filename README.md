# WaCoDiS Config
![Java CI](https://github.com/WaCoDiS/metadata-connector/workflows/Java%20CI/badge.svg)
  
The **WaCoDiS Config** is the centralized configuration server for all WaCoDiS components.

**Table of Content**  

1. [WaCoDiS Project Information](#wacodis-project-information)
  * [Architecture Overview](#architecture-overview)
2. [Overview](#overview)
  * [Modules](#modules)
  * [Utilized Technologies](#utilized-technologies)
3. [Installation / Building Information](#installation--building-information)
  * [Build from Source](#build-from-source)
  * [Build using Docker](#build-using-docker)
  * [Configuration](#configuration)
    * [Parameters](#parameters)
  * [Deployment](#deployment)
    * [Preconditions](#preconditions)
4. [User Guide](#user-guide)
  * [Run Config Server](#run-config-server)
    * [Using Docker](#using-docker)
5. [Contribution - Developer Information](#contribution---developer-information)
  * [Pending Developments](#pending-developments)
    * [Dynamic Configuration](#dynamic-configuration)
  * [Branching](#branching) 
  * [License and Third Party Lib POM Plugins](#license-and-third-party-lib-pom-plugins)
6. [Contact](#contact)
7. [Credits and Contributing Organizations](#credits-and-contributing-organizations)


## WaCoDiS Project Information
<p align="center">
  <img src="https://raw.githubusercontent.com/WaCoDiS/apis-and-workflows/master/misc/logos/wacodis.png" width="200">
</p>
Climate changes and the ongoing intensification of agriculture effect in increased material inputs in watercourses and dams.
Thus, water industry associations, suppliers and municipalities face new challenges. To ensure an efficient and environmentally
friendly water supply for the future, adjustments on changing conditions are necessary. Hence, the research project WaCoDiS
aims to geo-locate and quantify material outputs from agricultural areas and to optimize models for sediment and material
inputs (nutrient contamination) into watercourses and dams. Therefore, approaches for combining heterogeneous data sources,
existing interoperable web based information systems and innovative domain oriented models will be explored.

### Architecture Overview

For a detailed overview about the WaCoDiS system architecture please visit the 
**[WaCoDiS Core Engine](https://github.com/WaCoDiS/core-engine)** repository.  

## Overview  
All WaCoDiS components can use the **WaCoDiS Config Server** to fetch configuration files from a centralized server. The Config Server has a configuration file for each WaCoDiS component. These files must have the same name as the application/component (e.g. *core-engine.yml*).
### Modules
The WaCoDiS Config Server is a stand-alone Spring Boot application comprisiung only a single module.
### Utilized Technologies
* Java  
WaCoDiS Config uses (as most of the WaCoDiS components) the java programming language. WaCoDiS Config Server is tested with Oracle JDK 8 and OpenJDK 8. Unless stated otherwise later Java versions can be used as well.
* Maven  
The project WaCoDiS Config Server uses the build-management tool Apache [maven](https://maven.apache.org/)
* Spring Boot  
WaCoDiS Config Server is a standalone application built with the [Spring Boot](https://spring.io/projects/spring-boot) framework.
* Spring Cloud  
[Spring Cloud](https://spring.io/projects/spring-cloud) is used for exploiting some ready-to-use features in order to implement
an event-driven workflow. In particular, [Spring Cloud Stream](https://spring.io/projects/spring-cloud-stream) is used
for subscribing to asynchronous messages within thw WaCoDiS system.
* RabbitMQ  
For communication with other WaCoDiS components of the WaCoDiS system the message broker [RabbitMQ](https://www.rabbitmq.com/) is utilized. [See Pending Developments](#pending-developments)



## Installation / Building Information
### Build from Source
In order to build the WaCoDiS Config Server from source _Java Development Kit_ (JDK) must be available. Config Server
is tested with Oracle JDK 8 and OpenJDK 8. Unless stated otherwise later JDK versions can be used.  

Since this is a Maven project, [Apache Maven](https://maven.apache.org/) must be available for building it. Then, you
can build the project by running `mvn clean install` from root directory

### Build using Docker
The project contains a Dockerfile for building a Docker image. Simply run `docker build -t wacodis/config-server:latest .`
in order to build the image. You will find some detailed information about running the Config Server as Docker container
within the [run section](#using-docker) .

### Configuration
Configuration is fectched from configuration file *src/main/resources/application.yml*.   
#### Parameters
The following section contains descriptions for configuration parameters structured by configuration section.

##### spring/cloud/config/server/git
parameters related to messages on started processing jobs

| value     | description       | note  |
| ------------- |-------------| -----|
| uri     | uri of the git repository that hosts the configuration files | e.g. *https://github.com/WaCoDiS/config-server.git* |

This can direct to a local file by using the *file:* prefix, [see](https://cloud.spring.io/spring-cloud-config/multi/multi__spring_cloud_config_server.html#_git_backend)

##### spring/rabbitmq
parameters related to WaCoDis message broker, only needed when using dynamic configuration, (see[Pending Developments](#pending-developments)).

| value     | description       | note  |
| ------------- |-------------| -----|
| host | RabbitMQ host (WaCoDiS message broker) | e.g. *localhost* |
| port | RabbitMQ port (WaCoDiS message broker)   | e.g. *5672*|
| username | RabbitMQ username (WaCoDiS message broker)   | |
| password | RabbitMQ password (WaCoDiS message broker)   | |


### Deployment
This section describes deployment scenarios, options and preconditions.
#### Preconditions
* (without using Docker) In order to run Config Server Java Runtime Environment (JRE) (version >= 8) must be available. In order to [build Job Config Server from source](#installation--building-information) Java Development Kit (JDK) version >= 8) must be abailable. Job Config Server is tested with Oracle JDK 8 and OpenJDK 8.
* In order to enable on-the-fly configuration changes [RabbitMQ message broker](https://www.rabbitmq.com/) must be available. [See Pending Developments](#pending-developments)

## User Guide
### Run Config Server
Currently there are no pre-compiled binaries available for WaCoDiS Job Config Server. Job Config Server must be [built from source](#installation--building-information). Alternatively Docker can be used to (build and) run WaCoDiS Config Server.

Config Server is a Spring Boot application. Execute the compiled jar (`java -jar  config-server.jar`) or run *de.wacodis.ConfigServerApplication.java* in IDE to start the Config Server.

#### Using Docker
1. Build Docker Image from [Dockerfile](https://github.com/WaCoDiS/config-server/blob/master/Dockerfile) that resides in the project's root folder.
2. Run created Docker Image.

## Contribution - Developer Information
This section contains information for developers.

### Pending Developments

#### dynamic configuration

Config Server is capable of changing configuration values of a WaCoDiS component on the fly. This handled via the system's message broker (RabbitMQ). However, each component must reflect dynamic configuration changes correctly. Currently this is not the case for most WaCoDiS components or configuration parameters. Therefore this feature is not really usable at the current stage.

**how to use dynamic configuration:**

use */actuator/refresh* endpoint to refresh the configuration of a specific service at runtime  
`curl -X POST http://localhost:8080/actuator/refresh`  (localhost:8080 refers to the specific service)
  
use */actuator/bus-refresh* endpoint to refresh the configuration of every service at runtime  
`curl -X POST http://localhost:8080/actuator/bus-refresh`  (localhost:8080 can refer to any service)  
By calling the */actuator/bus-refresh* endpoint of any service, a request to refresh its configuration is sent to every service via RabbitMQ broker.
  
Configuration values are only refreshed if *@RequestScope* annotation is present.

### Branching
The master branch provides sources for stable builds. The develop branch represents the latest (maybe unstable) state of development.

### License and Third Party Lib POM Plugins
[optional]

## Contact
|    Name   |   Organization    |    Mail    |
| :-------------: |:-------------:| :-----:|
| Sebastian Drost | Bochum University of Applied Sciences | sebastian.drost@hs-bochum.de |
| Arne Vogt | Bochum University of Applied Sciences | arne.vogt@hs-bochum.de |
| Andreas Wytzisk  | Bochum University of Applied Sciences | andreas.wytzisk@hs-bochum.de |
| Matthes Rieke | 52° North GmbH | m.rieke@52north.org |

## Credits and Contributing Organizations
- Department of Geodesy, Bochum University of Applied Sciences, Bochum
- 52° North Initiative for Geospatial Open Source Software GmbH, Münster
- Wupperverband, Wuppertal
- EFTAS Fernerkundung Technologietransfer GmbH, Münster

The research project WaCoDiS is funded by the BMVI as part of the [mFund programme](https://www.bmvi.de/DE/Themen/Digitales/mFund/Ueberblick/ueberblick.html)  
<p align="center">
  <img src="https://raw.githubusercontent.com/WaCoDiS/apis-and-workflows/master/misc/logos/mfund.jpg" height="100">
  <img src="https://raw.githubusercontent.com/WaCoDiS/apis-and-workflows/master/misc/logos/bmvi.jpg" height="100">
</p>

