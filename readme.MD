# UiPath Orchestator configuration model 

## Abstract

The result of RPA dev work is a combination of
 * workflows (organized as projects or libraries)
 * Orchestrator state
 
Orchestrator performs several functions vital to the overall automation process. It acts as a configuration server for the Robots, message queue and others. The success of an automation is dependent not only on the project itself, but on the synchronised work between the workflow files and the configuration assets residing on the server. 

For this, the **State** of the configuration existing on the Orchestrator needs to be captured and then replicated as the project is progressed through different environments

![UiPath RPA dev workflow](https://www.lucidchart.com/publicSegments/view/19e7fcd2-19bc-4c7f-918c-88ca352a1b4a/image.png)
 
## Installation

The [UiPath Orchestrator PoSh](https://github.com/UiPath/orchestrator-powershell) library needs to be installed. 

## Execution

Run ``

