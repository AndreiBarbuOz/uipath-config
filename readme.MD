# UiPath Orchestator configuration model 

## Abstract

The result of RPA dev work is a combination of
 * workflows (organized as projects or libraries)
 * Orchestrator state
 
Orchestrator performs several functions vital to the overall automation process. It acts as a configuration server for the Robots, message queue and others. The success of an automation is dependent not only on the project itself, but on the synchronised work between the workflow files and the configuration assets residing on the server. 

For this, the **State** of the configuration existing on the Orchestrator needs to be captured and then replicated as the project is progressed through different environments

![UiPath RPA dev workflow](https://www.lucidchart.com/publicSegments/view/19e7fcd2-19bc-4c7f-918c-88ca352a1b4a/image.png)

We use a _desired state_ configuration in the project, describing the configuration needed on the Orchestrator. A `.json` file will contain a structure such as this:

```json
{
  "assets": [
    {
      "Name": "foo",
      "ValueType": "Text",
      "Value": "bar"
    },
    {
      "Name": "foo2",
      "ValueType": "Boolean",
      "Value": "true"
    },
    {
      "Name": "foo3",
      "ValueType": "Integer",
      "Value": 8
    }
  ],
  "queues": [
    {
      "Name": "queue-name-1"
    }
  ]
}
```

Based on this desired state, a difference between current Orchestrator state and desired one is built. This state will highlight the changes that take place, offering a way for understanding the impact of the application of the new state:

```json
{
  "assets": {
    "create": [
      {
        "NewValue": 8,
        "Name": "foo3",
        "NewType": "Integer"
      }
    ],
    "modify": [
      {
        "OldType": 4,
        "OldValue": "5",
        "NewValue": "true",
        "Name": "foo2",
        "NewType": "Boolean"
      }
    ]
  },
  "queues": {
    "create": [
      {
        "QueueName": "queue-name-1"
      }
    ]
  }
}
```

Deployment pipelines will have separate stages to progress the package containing the build artifact and Orchestrator state. 

- build artifacts
    - build the UiPath package
    - create the changes to be applied
- progress artifacts to UAT/Test/QA
    - manually or programatically validate changes to be applied
    - apply changes
    - upload package to UAT/Test/QA Orchestrator
    - perform tests, automated or manual
- progress arficats to Prod
    - apply changes to Prod
    - upload package

![saf](https://www.lucidchart.com/publicSegments/view/0cde55ca-50e1-4c28-9ff8-82f0cce06aa2/image.png)

## Installation

The [UiPath Orchestrator PoSh](https://github.com/UiPath/orchestrator-powershell) library needs to be installed. 

## Execution

A sample execution of the functions can be found in [doc manipulation template](https://github.com/AndreiBarbuOz/uipath-doc-manipulation)
