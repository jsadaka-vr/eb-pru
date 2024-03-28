import os
import json
import uuid
from pprint import pprint

import boto3



#{"experiment_source": "Demo-Kubernetes(EKS)-Worker Node (Pod)-State-TerminationCrash.yml",
#    "bucket_name": "resiliencyvr-package-build-bucket-demo",
#    "output_config": {
#        "S3": {
#            "bucket_name": "resiliencyvr-package-build-bucket-demo",
#            "path": "experiment_journals",
#        },
#}}


def sample_input(experiments):
    bucket_name = os.getenv("BUCKET_NAME")
    input_prefix = os.getenv("EXPERIMENT_PREFIX")
    result_prefix = os.getenv("RESULT_PREFIX")
    base_dict = {"Payload":{"List": []}}
    output_config = {"S3":{"bucket_name": bucket_name,
                            "path": result_prefix}}
    for experiment in experiments:
        event = {}
        event["bucket_name"] = bucket_name
        event["experiment_source"] = os.path.join(input_prefix, experiment)
        event["output_config"] = output_config
        base_dict["Payload"]["List"].append(event)
    return base_dict

def lambda_handler(event, context):
    experiments = ["Demo-Kubernetes(EKS)-Worker Node (Pod)-State-TerminationCrash.yml"]
    experiments = event.get("experiments", experiments)

    sfn = boto3.client("stepfunctions")
    sma = os.getenv("STATE_MACHINE_ARN")
    description = sfn.describe_state_machine(stateMachineArn=sma)

    pprint(description)
    input = sample_input(experiments)
    print("State Machine Input :")
    pprint(input)
    start_info = sfn.start_execution(stateMachineArn=sma, input=json.dumps(input))
    print("State Machine Execution Info")
    pprint(start_info)